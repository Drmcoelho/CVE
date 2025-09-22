#!/usr/bin/env bash
# Constrói e serve MkDocs localmente (porta 8000).
echo "[*] Construindo site..."
mkdocs build || { echo "[ERRO] mkdocs build falhou"; exit 1; }
echo "[*] Servindo em http://127.0.0.1:8000"
mkdocs serve -a 0.0.0.0:8000