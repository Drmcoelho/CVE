# Copilot instructions — CVE course (MkDocs)

Contexto rápido
- A pasta de trabalho é `cve_course_v1/`. Caminhos relativos no projeto assumem essa raiz.
- Núcleos: `docs/` (conteúdo), `mkdocs.yml` (nav/site), `scripts/` (automação), `Makefile` (atalhos), `prompts/` (banco+validador), `agents/` (stubs LLM→LLM).

Arquitetura e integrações
- MkDocs renderiza `docs/**` conforme navegação de `mkdocs.yml`. Páginas só aparecem se estiverem listadas em `nav`.
- Automação via Shell: `scripts/*.sh` implementam boot/build/serve/deploy; `Makefile` só encurta os comandos.
- LLM→LLM (stubs): `scripts/llm_gpt5.sh`/`scripts/llm_gemini.sh` consomem `prompts/banks/domain_specific.json`. Requerem `OPENAI_API_KEY`/`GOOGLE_API_KEY` exportadas (não commitar segredos).

Fluxos do desenvolvedor (preferidos)
- Preparar deps: `make -C cve_course_v1 boot` (instala MkDocs via pip).
- Desenvolver/servir: `make -C cve_course_v1 serve` (0.0.0.0:8000). Alternativa “só build”: `make -C cve_course_v1 build`.
- Publicar Pages: `make -C cve_course_v1 deploy` (usa `mkdocs gh-deploy --force`). Garanta `repo_url` correto em `mkdocs.yml`.
- Validar prompts: `make -C cve_course_v1 validate` (roda `prompts/validate_prompts.py`).

Convenções deste repo
- Conteúdo
  - Módulos em `docs/modules/` com nome `m<number>_snake_case.md` (ex.: `m1_mecanismos_instabilidade.md`).
  - Casos em `docs/cases/`, cheatsheets A5 em `docs/cheatsheets/`.
  - Tom/estilo: pt-BR, “clínico, direto, sem rodeios” (ver `prompts/banks/domain_specific.json`).
- Criação de módulo: `scripts/01_new_module.sh mX_nome-do-modulo` gera cabeçalho padrão (“Objetivos / Conteúdo / Exercícios de caso”). Depois adicione ao `mkdocs.yml` em `nav`.
- Navegação: qualquer novo `.md` precisa ser referenciado em `mkdocs.yml` para aparecer no site.

Prompts e agentes (regras práticas)
- Estrutura mínima do JSON de prompts: `domain`, e para cada item em `prompts[]`: `id`, `goal`, `inputs` (opcionalmente `guardrails`). O validador falha se faltar algo.
- Arquivos em `agents/*.yaml` são stubs que apontam para o banco e argumentos; mantenha caminhos relativos consistentes.

Pitfalls e dicas
- O README da raiz é mínimo; consulte `cve_course_v1/README.md` para fluxo detalhado.
- `scripts/02_build_docs.sh` usa 0.0.0.0:8000; evite conflito de portas em Codespaces/containers.
- Evite renomeações/refactors amplos: `mkdocs.yml` depende dos nomes/paths.

Exemplos rápidos
- Novo módulo: `scripts/01_new_module.sh m6_taquiarritmias_complexas` → editar conteúdo → adicionar no `mkdocs.yml` → `make -C cve_course_v1 build`/`serve`.
- Chamar LLM (stub): `scripts/llm_gpt5.sh prompts/banks/domain_specific.json "Gerar resumo do Módulo 1"` (requer `OPENAI_API_KEY`).
