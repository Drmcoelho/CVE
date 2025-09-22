#!/usr/bin/env bash
# Wrapper offline — usa gerador local, sem API.
set -euo pipefail
PROMPTS_JSON="$1"
QUERY="$2"
if [ -z "${PROMPTS_JSON:-}" ] || [ -z "${QUERY:-}" ]; then
  echo "Uso: $0 prompts/banks/domain_specific.json \"Sua pergunta\"" >&2
  exit 1
fi
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
python3 "$SCRIPT_DIR/llm_offline.py" "$PROMPTS_JSON" "$QUERY"