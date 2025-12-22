#!/usr/bin/env python3
from __future__ import annotations
import argparse, json, re, sys

KEYWORDS_OBJ = ["objetivos", "objetivo"]
KEYWORDS_CONT = ["conteúdo", "conteudo", "algoritmo", "energia", "pads", "sincron"]
KEYWORDS_CASES = ["exercícios", "exercicios", "caso", "casos"]
KEYWORDS_NOTA = ["nota de prontuário", "nota de prontuario", "sinais:", "monitor:", "energia:", "desfecho:"]
STYLE_TONE = ["clínico", "clinico", "direto"]
CONSTRAINTS = ["tempo é miocárdio", "tempo e miocardio", "documentação objetiva", "documentacao objetiva", "precisão"]

def score_text(t: str) -> tuple[float, list[str]]:
    text = t.lower()
    score = 0.0
    max_score = 1.0
    sugg: list[str] = []

    def has_any(keys, weight, msg):
        nonlocal score
        if any(k in text for k in keys):
            score += weight
        else:
            sugg.append(msg)

    has_any(STYLE_TONE, 0.1, "Use tom clínico e direto explicitamente.")
    has_any(CONSTRAINTS, 0.1, "Reitere restrições: precisão, tempo é miocárdio, documentação objetiva.")
    has_any(KEYWORDS_OBJ, 0.2, "Inclua seção 'Objetivos' com bullets acionáveis.")
    has_any(KEYWORDS_CONT, 0.3, "Inclua seção 'Conteúdo' com algoritmo, energia, pads e sincronismo.")
    has_any(KEYWORDS_CASES, 0.2, "Inclua 'Exercícios de caso' (3 itens).")
    # Bônus para nota de prontuário formato 4 linhas
    bonus = 0.1 if sum(1 for k in KEYWORDS_NOTA if k in text) >= 3 else 0.0
    score = min(max_score, score + bonus)
    return score, sugg

def main(argv=None) -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument('--gemini-file', type=str, required=True)
    ap.add_argument('--copilot-file', type=str, required=True)
    ap.add_argument('--goal-regex', type=str, default=None)
    ap.add_argument('--min-score', type=float, default=0.6)
    ap.add_argument('--json', action='store_true', help='emitir saída JSON')
    args = ap.parse_args(argv)

    g = open(args.gemini_file, 'r', encoding='utf-8').read()
    c = open(args.copilot_file, 'r', encoding='utf-8').read()
    sg, sg_sugg = score_text(g)
    sc, sc_sugg = score_text(c)
    avg = (sg + sc) / 2.0
    met = avg >= args.min_score

    goal_met = False
    if args.goal_regex:
        pat = re.compile(args.goal_regex, flags=re.I|re.M)
        goal_met = any(pat.search(x) for x in [g, c])

    suggestions = list(dict.fromkeys(sg_sugg + sc_sugg))[:5]
    out = {
        'score_gemini': round(sg, 3),
        'score_copilot': round(sc, 3),
        'score_avg': round(avg, 3),
        'min_score': args.min_score,
        'met_min_score': met,
        'goal_met': goal_met,
        'suggestions': suggestions,
    }
    if args.json:
        print(json.dumps(out, ensure_ascii=False, indent=2))
    else:
        print(f"SCORE avg={out['score_avg']} (g={out['score_gemini']}, c={out['score_copilot']}); met_min={met}; goal_met={goal_met}")
        if suggestions:
            print("Sugestões:")
            for s in suggestions:
                print(f"- {s}")
    return 0

if __name__ == '__main__':
    raise SystemExit(main())
