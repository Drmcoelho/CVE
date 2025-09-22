#!/usr/bin/env bash
# Publica no GitHub Pages via mkdocs gh-deploy.
echo "[*] Publicando no GitHub Pages..."
mkdocs gh-deploy --force || { echo "[ERRO] gh-deploy falhou"; exit 1; }
echo "[OK] Publicado."