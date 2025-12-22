#!/usr/bin/env bash
# Instala MkDocs e dependências mínimas; checa gh CLI.
set -uo pipefail

LOG_FILE="${TMPDIR:-/tmp}/mkdocs_bootstrap.log"
: > "$LOG_FILE"

echo "[*] Preparando ambiente local..."
echo "[*] Logs detalhados: $LOG_FILE"

pip_install_mkdocs() {
  {
    echo "== pip install mkdocs =="
    python3 -m pip install --upgrade pip
    python3 -m pip install mkdocs
  } >>"$LOG_FILE" 2>&1
}

ensure_mkdocs() {
  if command -v mkdocs >/dev/null 2>&1; then
    echo "[OK] MkDocs já instalado: $(mkdocs --version | head -n1)"
    return 0
  fi

  echo "[*] Instalando MkDocs via pip..."
  if pip_install_mkdocs; then
    echo "[OK] MkDocs instalado via pip."
    return 0
  fi

  echo "[!] pip falhou (possível bloqueio de rede). Tentando apt-get..."
  APT_BIN="$(command -v apt-get || true)"
  if [ -z "$APT_BIN" ]; then
    echo "[ERRO] apt-get não disponível; instale MkDocs manualmente (pip install mkdocs)."
    return 1
  fi

  SUDO_BIN="$(command -v sudo || true)"
  if [ -n "$SUDO_BIN" ]; then
    SUDO_BIN="$SUDO_BIN "
  fi

  {
    echo "== apt-get install mkdocs =="
    ${SUDO_BIN}${APT_BIN} update -y
    ${SUDO_BIN}${APT_BIN} install -y mkdocs
  } >>"$LOG_FILE" 2>&1

  if command -v mkdocs >/dev/null 2>&1; then
    echo "[OK] MkDocs instalado via apt-get."
    return 0
  fi

  echo "[ERRO] Não foi possível instalar MkDocs. Consulte $LOG_FILE e tente manualmente (pip install mkdocs)."
  return 1
}

ensure_mkdocs || exit 1

if ! command -v gh >/dev/null 2>&1; then
  echo "[!] gh CLI não encontrado. Instale-o para automação GitHub."
fi

echo "[OK] Ambiente pronto."
