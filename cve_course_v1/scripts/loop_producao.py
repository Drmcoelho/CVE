#!/usr/bin/env python3
"""
Loop de produção Gemini ⇄ Copilot GPT-5

Suporta:
- Modo offline (fallback): usa scripts/llm_offline.py via wrappers bash
- Modo online (configurável): lê comandos das variáveis de ambiente
  - GEMINI_CMD: comando para gerar resposta do Gemini
  - COPILOT_CMD: comando para gerar resposta do Copilot GPT-5
    Observação: os comandos podem conter o placeholder {msg}; se ausente, a
    mensagem será passada via stdin.

Critério de parada:
- Máximo de iterações (--iters)
- Regex de objetivo atingido em alguma resposta (--goal)

Artefato:
- Se --artifact for fornecido, salva a saída consolidada em arquivo a cada
  iteração; se atingir o objetivo, finaliza cedo e grava a versão final.

Exemplos:
  # Offline (sem CLIs) — 3 iterações, objetivo simples, escreve artefato
  python3 scripts/loop_producao.py \
    --iters 3 \
    --goal "Módulo 1|Nota de Prontuário" \
    --artifact docs/modules/_auto_m1.md

  # Online (quando CLIs existirem), usando placeholder {msg}
  GEMINI_CMD='gemini text -m gemini-1.5-pro {msg}' \
  COPILOT_CMD='gh copilot chat --model gpt-4o-mini -p {msg}' \
  python3 scripts/loop_producao.py --iters 3 --goal "Outline"
"""
from __future__ import annotations

import argparse
import os
import re
import shlex
import subprocess
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PROMPTS_JSON = ROOT / "prompts/banks/domain_specific.json"
LOG_DIR = ROOT / ".loop_logs"


def run_cmd_with_msg(cmd_template: str, msg: str) -> str:
    """Executa um comando com mensagem.

    - Se o template contiver {msg}, substitui por versão com aspas seguras.
    - Senão, envia a mensagem via stdin.
    """
    if "{msg}" in cmd_template:
        quoted = shlex.quote(msg)
        cmd = cmd_template.format(msg=quoted)
        res = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    else:
        res = subprocess.run(cmd_template, shell=True, input=msg, capture_output=True, text=True)
    if res.returncode != 0:
        return f"[ERRO cmd] rc={res.returncode}\nSTDERR:\n{res.stderr.strip()}\nSTDOUT parciais:\n{res.stdout.strip()}"
    return res.stdout


def run_gemini(msg: str) -> str:
    gemini_cmd = os.environ.get("GEMINI_CMD")
    if gemini_cmd:
        return run_cmd_with_msg(gemini_cmd, msg)
    # fallback offline
    cmd = f"bash {shlex.quote(str(ROOT / 'scripts/llm_gemini.sh'))} {shlex.quote(str(PROMPTS_JSON))} {shlex.quote(msg)}"
    res = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    return res.stdout if res.returncode == 0 else f"[ERRO gemini offline] {res.stderr.strip()}"


def run_copilot(msg: str) -> str:
    copilot_cmd = os.environ.get("COPILOT_CMD")
    if copilot_cmd:
        return run_cmd_with_msg(copilot_cmd, msg)
    # fallback offline
    cmd = f"bash {shlex.quote(str(ROOT / 'scripts/llm_gpt5.sh'))} {shlex.quote(str(PROMPTS_JSON))} {shlex.quote(msg)}"
    res = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    return res.stdout if res.returncode == 0 else f"[ERRO copilot offline] {res.stderr.strip()}"


def head_line(text: str) -> str:
    for line in text.splitlines():
        if line.strip():
            return line.strip().lstrip("# ")
    return "(vazio)"


def consolidate_content(gemini_out: str, copilot_out: str) -> str:
    return (
        "# Iteração (consolidado)\n\n"
        "## Saída Gemini\n" + gemini_out.strip() + "\n\n"
        "## Saída Copilot GPT-5\n" + copilot_out.strip() + "\n"
    )


