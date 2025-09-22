#!/usr/bin/env bash
# Cria um novo módulo em docs/modules/ com cabeçalho padrão.
NAME="$1"
if [ -z "$NAME" ]; then
  echo "Uso: $0 mX_nome-do-modulo"
  exit 1
fi
FILE="docs/modules/${NAME}.md"
if [ -f "$FILE" ]; then
  echo "[!] Já existe: $FILE"
  exit 1
fi
mkdir -p docs/modules
cat > "$FILE" <<'EOF'
# Título do Módulo

## Objetivos
- 

## Conteúdo
- 

## Exercícios de caso
1) 
2) 
3) 
EOF
echo "[OK] Criado $FILE"