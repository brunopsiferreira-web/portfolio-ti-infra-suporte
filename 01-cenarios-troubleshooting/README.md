# Projeto 1: Base de conhecimento de troubleshooting

## Objetivo
Simular e documentar 4 incidentes comuns de help desk, aplicando diagnóstico estruturado e registrando causa raiz, solução e prevenção.

## Ambiente
- Hipervisor: VirtualBox 7.x
- VM: Windows 11 Enterprise (4 GB RAM, 2 CPUs, 40 GB de disco)
- Rede: NAT (cenários 1 e 2) e Rede Interna (cenário 3)
- Ferramentas: CMD, PowerShell, Visualizador de Eventos, Gerenciador de Tarefas

## Cenários

| # | Problema | Categoria | Ferramentas principais | Documentação | Vídeo |
|---|---|---|---|---|---|
| 1 | Sem internet (gateway incorreto) | Rede | `ipconfig`, `ping`, `netsh` | [Abrir](01-sem-internet/) | [▶](LINK_DO_VIDEO) |
| 2 | Conta de usuário bloqueada | Contas | `net user`, `net accounts` | [Abrir](02-conta-bloqueada/) | [▶](LINK_DO_VIDEO) |
| 3 | Computador lento | Desempenho | `Get-Process`, Gerenciador de Tarefas | [Abrir](03-computador-lento/) | [▶](LINK_DO_VIDEO) |
| 4 | Disco cheio | Armazenamento | `Get-PSDrive`, `cleanmgr` | [Abrir](04-disco-cheio/) | [▶](LINK_DO_VIDEO) |


## Metodologia de diagnóstico
1. **Entender o sintoma** e o impacto com o usuário
2. **Reproduzir/confirmar** o problema
3. **Isolar por camadas** (física → rede → nome → aplicação)
4. **Aplicar a correção mais simples e reversível** primeiro
5. **Validar** com o usuário
6. **Documentar** e propor prevenção


```
ping 127.0.0.1     → pilha TCP/IP local
ping IP-da-máquina → placa de rede
ping gateway       → rede local
ping 8.8.8.8       → internet por IP
ping google.com    → resolução de nomes (DNS)
```
O primeiro teste que falha indica a camada com problema.

## Cola de comandos
Veja [CHEATSHEET.md](CHEATSHEET.md).

## Aprendizados gerais
- Identificar os "sintomas" são essenciais para resolver o problema.
- Orientar os colaboradores/usuários, previne a maioria dos problemas.

## Voltar
[← Portfólio principal](../README.md)
