#!/usr/bin/env python3
"""
Gerador LLM offline (stub) — sem chamadas de API.
Uso:
  python3 scripts/llm_offline.py prompts/banks/domain_specific.json "Sua pergunta"

Regras:
- Lê o banco de prompts (domain, style, prompts[])
- Escolhe um template com heurística simples baseada no texto da pergunta
- Produz saída determinística e útil no tom definido em style
"""
from __future__ import annotations
import json, sys, re, hashlib
from pathlib import Path

def die(msg: str, code: int = 1) -> None:
    print(f"[ERRO] {msg}")
    sys.exit(code)

def load_bank(path: str) -> dict:
    p = Path(path)
    if not p.exists():
        die(f"Arquivo não encontrado: {path}")
    try:
        return json.loads(p.read_text(encoding="utf-8"))
    except Exception as e:
        die(f"Falha ao ler JSON: {e}")

def pick_prompt_id(query: str, prompts: list[dict]) -> str | None:
    q = query.lower()
    # Heurística simples
    if any(k in q for k in ["outline", "resumo", "módulo", "modulo"]):
        return "module_outline"
    if any(k in q for k in ["nota", "prontuário", "prontuario", "evolução", "evolucao"]):
        return "note_template"
    # Caso não detecte, retorna None para modo genérico
    return None

def extract_module_number(query: str) -> str:
    # tenta achar "módulo 1" ou "m1"
    m = re.search(r"m[óo]dulo\s*(\d+)", query, flags=re.I)
    if m:
        return m.group(1)
    m = re.search(r"\bm(\d+)\b", query, flags=re.I)
    if m:
        return m.group(1)
    return "?"

def stable_choice(items: list[str], seed: str, k: int) -> list[str]:
    # seleção determinística baseada em hash da seed
    h = hashlib.sha256(seed.encode("utf-8")).hexdigest()
    idxs = []
    base = int(h[:8], 16)
    for i in range(k):
        idxs.append((base + i * 7) % len(items))
    return [items[i] for i in idxs]

def render_module_outline(query: str, style: dict) -> str:
    mod = extract_module_number(query)
    tone = style.get("tone", "clínico e direto")
    constraints = ", ".join(style.get("constraints", []))
    topics = [
        "Definições rápidas e quando chocar",
        "Sinais de instabilidade — identificar em 10s",
        "Algoritmo de decisão (choque vs drogas)",
        "Energia inicial e escalonamento",
        "Posicionamento de pads e sincronismo",
        "Sedação analgésica segura",
        "Documentação mínima obrigatória",
    ]
    chosen = stable_choice(topics, query, 5)
    lines = []
    lines.append(f"# Módulo {mod} — Outline (tom: {tone})")
    if constraints:
        lines.append(f"> Restrições: {constraints}")
    lines.append("")
    lines.append("## Objetivos")
    lines += [f"- {x}" for x in chosen[:3]]
    lines.append("")
    lines.append("## Conteúdo")
    lines += [f"- {x}" for x in chosen]
    lines.append("")
    lines.append("## Exercícios de caso")
    cases = [
        "FA rápida com instabilidade pós-cocaína",
        "TV monomórfica com choque elétrico inicial",
        "Flutter com bloqueio 1:1 em etilista",
        "TSV paroxística refratária à manobra vagal",
        "Polimórfica com QT prolongado (não retardar choque)",
    ]
    for i, c in enumerate(stable_choice(cases, query, 3), 1):
        lines.append(f"{i}) {c}")
    return "\n".join(lines)

def render_note_template(query: str, style: dict) -> str:
    tone = style.get("tone", "clínico e direto")
    constraints = ", ".join(style.get("constraints", []))
    # gerar conteúdo mínimo baseado em heurística
    lines = []
    lines.append(f"# Nota de Prontuário (tom: {tone})")
    if constraints:
        lines.append(f"> Restrições: {constraints}")
    lines.append("Sinais: instabilidade hemodinâmica (hipotensão/síncope/angina/IC aguda).")
    lines.append("Monitor: taquiarritmia sustentada; decisão por CVE sincronizada.")
    lines.append("Energia: inicial 100–200 J (bifásico), escalonando conforme resposta.")
    lines.append("Desfecho: reversão obtida; paciente monitorizado e documentado.")
    return "\n".join(lines)

def render_generic(query: str, bank: dict) -> str:
    tone = bank.get("style", {}).get("tone", "clínico e direto")
    constraints = ", ".join(bank.get("style", {}).get("constraints", []))
    lines = []
    lines.append(f"# Resposta (modo genérico, tom: {tone})")
    if constraints:
        lines.append(f"> Restrições: {constraints}")
    lines.append("- Entendi sua solicitação e gerei um esboço baseado no domínio do curso.")
    lines.append("- Para templates específicos, cite 'outline do módulo X' ou 'nota de prontuário'.")
    lines.append("")
    lines.append("## Sua pergunta")
    lines.append(f"{query}")
    lines.append("")
    lines.append("## Próximas ações")
    lines.append("- Especifique o módulo (ex.: 'Módulo 2') ou o tipo de saída desejada.")
    return "\n".join(lines)

def main(argv: list[str]) -> int:
    if len(argv) < 3:
        print("Uso: python3 scripts/llm_offline.py <prompts_json> \"Sua pergunta\"")
        return 2
    prompts_json = argv[1]
    query = argv[2]
    bank = load_bank(prompts_json)
    prompts = bank.get("prompts", [])
    style = bank.get("style", {})
    pid = pick_prompt_id(query, prompts)
    if pid == "module_outline":
        out = render_module_outline(query, style)
    elif pid == "note_template":
        out = render_note_template(query, style)
    else:
        out = render_generic(query, bank)
    print(out)
    return 0

if __name__ == "__main__":
    sys.exit(main(sys.argv))
