##  Olá 👋

Este repositório reúne laboratórios práticos que simulam problemas reais do dia a dia. Cada um segue o mesmo caminho:
**problema → diagnóstico → solução → documentação**, alguns com um vídeo curto mostrando o funcionamento.

<p align="center">
  <img src="https://img.shields.io/badge/Windows%20Server-2022-0078D4?style=for-the-badge&logo=windows&logoColor=white" alt="Windows Server">
  <img src="https://img.shields.io/badge/Active%20Directory-GPO-2f81f7?style=for-the-badge" alt="Active Directory">
  <img src="https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white" alt="PowerShell">
  <!-- <img src="https://img.shields.io/badge/Linux-Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white" alt="Ubuntu"> -->
  <img src="https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white" alt="Bash">
  <img src="https://img.shields.io/badge/VirtualBox-183A61?style=for-the-badge&logo=virtualbox&logoColor=white" alt="VirtualBox">
</p>
--------------------------------------------------------------------------------------------------------------------------------------------------------------

## 🗂️ Projetos

<table>
  <tr>
    <td width="33%"><a href="01-cenarios-troubleshooting/">📋 Projeto 1: Troubleshooting</a></td>
    <td width="33%"><a href="02-active-directory/">📋 Projeto 2: Active Directory e GPO></a></td>
    <td width="33%"><a href="03-scripts-automacao/">📋 Projeto 3: Automação</a></td>
  </tr>
  <tr valign="top">
    <td>Reprodução e diagnóstico de <b>4 incidentes</b> comuns: sem internet, DNS, conta bloqueada, PC lento e disco cheio.</td>
    <td>Domínio <code>lab.local</code> do zero: OUs, grupos, usuários, <b>GPOs</b>, pasta compartilhada com permissões por grupo e rotinas de suporte.</td>
    <td>Scripts para <b>diagnóstico de rede, limpeza, inventário</b>, criação de usuários em lote no AD, backup e alerta de disco no Linux.</td>
  </tr>
  <tr>
    <td align="center"><a href="01-cenarios-troubleshooting/">📖 Documentação</a></td>
    <td align="center"><a href="02-active-directory/">📖 Documentação</a></td>
    <td align="center"><a href="03-scripts-automacao/">📖 Documentação</a></td>
  </tr>
</table>

<!--
  PRÉVIAS EM GIF (opcional, deixa o portfólio muito mais vivo):
  1. Crie um GIF de 5 a 8 segundos de cada projeto (veja COMO-PUBLICAR.md)
  2. Salve em assets/previews/ e remova os comentários abaixo

<p align="center">
  <img src="assets/previews/sem-internet.gif" width="30%">
  <img src="assets/previews/active-directory.gif" width="30%">
  <img src="assets/previews/automacao.gif" width="30%">
</p>
-->

---

## 🔎 Acesso rápido aos cenários de troubleshooting

Cada linha leva direto à documentação do cenário e ao vídeo, sem precisar navegar pelas pastas.

| # | Problema | Camada | Ferramentas | Documentação | Vídeo |
|:-:|---|---|---|:-:|:-:|
| 1 | Sem internet (gateway incorreto) | Rede | `ipconfig` `ping` `netsh` | [Abrir](01-cenarios-troubleshooting/01-sem-internet/) | [▶](https://www.youtube.com/watch?v=82-pPgGI5r8) |
| 2 | Conta de usuário bloqueada | Contas | `net user` | [Abrir](01-cenarios-troubleshooting/02-conta-bloqueada/) | [▶](LINK_DO_VIDEO) |
| 3 | Computador lento | Desempenho | `Get-Process` | [Abrir](01-cenarios-troubleshooting/03-computador-lento/) | [▶](LINK_DO_VIDEO) |
| 4 | Disco cheio | Armazenamento | `Get-PSDrive` `cleanmgr` | [Abrir](01-cenarios-troubleshooting/04-disco-cheio/) | [▶](LINK_DO_VIDEO) |

---

## 🧭 Active Directory + GPO

<p align="center">
  <img src="assets/card-active-directory.svg" alt="Active Directory" width="100%">
</p>

---

## 🏗️ Ambiente do laboratório

<p align="center">
  <img src="assets/topologia-lab.svg" alt="Topologia do laboratório" width="85%">
</p>

---

## </> Automação

<p align="center">
  <img src="assets/card-automacao.svg" alt="Automação" width="85%">
</p>

---

## 🧰 Tecnologias e o que pratiquei

| Área | O que fiz | Ferramentas |
|---|---|---|
| **Redes** | Diagnóstico por camadas, IP, gateway, DNS, ARP | `ipconfig` `ping` `tracert` `nslookup` `arp` |
| **Windows Server** | Controlador de domínio, DNS, compartilhamentos | AD DS, DNS, SMB, NTFS |
| **Active Directory** | OUs, grupos, usuários, GPOs, reset e desbloqueio | `gpmc.msc` `Set-ADAccountPassword` `Unlock-ADAccount` |
| **Automação** | Diagnóstico, limpeza, inventário, usuários em lote | Batch, PowerShell, Bash, cron |
| **Virtualização** | Laboratório com snapshots e redes isoladas | VirtualBox |

### 💡 Diferencial
Venho de sistemas corporativos: já trabalhei com **parametrização, regras de negócio, SQL, PostgreSQL, APIs REST e Laravel**.
Isso me ajuda a entender o problema do usuário e a conversar com times técnicos e de negócio, além de automatizar o que é repetitivo.

---

<details>
<summary><b>📁 Estrutura do repositório</b></summary>

```
portfolio-ti-infra-suporte/
├── README.md                          ← você está aqui
├── assets/                            ← ilustrações do portfólio
├── 01-cenarios-troubleshooting/
│   ├── README.md                      ← índice + metodologia
│   ├── CHEATSHEET.md                  ← cola de comandos
│   ├── 01-sem-internet/   ... 09-impressora-ip-dinamico/
├── 02-active-directory/
│   ├── README.md
│   └── passo-a-passo.md
└── 03-scripts-automacao/
    ├── README.md
    ├── windows/   (.bat, .ps1, .csv)
    └── linux/     (.sh)
```
</details>

> Todos os usuários, senhas, domínios e IPs usados nos laboratórios são **fictícios**.

---
