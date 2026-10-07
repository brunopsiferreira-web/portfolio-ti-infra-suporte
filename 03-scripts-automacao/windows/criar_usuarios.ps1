# Cria usuários no Active Directory a partir de usuarios.csv
# Executar no controlador de domínio, como administrador.
Import-Module ActiveDirectory

$csvPath = Join-Path $PSScriptRoot "usuarios.csv"
$logPath = Join-Path $PSScriptRoot "criar_usuarios.log"
$dominio = "lab.local"
$baseDN  = "DC=lab,DC=local"
$senha   = ConvertTo-SecureString "Trocar@123" -AsPlainText -Force   # senha temporária fictícia

function Escrever-Log($msg) {
    $linha = "{0} {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $msg
    Write-Host $linha
    Add-Content -Path $logPath -Value $linha
}

$usuarios = Import-Csv -Path $csvPath -Delimiter ";" -Encoding UTF8

foreach ($u in $usuarios) {
    $ou = "OU=$($u.Departamento),OU=Usuarios,OU=Empresa,$baseDN"

    if (Get-ADUser -Filter "SamAccountName -eq '$($u.Login)'" -ErrorAction SilentlyContinue) {
        Escrever-Log "[PULADO] $($u.Login) ja existe"
        continue
    }

    try {
        New-ADUser -Name "$($u.Nome) $($u.Sobrenome)" `
                   -GivenName $u.Nome -Surname $u.Sobrenome `
                   -SamAccountName $u.Login `
                   -UserPrincipalName "$($u.Login)@$dominio" `
                   -Department $u.Departamento `
                   -Path $ou `
                   -AccountPassword $senha `
                   -Enabled $true `
                   -ChangePasswordAtLogon $true `
                   -ErrorAction Stop

        Add-ADGroupMember -Identity "GRP_$($u.Departamento)" -Members $u.Login -ErrorAction Stop
        Escrever-Log "[OK] $($u.Login) criado em $($u.Departamento) e adicionado ao grupo GRP_$($u.Departamento)"
    }
    catch {
        Escrever-Log "[ERRO] $($u.Login): $($_.Exception.Message)"
    }
}
Escrever-Log "Processo finalizado."
