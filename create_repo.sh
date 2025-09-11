#!/usr/bin/env bash
set -euo pipefail

# === CONFIGURATION ===
REPO_NAME="finance-wallet-onboarding"
GITHUB_USER="Alli-Adeleke"   # <-- Your GitHub username, safely quoted
: "${MY_PAT:?Environment variable MY_PAT not set}"  # PAT stored as Codespaces secret

REMOTE_URL="https://github.com/${GITHUB_USER}/${REPO_NAME}.git"

echo "🚀 Creating $REPO_NAME with Pages, workflows, prebuild, and deploy dependencies..."

# 1️⃣ Create base structure
mkdir -p "$REPO_NAME"
cd "$REPO_NAME"

mkdir -p docs/{architecture,runbooks,compliance}
mkdir -p platform/{shared-libs,infra/environments/dev,infra/modules/{network,eks},helm/onboarding,cicd/{workflows,templates}}
mkdir -p services/{onboarding/src,kyc,ledger}
mkdir -p apps/{web,mobile}
mkdir -p scripts
mkdir -p assets/impact-crests
mkdir -p tools/image-renderer/src/{templates,utils} tools/image-renderer/tests
mkdir -p .github/workflows
mkdir -p rendered-badges

# 2️⃣ Root files
cat > README.md <<'EOF'
# Finance Wallet Onboarding™

Sovereign, lineage-aware, and ceremonially broadcast-ready platform.
EOF

cat > .gitignore <<'EOF'
node_modules/
.env
rendered-badges/
.DS_Store
EOF

cat > .env.example <<'EOF'
APP_ENV=dev
LOG_LEVEL=info
EOF

# 3️⃣ GitHub Pages config
cat > docs/index.md <<'EOF'
# 🛡️ Finance Wallet Codex

Welcome to the sovereign Codex of Finance Wallet Onboarding™.

- [Codex Index](codex-index.md)
- [Crest History](codex-history.md)
EOF

cat > docs/_config.yml <<'EOF'
title: Finance Wallet Codex
description: Sovereign lineage, crest shimmer, and ceremonial broadcasts
theme: jekyll-theme-cayman
EOF

# 4️⃣ Workflows

## CI
cat > .github/workflows/ci.yml <<'EOF'
name: CI
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install dependencies
        run: npm ci || true
      - name: Run tests
        run: npm test || echo "No tests yet"
EOF

## Pages Deploy