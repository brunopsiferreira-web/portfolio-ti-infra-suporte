# Passo a passo: Active Directory + GPO

> Todos os nomes, senhas e IPs são fictícios, usados apenas no laboratório.

## 1. Planejamento

| Item | Servidor | Cliente |
|---|---|---|
| Nome | SRV-DC01 | PC-CLI01 |
| SO | Windows Server 2022 (Desktop Experience) | Windows 11 Enterprise (ou 10 Pro) |
| RAM / Disco | 4 GB / 50 GB | 4 GB / 40 GB |
| Rede | Rede Interna `labnet` | Rede Interna `labnet` |
| IP | 192.168.10.10 /24 | 192.168.10.20 /24 |
| DNS | 192.168.10.10 | 192.168.10.10 |

Domínio: `lab.local` · NetBIOS: `LAB`

> Windows Home **não** ingressa em domínio. Use Pro ou Enterprise.

## 2. Preparar o servidor

1. Criar a VM no VirtualBox e instalar Windows Server 2022 (Standard, Desktop Experience).
2. Adaptador de rede: **Rede Interna** `labnet`.
3. Snapshot: `so-instalado`.

Em PowerShell como administrador:
```powershell
Get-NetAdapter
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 192.168.10.10 -PrefixLength 24
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 192.168.10.10
Rename-Computer -NewName "SRV-DC01" -Restart
```

## 3. Instalar o AD DS e promover a controlador de domínio
```powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

Install-ADDSForest `
  -DomainName "lab.local" `
  -DomainNetbiosName "LAB" `
  -InstallDns `
  -SafeModeAdministratorPassword (ConvertTo-SecureString "Restore@12345" -AsPlainText -Force) `
  -Force
```
A VM reinicia. Entre como `LAB\Administrator`.

Validação:
```powershell
Get-ADDomain
Get-Service NTDS, DNS
```
Snapshot: `dc-pronto`.

## 4. Estrutura de OUs
```powershell
$base = "DC=lab,DC=local"
New-ADOrganizationalUnit -Name "Empresa" -Path $base
New-ADOrganizationalUnit -Name "Usuarios" -Path "OU=Empresa,$base"
New-ADOrganizationalUnit -Name "Computadores" -Path "OU=Empresa,$base"
New-ADOrganizationalUnit -Name "Grupos" -Path "OU=Empresa,$base"
New-ADOrganizationalUnit -Name "Desativados" -Path "OU=Empresa,$base"
foreach ($d in "TI","RH","Financeiro") {
  New-ADOrganizationalUnit -Name $d -Path "OU=Usuarios,OU=Empresa,$base"
}
```

## 5. Grupos e usuários
```powershell
$base = "DC=lab,DC=local"
foreach ($d in "TI","RH","Financeiro") {
  New-ADGroup -Name "GRP_$d" -GroupScope Global -GroupCategory Security -Path "OU=Grupos,OU=Empresa,$base"
}

$senha = ConvertTo-SecureString "Trocar@123" -AsPlainText -Force

New-ADUser -Name "Maria Souza" -GivenName Maria -Surname Souza -SamAccountName maria.souza `
  -UserPrincipalName maria.souza@lab.local -Path "OU=RH,OU=Usuarios,OU=Empresa,$base" `
  -AccountPassword $senha -Enabled $true -ChangePasswordAtLogon $true

New-ADUser -Name "Carlos Lima" -GivenName Carlos -Surname Lima -SamAccountName carlos.lima `
  -UserPrincipalName carlos.lima@lab.local -Path "OU=Financeiro,OU=Usuarios,OU=Empresa,$base" `
  -AccountPassword $senha -Enabled $true -ChangePasswordAtLogon $true