def goal_met(texts: list[str], goal_regex: str | None) -> bool:
    if not goal_regex:
        return False
    pat = re.compile(goal_regex, flags=re.IGNORECASE | re.MULTILINE)
    return any(pat.search(t or "") for t in texts)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--iters", type=int, default=3, help="máximo de iterações")
    ap.add_argument("--goal", type=str, default=None, help="regex do objetivo a ser atingido")
    ap.add_argument("--artifact", type=str, default=None, help="arquivo para salvar conteúdo consolidado por iteração")
    ap.add_argument("--min-score", type=float, default=None, help="se definido, exige pontuação mínima via judge")
    ap.add_argument("--gemini-msg", type=str, default="Revisar algoritmo de decisão para taquiarritmias instáveis")
    ap.add_argument("--gpt5-msg", type=str, default="Gerar resumo do Módulo 1")
    args = ap.parse_args()

    LOG_DIR.mkdir(parents=True, exist_ok=True)
    artifact_path = Path(args.artifact) if args.artifact else None

    gemini_msg = args.gemini_msg
    gpt5_msg = args.gpt5_msg

    for i in range(1, args.iters + 1):
        # Gemini
        gemini_out = run_gemini(gemini_msg)
        (LOG_DIR / f"gemini_{i}.txt").write_text(gemini_out, encoding="utf-8")

        # Copilot
        gpt5_in = gpt5_msg + f"\n\nFeedback do Gemini (it {i}):\n" + head_line(gemini_out)
        copilot_out = run_copilot(gpt5_in)
        (LOG_DIR / f"gpt5_{i}.txt").write_text(copilot_out, encoding="utf-8")

        # Consolidar e gravar artefato
        consolidated = consolidate_content(gemini_out, copilot_out)
        if artifact_path:
            prev = artifact_path.read_text(encoding="utf-8") if artifact_path.exists() else ""
            artifact_path.write_text(prev + "\n\n" + consolidated, encoding="utf-8")

        # Verificar objetivo
        ok_goal = goal_met([gemini_out, copilot_out], args.goal)

        # Avaliar eficácia (judge)
        ok_score = True
        suggestions = []
        if args.min_score is not None:
            gem_file = str(LOG_DIR / f"gemini_{i}.txt")
            cop_file = str(LOG_DIR / f"gpt5_{i}.txt")
            judge_cmd = (
                f"python3 {shlex.quote(str(ROOT / 'scripts/llm_judge.py'))} "
                f"--gemini-file {shlex.quote(gem_file)} "
                f"--copilot-file {shlex.quote(cop_file)} "
                + (f"--goal-regex {shlex.quote(args.goal)} " if args.goal else "")
                + "--min-score " + shlex.quote(str(args.min_score)) + " --json"
            )
            res = subprocess.run(judge_cmd, shell=True, capture_output=True, text=True)
            if res.returncode == 0:
                try:
                    data = json.loads(res.stdout)
                    ok_score = bool(data.get('met_min_score', True)) and (
                        True if args.min_score is None else float(data.get('score_avg', 1.0)) >= float(args.min_score)
                    )
                    suggestions = data.get('suggestions', [])
                except Exception:
                    ok_score = False
            else:
                ok_score = False

        if ok_goal and ok_score:
            (LOG_DIR / "loop.log").write_text(f"[OK] Objetivo/score atingidos na iteração {i}\n", encoding="utf-8")
            return 0

        # Atualizar mensagens (feedback positivo)
    tail = (" Sugestões: " + "; ".join(suggestions)) if suggestions else ""
    gemini_msg = "Revisar e criticar: " + head_line(copilot_out) + tail
    gpt5_msg = "Aprimorar com base em: " + head_line(gemini_out) + tail

    (LOG_DIR / "loop.log").write_text("[FIM] Máximo de iterações atingido\n", encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
