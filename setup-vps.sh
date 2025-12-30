#!/bin/bash

# ═══════════════════════════════════════════════════════════════
# 🔧 VPS INITIAL SETUP - Preparar VPS para bots WhatsApp
# ═══════════════════════════════════════════════════════════════
# Autor: VanGogh Dev
# Testado em: Ubuntu 20.04/22.04, Debian 11/12
# ═══════════════════════════════════════════════════════════════

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
echo "═══════════════════════════════════════════════════════════════"
echo "          🔧 VPS INITIAL SETUP - WhatsApp Bots                 "
echo "═══════════════════════════════════════════════════════════════"
echo -e "${NC}"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}❌ Execute como root: sudo $0${NC}"
    exit 1
fi

# Step 1: Update system
echo -e "${CYAN}[1/7] 📦 Atualizando sistema...${NC}"
apt-get update && apt-get upgrade -y
echo -e "${GREEN}  ✅ Sistema atualizado${NC}"

# Step 2: Install essentials
echo ""
echo -e "${CYAN}[2/7] 🔧 Instalando pacotes essenciais...${NC}"
apt-get install -y \
    curl \
    wget \
    git \
    htop \
    nano \
    unzip \
    build-essential \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release
echo -e "${GREEN}  ✅ Pacotes instalados${NC}"

# Step 3: Install Node.js 20
echo ""
echo -e "${CYAN}[3/7] 📦 Instalando Node.js 20...${NC}"
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt-get install -y nodejs
fi
echo -e "${GREEN}  ✅ Node.js $(node -v) instalado${NC}"

# Step 4: Install PM2
echo ""
echo -e "${CYAN}[4/7] 🔄 Instalando PM2...${NC}"
if ! command -v pm2 &> /dev/null; then
    npm install -g pm2
    pm2 startup
fi
echo -e "${GREEN}  ✅ PM2 instalado${NC}"

# Step 5: Install Docker (optional)
echo ""
echo -e "${CYAN}[5/7] 🐳 Instalando Docker...${NC}"
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com | sh
    systemctl enable docker
    systemctl start docker
fi
echo -e "${GREEN}  ✅ Docker $(docker -v | cut -d' ' -f3 | tr -d ',') instalado${NC}"

# Step 6: Install Docker Compose
echo ""
echo -e "${CYAN}[6/7] 🐳 Instalando Docker Compose...${NC}"
if ! command -v docker-compose &> /dev/null; then
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi
echo -e "${GREEN}  ✅ Docker Compose instalado${NC}"

# Step 7: Configure firewall
echo ""
echo -e "${CYAN}[7/7] 🔥 Configurando firewall...${NC}"
if command -v ufw &> /dev/null; then
    ufw allow ssh
    ufw allow 80/tcp
    ufw allow 443/tcp
    ufw allow 3000/tcp
    ufw allow 8080/tcp
    ufw --force enable
    echo -e "${GREEN}  ✅ Firewall configurado${NC}"
else
    echo -e "${YELLOW}  ⚠️ UFW não encontrado, pulando...${NC}"
fi

# Create bot directory
mkdir -p /opt/whatsapp-bot
chmod 755 /opt/whatsapp-bot

# Summary
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}                  ✅ SETUP CONCLUÍDO!                           ${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${CYAN}📋 Instalado:${NC}"
echo "  • Node.js $(node -v)"
echo "  • NPM $(npm -v)"
echo "  • PM2 $(pm2 -v)"
echo "  • Docker $(docker -v | cut -d' ' -f3 | tr -d ',')"
echo ""
echo -e "${CYAN}📂 Diretório para bots: /opt/whatsapp-bot${NC}"
echo ""
echo -e "${YELLOW}🚀 Próximo passo:${NC}"
echo "  Use ./deploy.sh para fazer deploy do seu bot"
echo ""
