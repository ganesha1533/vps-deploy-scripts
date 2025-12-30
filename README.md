# 🚀 VPS Deploy Scripts

<div align="center">

![Bash](https://img.shields.io/badge/Bash-4.0+-green.svg)
![Ubuntu](https://img.shields.io/badge/Ubuntu-20.04%2B-orange.svg)
![Debian](https://img.shields.io/badge/Debian-11%2B-red.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

**Scripts automatizados para deploy de bots WhatsApp em VPS**

</div>

---

## 📋 Scripts Incluídos

| Script | Descrição |
|--------|-----------|
| `setup-vps.sh` | Configura VPS do zero (Node.js, PM2, Docker) |
| `deploy.sh` | Faz deploy de projeto Node.js para VPS |
| `backup.sh` | Backup automático de dados |
| `monitor.sh` | Monitoramento de recursos |

## 🔧 setup-vps.sh

Prepara uma VPS nova para rodar bots WhatsApp.

### O que instala:

- ✅ Node.js 20 LTS
- ✅ NPM
- ✅ PM2 (Process Manager)
- ✅ Docker & Docker Compose
- ✅ Git, curl, htop, nano
- ✅ Firewall (UFW) configurado

### Uso:

```bash
# No servidor (como root)
wget https://raw.githubusercontent.com/ganesha1533/vps-deploy-scripts/main/setup-vps.sh
chmod +x setup-vps.sh
./setup-vps.sh
```

### Portas abertas:

- 22 (SSH)
- 80 (HTTP)
- 443 (HTTPS)
- 3000 (Apps)
- 8080 (APIs)

## 🚀 deploy.sh

Faz deploy de um projeto Node.js para a VPS.

### Uso:

```bash
# Na sua máquina local
./deploy.sh <diretorio_projeto> <ip_vps> <usuario>

# Exemplo
./deploy.sh ./meu-bot 192.168.1.100 root
```

### O que faz:

1. 📦 Compacta o projeto (excluindo node_modules, .git, logs)
2. 📤 Envia para o servidor via SCP
3. 📂 Extrai em `/opt/whatsapp-bot`
4. 📦 Instala dependências
5. 🚀 Inicia com PM2

### Pré-requisitos:

- SSH configurado para o servidor
- Chave SSH ou senha
- Projeto com `package.json`

## 💾 backup.sh

Faz backup dos dados importantes.

```bash
./backup.sh <diretorio_bot> <diretorio_destino>

# Exemplo
./backup.sh /opt/whatsapp-bot /backup/bots
```

### O que salva:

- 📁 Pasta `database/`
- 📁 Pasta `baileys_auth_info/`
- 📄 Arquivo `.env`
- 📄 Arquivos de configuração

## 📊 monitor.sh

Monitora recursos da VPS.

```bash
./monitor.sh
```

### Exibe:

- 💻 Uso de CPU
- 🧠 Uso de memória
- 💾 Uso de disco
- 🔄 Processos PM2
- 🐳 Containers Docker

## 📁 Estrutura

```
├── setup-vps.sh      # Setup inicial da VPS
├── deploy.sh         # Deploy de projetos
├── backup.sh         # Backup de dados
├── monitor.sh        # Monitoramento
└── README.md         # Documentação
```

## 🖥️ VPS Recomendadas

| Provedor | Config Mínima | Preço |
|----------|---------------|-------|
| Contabo | 4 vCPU, 8GB RAM | ~€5/mês |
| Hetzner | 2 vCPU, 4GB RAM | ~€4/mês |
| DigitalOcean | 2 vCPU, 4GB RAM | $24/mês |
| Vultr | 2 vCPU, 4GB RAM | $24/mês |

**Requisitos mínimos para bot WhatsApp:**
- 2 vCPU
- 2GB RAM
- 20GB SSD
- Ubuntu 20.04+ ou Debian 11+

## 🔐 Dicas de Segurança

```bash
# 1. Troque a porta SSH
sudo nano /etc/ssh/sshd_config
# Port 22 -> Port 2222

# 2. Desabilite login root
# PermitRootLogin no

# 3. Use chaves SSH
ssh-keygen -t ed25519
ssh-copy-id user@server

# 4. Instale fail2ban
sudo apt install fail2ban
```

## 📋 Comandos Úteis

```bash
# PM2 - Gerenciar processos
pm2 list              # Listar processos
pm2 logs <app>        # Ver logs
pm2 restart <app>     # Reiniciar
pm2 stop <app>        # Parar
pm2 delete <app>      # Remover

# Docker
docker ps             # Containers rodando
docker logs <id>      # Logs do container
docker restart <id>   # Reiniciar

# Sistema
htop                  # Monitor de recursos
df -h                 # Espaço em disco
free -h               # Memória
```

## ⚠️ Aviso

- Sempre faça backup antes de atualizações
- Teste em ambiente de desenvolvimento primeiro
- Use senhas fortes e chaves SSH
- Mantenha o sistema atualizado

## 📄 Licença

MIT License

---

<div align="center">

### 🎨 Desenvolvido por **VanGogh Dev**

[![GitHub](https://img.shields.io/badge/GitHub-ganesha1533-black?style=flat&logo=github)](https://github.com/ganesha1533)
[![WhatsApp](https://img.shields.io/badge/WhatsApp-+595%20987%20352983-25D366?style=flat&logo=whatsapp)](https://wa.me/595987352983)

**☕ Me apoie:**

[![Crypto](https://img.shields.io/badge/Donate-Crypto-orange?style=flat&logo=bitcoin)](https://plisio.net/donate/phlGd6L5)
[![Donate](https://img.shields.io/badge/Donate-PIX%2FOther-green?style=flat)](https://vendas.snoopintelligence.space/#donate)

</div>
