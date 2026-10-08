# Cola de comandos de diagnóstico (Windows)

| Objetivo | Comando |
|---|---|
| Ver configuração completa de rede | `ipconfig /all` |
| Renovar IP do DHCP | `ipconfig /release` e `ipconfig /renew` |
| Limpar cache DNS | `ipconfig /flushdns` |
| Testar conectividade | `ping <destino>` |
| Rastrear rota | `tracert -d <destino>` |
| Consultar DNS | `nslookup <nome>` |
| Tabela ARP (IP ↔ MAC) | `arp -a` |
| Conexões e portas | `netstat -ano` |
| Listar interfaces | `netsh interface show interface` |
| Processos por CPU | `Get-Process \| Sort-Object CPU -Descending \| Select -First 5` |
| Espaço em disco | `Get-PSDrive C` |
| Verificar arquivos do sistema | `sfc /scannow` |
| Reparar imagem do Windows | `DISM /Online /Cleanup-Image /RestoreHealth` |
| Usuário atual e grupos | `whoami /all` |
| Políticas aplicadas (GPO) | `gpresult /r` |
| Forçar atualização de GPO | `gpupdate /force` |
| Status de um serviço | `sc query <serviço>` |
| Log de eventos | `eventvwr` |
