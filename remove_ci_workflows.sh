#!/usr/bin/env bash
# Remove extra CI/CD workflows + seed files added by add_ci_workflows.sh
set -euo pipefail

echo "🧹 Removing extra workflows and seed files..."

# Remove workflows
rm -f .github/workflows/node-ci.yml
rm -f .github/workflows/python-ci.yml
rm -f .github/workflows/lint.yml
rm -f .github/workflows/codespaces-prebuild.yml

# Remove seed files if they match the seeded content
rm -f requirements.txt
rm -f .markdownlint.json
rm -f .yamllint.yml

# Remove dummy test files if they exist
[ -f tests/test_sample.py ] && rm -f tests/test_sample.py
[ -f src/codeql_seed.js ] && rm -f src/codeql_seed.js
[ -f src/codeql_seed.py ] && rm -f src/codeql_seed.py

# Remove package.json only if it was created by the seeding script
if [ -f package.json ]; then
  if grep -q "No tests yet" package.json; then
    rm -f package.json package-lock.json
  fi
fi

# Commit the removals
git add -A
git commit -m "chore: remove extra CI/CD workflows and seed files" || echo "No changes to commit"

echo "✅ Extra workflows and seed files removed."
