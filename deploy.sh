#!/bin/bash

# ═══════════════════════════════════════════════════════════════
# 🚀 VPS DEPLOY SCRIPT - WhatsApp Bot
# ═══════════════════════════════════════════════════════════════
# Autor: VanGogh Dev
# Uso: ./deploy.sh <projeto> <vps_ip> <vps_user>
# ═══════════════════════════════════════════════════════════════

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Banner
echo -e "${CYAN}"
echo "═══════════════════════════════════════════════════════════════"
echo "                 🚀 VPS DEPLOY SCRIPT                          "
echo "═══════════════════════════════════════════════════════════════"
echo -e "${NC}"

# Check arguments
if [ $# -lt 3 ]; then
    echo -e "${YELLOW}Uso: $0 <diretorio_projeto> <vps_ip> <vps_user>${NC}"
    echo ""
    echo "Exemplo:"
    echo "  $0 ./meu-bot 192.168.1.100 root"
    echo ""
    exit 1
fi

PROJECT_DIR="$1"
VPS_IP="$2"
VPS_USER="$3"
DEPLOY_PATH="/opt/whatsapp-bot"

# Validate project directory
if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${RED}❌ Diretório não encontrado: $PROJECT_DIR${NC}"
    exit 1
fi

# Check for package.json
if [ ! -f "$PROJECT_DIR/package.json" ]; then
    echo -e "${RED}❌ package.json não encontrado em $PROJECT_DIR${NC}"
    exit 1
fi

echo -e "${GREEN}📦 Projeto: $PROJECT_DIR${NC}"
echo -e "${GREEN}🌐 VPS: $VPS_USER@$VPS_IP${NC}"
echo -e "${GREEN}📂 Deploy: $DEPLOY_PATH${NC}"
echo ""

# Step 1: Create tarball
echo -e "${CYAN}[1/5] 📦 Compactando projeto...${NC}"
cd "$PROJECT_DIR"
PROJECT_NAME=$(basename "$PROJECT_DIR")
tar -czf "/tmp/${PROJECT_NAME}.tar.gz" \
    --exclude='node_modules' \
    --exclude='.git' \
    --exclude='*.log' \
    --exclude='baileys_auth_info' \
    --exclude='database/*.db' \
    --exclude='.env' \
    .
echo -e "${GREEN}  ✅ /tmp/${PROJECT_NAME}.tar.gz criado${NC}"

# Step 2: Upload to VPS
echo ""
echo -e "${CYAN}[2/5] 📤 Enviando para VPS...${NC}"
scp "/tmp/${PROJECT_NAME}.tar.gz" "$VPS_USER@$VPS_IP:/tmp/"
echo -e "${GREEN}  ✅ Enviado${NC}"

# Step 3: Setup on VPS
echo ""
echo -e "${CYAN}[3/5] 📂 Configurando no servidor...${NC}"
ssh "$VPS_USER@$VPS_IP" << ENDSSH
    mkdir -p $DEPLOY_PATH
    cd $DEPLOY_PATH
    rm -rf ./* 2>/dev/null || true
    tar -xzf /tmp/${PROJECT_NAME}.tar.gz
    rm /tmp/${PROJECT_NAME}.tar.gz
    echo "  ✅ Extraído em $DEPLOY_PATH"
ENDSSH

# Step 4: Install dependencies
echo ""
echo -e "${CYAN}[4/5] 📦 Instalando dependências...${NC}"
ssh "$VPS_USER@$VPS_IP" << ENDSSH
    cd $DEPLOY_PATH
    
    # Check if Node.js is installed
    if ! command -v node &> /dev/null; then
        echo "Instalando Node.js..."
        curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
        apt-get install -y nodejs
    fi
    
    # Check if PM2 is installed
    if ! command -v pm2 &> /dev/null; then
        echo "Instalando PM2..."
        npm install -g pm2
    fi
    
    # Install dependencies
    npm install --production
    echo "  ✅ Dependências instaladas"
ENDSSH

# Step 5: Start with PM2
echo ""
echo -e "${CYAN}[5/5] 🚀 Iniciando aplicação...${NC}"
ssh "$VPS_USER@$VPS_IP" << ENDSSH
    cd $DEPLOY_PATH
    
    # Check for .env
    if [ ! -f ".env" ]; then
        if [ -f ".env.example" ]; then
            cp .env.example .env
            echo "  ⚠️  Criado .env a partir do .env.example"
            echo "  ⚠️  EDITE O .env ANTES DE USAR!"
        fi
    fi
    
    # Start/Restart with PM2
    pm2 delete $PROJECT_NAME 2>/dev/null || true
    pm2 start index.js --name $PROJECT_NAME
    pm2 save
    
    echo ""
    echo "  ✅ Aplicação iniciada!"
ENDSSH

# Cleanup
rm "/tmp/${PROJECT_NAME}.tar.gz" 2>/dev/null || true

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}                    ✅ DEPLOY CONCLUÍDO!                        ${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}📋 Comandos úteis:${NC}"
echo "  ssh $VPS_USER@$VPS_IP 'pm2 logs $PROJECT_NAME'     # Ver logs"
echo "  ssh $VPS_USER@$VPS_IP 'pm2 restart $PROJECT_NAME'  # Reiniciar"
echo "  ssh $VPS_USER@$VPS_IP 'pm2 stop $PROJECT_NAME'     # Parar"
echo ""
echo -e "${YELLOW}⚠️  Não esqueça de editar o .env no servidor:${NC}"
echo "  ssh $VPS_USER@$VPS_IP 'nano $DEPLOY_PATH/.env'"
echo ""
