#!/usr/bin/env bash
# Publica no GitHub Pages via mkdocs gh-deploy.
if ! command -v mkdocs >/dev/null 2>&1; then
  echo "[ERRO] mkdocs não encontrado. Rode scripts/00_bootstrap.sh ou instale manualmente."
  exit 1
fi
echo "[*] Publicando no GitHub Pages..."
mkdocs gh-deploy --force || { echo "[ERRO] gh-deploy falhou"; exit 1; }
echo "[OK] Publicado."
