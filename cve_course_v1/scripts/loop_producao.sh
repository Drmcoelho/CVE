#!/usr/bin/env bash
# Orquestração de loop contínuo entre "Gemini CLI" e "Copilot GPT-5".
# Funciona em dois modos:
#  - offline: usa scripts/llm_offline.py via wrappers llm_gemini.sh e llm_gpt5.sh
#  - online: se detectar CLIs reais (gemini/gh+copilot), pode integrar futuramente
# Uso: scripts/loop_producao.sh [iteracoes]
set -euo pipefail
ITER=${1:-3}
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"
PROMPTS_JSON="$ROOT_DIR/prompts/banks/domain_specific.json"
LOG_DIR="$ROOT_DIR/.loop_logs"
mkdir -p "$LOG_DIR"

# Detecta CLIs reais (placeholders, não exigidos para offline)
HAVE_GEMINI=$(command -v gemini >/dev/null 2>&1 && echo 1 || echo 0)
HAVE_GH=$(command -v gh >/dev/null 2>&1 && echo 1 || echo 0)

# Entradas sementes
GEMINI_MSG="Revisar algoritmo de decisão para taquiarritmias instáveis"
GPT5_MSG="Gerar resumo do Módulo 1"

for i in $(seq 1 "$ITER"); do
  echo "[Loop] Iteração $i" | tee -a "$LOG_DIR/loop.log"
  # 1) Gemini comenta/revisa (offline/online)
  if [ "$HAVE_GEMINI" = "1" ] && [ -n "${GOOGLE_API_KEY:-}" ]; then
    echo "[Gemini] (online)" | tee -a "$LOG_DIR/loop.log"
    # Exemplo futuro: gemini text "$GEMINI_MSG"
    :
  else
    echo "[Gemini] (offline)" | tee -a "$LOG_DIR/loop.log"
    bash "$ROOT_DIR/scripts/llm_gemini.sh" "$PROMPTS_JSON" "$GEMINI_MSG" | tee "$LOG_DIR/gemini_${i}.txt"
  fi

  # 2) Copilot GPT-5 gera/refina a partir do feedback
  if [ "$HAVE_GH" = "1" ] && [ -n "${OPENAI_API_KEY:-}" ]; then
    echo "[Copilot GPT-5] (online via gh)" | tee -a "$LOG_DIR/loop.log"
    # Exemplo futuro: gh copilot ... (placeholder)
    :
  else
    echo "[Copilot GPT-5] (offline)" | tee -a "$LOG_DIR/loop.log"
    bash "$ROOT_DIR/scripts/llm_gpt5.sh" "$PROMPTS_JSON" "$GPT5_MSG" | tee "$LOG_DIR/gpt5_${i}.txt"
  fi

  # 3) Feedback recíproco simples (atualiza mensagens)
  GEMINI_MSG="Revisar: $(head -n 1 "$LOG_DIR/gpt5_${i}.txt" | sed 's/# //')"
  GPT5_MSG="Aprimorar com base em: $(head -n 1 "$LOG_DIR/gemini_${i}.txt" | sed 's/# //')"
  echo "[Atualizado] GEMINI_MSG='${GEMINI_MSG}'" | tee -a "$LOG_DIR/loop.log"
  echo "[Atualizado] GPT5_MSG='${GPT5_MSG}'" | tee -a "$LOG_DIR/loop.log"
  echo "---" | tee -a "$LOG_DIR/loop.log"
  sleep 0.2
done

echo "[Loop] Concluído. Logs em $LOG_DIR" | tee -a "$LOG_DIR/loop.log"
