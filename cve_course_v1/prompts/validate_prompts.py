#!/usr/bin/env python3
# Valida estrutura de prompts/banks/*.json
import json, sys, glob

def fail(msg):
    print(f"[ERRO] {msg}")
    sys.exit(1)

files = glob.glob("prompts/banks/*.json")
if not files:
    fail("Nenhum JSON encontrado em prompts/banks/.")

for f in files:
    with open(f, "r", encoding="utf-8") as fh:
        data = json.load(fh)
    if "domain" not in data or "prompts" not in data:
        fail(f"{f}: campos obrigatórios ausentes (domain, prompts).")
    for p in data["prompts"]:
        for key in ("id","goal","inputs"):
            if key not in p:
                fail(f"{f}: prompt sem campo obrigatório: {key}")
print("[OK] Prompts válidos.")