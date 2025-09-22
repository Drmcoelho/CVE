.PHONY: boot build serve deploy validate

boot:
	bash scripts/00_bootstrap.sh

build:
	mkdocs build

serve:
	mkdocs serve -a 0.0.0.0:8000

deploy:
	mkdocs gh-deploy --force

validate:
	python3 prompts/validate_prompts.py

.PHONY: demo-llm
demo-llm:
	bash scripts/llm_gpt5.sh prompts/banks/domain_specific.json "Gerar resumo do Módulo 1" | sed -n '1,20p'
	bash scripts/llm_gemini.sh prompts/banks/domain_specific.json "Escrever nota de prontuário em 4 linhas" | sed -n '1,20p'