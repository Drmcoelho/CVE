#!/usr/bin/env bash
# Instala MkDocs e dependências mínimas; checa gh CLI.
echo "[*] Preparando ambiente local..."
python3 -m pip install --upgrade pip >/dev/null 2>&1
python3 -m pip install mkdocs >/dev/null 2>&1
if ! command -v gh >/dev/null 2>&1; then
  echo "[!] gh CLI não encontrado. Instale-o para automação GitHub."
fi
echo "[OK] Ambiente pronto."