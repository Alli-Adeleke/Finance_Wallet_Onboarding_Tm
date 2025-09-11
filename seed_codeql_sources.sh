#!/usr/bin/env bash
# Seed minimal source files so CodeQL has something to analyze
set -euo pipefail

# Languages you want CodeQL to scan
LANGS=("javascript" "python")

mkdir -p src

for lang in "${LANGS[@]}"; do
  case "$lang" in
    javascript)
      if ! find src -type f -name "*.js" | grep -q .; then
        echo "console.log('CodeQL seed JS file');" > src/codeql_seed.js
        echo "🟢 Seeded JavaScript file: src/codeql_seed.js"
      fi
      ;;
    python)
      if ! find src -type f -name "*.py" | grep -q .; then
        echo "print('CodeQL seed Python file')" > src/codeql_seed.py
        echo "🟢 Seeded Python file: src/codeql_seed.py"
      fi
      ;;
    # Add more languages here if needed
  esac
done

git add src
git commit -m "chore: add CodeQL seed source files" || echo "No changes to commit"
echo "✅ CodeQL seed files setup complete."