Add-ADGroupMember -Identity GRP_RH -Members maria.souza
Add-ADGroupMember -Identity GRP_Financeiro -Members carlos.lima
```
Criação em massa a partir de CSV: ver [Projeto 3](../03-scripts-automacao/).

## 6. Ingressar o cliente no domínio

1. Criar a VM cliente (Rede Interna `labnet`).
2. IP fixo e DNS apontando para o DC:
```powershell
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 192.168.10.20 -PrefixLength 24
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 192.168.10.10
```
3. Testar antes de ingressar:
```cmd
ping 192.168.10.10
nslookup lab.local
```
4. Ingressar no domínio:
```powershell
Add-Computer -DomainName "lab.local" -Credential LAB\Administrator -NewName "PC-CLI01" -Restart
```
5. Entrar com `LAB\maria.souza` (será solicitada a troca da senha).
6. No DC, mover o computador para a OU correta:
```powershell
Get-ADComputer PC-CLI01 | Move-ADObject -TargetPath "OU=Computadores,OU=Empresa,DC=lab,DC=local"
```
Snapshot: `cliente-no-dominio`.

## 7. Pasta compartilhada
No DC:
```powershell
New-Item -Path C:\Compartilhado\Financeiro -ItemType Directory -Force
New-SmbShare -Name "Financeiro" -Path "C:\Compartilhado\Financeiro" -FullAccess "LAB\GRP_Financeiro"
```
Na aba **Segurança** (NTFS) da pasta: remover "Usuários" e deixar `GRP_Financeiro` (Modificar) e Administradores.

> Quando há permissão de compartilhamento e NTFS, vale a mais restritiva.

## 8. GPOs
Abra `gpmc.msc` (Gerenciamento de Política de Grupo) no DC.

### GPO 1: Bloquear Painel de Controle (OU RH)
1. Botão direito na OU `RH` > "Criar um GPO neste domínio e vinculá-lo aqui" > `GPO_BloquearPainelControle`.
2. Editar > Configuração do Usuário > Políticas > Modelos Administrativos > Painel de Controle.
3. **Proibir o acesso ao Painel de Controle e às configurações do PC** = Habilitado.

### GPO 2: Mapear unidade de rede (OU Financeiro)
1. Vincular à OU `Financeiro`: `GPO_MapearUnidadeFinanceiro`.
2. Configuração do Usuário > Preferências > Configurações do Windows > Mapeamentos de Unidade > Novo.
3. Ação: Criar · Local: `\\SRV-DC01\Financeiro` · Letra: `F:` · Rótulo: Financeiro.

### GPO 3: Política de senha e bloqueio (todo o domínio)
Editar a **Default Domain Policy** (política de senha de domínio só vale nesse nível):

Configuração do Computador > Políticas > Configurações do Windows > Configurações de Segurança > Políticas de Conta:

| Política | Valor |
|---|---|
| Comprimento mínimo da senha | 8 |
| Complexidade | Habilitada |
| Validade máxima | 90 dias |
| Limite de bloqueio | 3 tentativas |
| Duração do bloqueio | 15 minutos |
| Redefinir contador após | 15 minutos |

## 9. Validar as GPOs (no cliente)
```cmd
gpupdate /force
gpresult /r
gpresult /h C:\relatorio-gpo.html
```
- `maria.souza`: Painel de Controle bloqueado.
- `carlos.lima`: unidade `F:` mapeada automaticamente.
- Tirar prints do `gpresult` mostrando as GPOs aplicadas.

## 10. Chamados de suporte

### A) "Esqueci minha senha"
```powershell
Set-ADAccountPassword -Identity maria.souza -Reset -NewPassword (ConvertTo-SecureString "Nova@12345" -AsPlainText -Force)
Set-ADUser -Identity maria.souza -ChangePasswordAtLogon $true
```
Alternativa gráfica: Usuários e Computadores do AD > botão direito no usuário > Redefinir senha.

### B) "Minha conta bloqueou"
1. No cliente, errar a senha de `carlos.lima` 3 vezes.
2. No DC:
```powershell
Search-ADAccount -LockedOut | Select Name, SamAccountName, LockedOut
Unlock-ADAccount -Identity carlos.lima
```
3. Investigar a origem do bloqueio no log de Segurança do DC (evento **4740**).

### C) "Preciso de acesso à pasta do Financeiro"
```powershell
Add-ADGroupMember -Identity GRP_Financeiro -Members novo.usuario
```
Acesso é concedido por **grupo**, não por usuário individual.

### D) Funcionário desligado
```powershell
Disable-ADAccount -Identity maria.souza
Move-ADObject -Identity (Get-ADUser maria.souza).DistinguishedName -TargetPath "OU=Desativados,OU=Empresa,DC=lab,DC=local"
```
