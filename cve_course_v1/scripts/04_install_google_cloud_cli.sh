#!/usr/bin/env bash
# Instala Google Cloud CLI (gcloud) em Ubuntu/Debian e checa versão.
# Requisitos: privilégios de apt na VM/contêiner.
set -euo pipefail

if command -v gcloud >/dev/null 2>&1; then
  echo "[OK] gcloud já instalado: $(gcloud --version | head -n1)"
  exit 0
fi

echo "[*] Instalando dependências para repositório do Google..."
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates gnupg curl

echo "[*] Adicionando chave e repositório do Google Cloud SDK..."
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/cloud.google.gpg

# Detecta codename do Ubuntu
CODENAME=$(grep UBUNTU_CODENAME /etc/os-release | cut -d= -f2 || echo noble)
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
  sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list >/dev/null

echo "[*] Instalando google-cloud-cli..."
sudo apt-get update -y
sudo apt-get install -y google-cloud-cli

echo "[OK] Instalação concluída. Versão:"
gcloud --version | head -n 3
