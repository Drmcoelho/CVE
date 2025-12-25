# Curso — Fisiopatologia das Arritmias Cardioversáveis & Cardioversão Sincronizada

Este repositório contém:
- Conteúdo didático (MkDocs) com módulos, casos e *cheatsheets* A5.
- Automação via **Shell** (gh CLI + Codespaces + MkDocs).
- Orquestração LLM→LLM (wrappers GPT‑5/Gemini) para geração de material e revisão.
- Banco de *prompts* com validador.

> Filosofia: precisão clínica, execução prática, zero burocracia. “Choca quando precisa — e documenta certo.”

## Estrutura

```
.
├─ docs/                     # Site do curso (MkDocs)
│  ├─ index.md
│  ├─ modules/
│  ├─ cases/
│  └─ cheatsheets/
├─ prompts/
│  ├─ banks/domain_specific.json
│  └─ validate_prompts.py
├─ agents/
│  ├─ gpt5_task.yaml
│  └─ gemini_task.yaml
├─ scripts/
│  ├─ 00_bootstrap.sh
│  ├─ 01_new_module.sh
│  ├─ 02_build_docs.sh
│  ├─ 03_deploy_pages.sh
│  ├─ llm_gpt5.sh
│  └─ llm_gemini.sh
├─ .devcontainer/
│  └─ devcontainer.json
├─ mkdocs.yml
└─ Makefile
```

## Fluxo rápido

```bash
# 1) Criar repositório no GitHub (via gh)
gh repo create cve-course --private -y
git init && git add . && git commit -m "init: course skeleton"
git branch -M main
git remote add origin https://github.com/<user>/cve-course.git
git push -u origin main

# 2) Abrir Codespaces
gh codespace create -r <user>/cve-course -b main

# 3) Construir e servir local
./scripts/00_bootstrap.sh
./scripts/02_build_docs.sh

# 4) Publicar no GitHub Pages
./scripts/03_deploy_pages.sh
```

### LLM→LLM (stubs)
Use `./scripts/llm_gpt5.sh` e `./scripts/llm_gemini.sh` para geração/revisão automatizada de módulos/casos:
```bash
./scripts/llm_gpt5.sh prompts/banks/domain_specific.json "Gerar resumo do Módulo 1"
./scripts/llm_gemini.sh prompts/banks/domain_specific.json "Revisar algoritmo de decisão"
```

> Dica: `./scripts/00_bootstrap.sh` registra logs em `/tmp/mkdocs_bootstrap.log` (tentativas via pip/apt). Se o ambiente tiver proxy ou bloqueio de rede, configure-o ou instale o MkDocs manualmente (`pip install mkdocs`) antes de rodar `mkdocs build`/`mkdocs serve`.

> Substitua as variáveis de ambiente **OPENAI_API_KEY** e **GOOGLE_API_KEY** no ambiente Codespaces/host.
