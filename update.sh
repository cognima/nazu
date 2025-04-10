#!/bin/bash

mkdir -p __backup
cp -r $(ls -A | grep -v __backup) __backup/

# 2. Para cada arquivo .js
for file in $(find . -type f -name "*.js"); do
  # Obfusca via API e sobrescreve
  content=$(curl -s -X POST -F "file=@$file" https://sua-api-obfuscator.com/obfuscate)
  echo "$content" > "$file"
done

# 3. Gera um .gitignore temporário para ignorar os desobfuscados
echo "__backup/" > .gitignore

# 4. Faz push
git add .
git commit -m "commit automático obfuscado"
git push

# 5. Depois do push, restaura os arquivos
rm -rf ./*
cp -r __backup/* .
rm -rf __backup

# 6. Remove o .gitignore extra
git restore .gitignore