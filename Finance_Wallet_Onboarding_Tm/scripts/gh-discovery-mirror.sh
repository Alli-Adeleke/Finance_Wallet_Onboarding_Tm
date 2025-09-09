#!/usr/bin/env bash
# Finance Wallet Onboarding™ — Repo Discovery Ceremony
# Generates docs/codex-index.md with live Impact Crest Badges.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LINEAGE_FILE="$REPO_ROOT/lineage.yaml"
INDEX_FILE="$REPO_ROOT/docs/codex-index.md"
SCORES_FILE="$REPO_ROOT/.codex-impact-scores.json" # Updated by crest-broadcast.yml

if ! command -v yq >/dev/null 2>&1; then
  echo "yq is required but not installed. Install with: pip install yq or brew install yq"
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required but not installed. Install with: brew install jq or apt-get install jq"
  exit 1
fi

echo "🔍 Starting Repo Discovery Ceremony..."
echo "📜 Reading lineage from $LINEAGE_FILE"
echo "🏷 Using scores from $SCORES_FILE (if present)"

# Header
cat > "$INDEX_FILE" <<EOF
# Codex Index

**Finance Wallet Onboarding™ — Sovereign Codex Index**  
This index is auto‑generated during the Repo Discovery Ceremony (\`scripts/gh-discovery-mirror.sh\`) and reflects the current operational, architectural, and ceremonial state of the codebase.

_Last updated: $(date +%Y-%m-%d)_

---
EOF

render_section() {
  local title="$1"
  local key="$2"
  local extra_cols="$3" # e.g., "Language"
  echo -e "\n## $title" >> "$INDEX_FILE"
  if [ -n "$extra_cols" ]; then
    echo "| Crest ID | Name | $extra_cols | Purpose | Impact | Link |" >> "$INDEX_FILE"
    echo "|----------|------|-------------|---------|--------|------|" >> "$INDEX_FILE"
  else
    echo "| Crest ID | Name | Purpose | Impact | Link |" >> "$INDEX_FILE"
    echo "|----------|------|---------|--------|------|" >> "$INDEX_FILE"
  fi

  yq -r ".lineage.\"$key\" | to_entries[] | [.value.crest_id, .key, (.value.language // \"\"), .value.purpose] | @tsv" "$LINEAGE_FILE" 2>/dev/null | \
  while IFS=$'\t' read -r crest_id name lang purpose; do
    score="1"
    if [ -f "$SCORES_FILE" ]; then
      score=$(jq -r --arg cid "$crest_id" '.[$cid] // "1"' "$SCORES_FILE")
    fi
    badge_path="../assets/impact-crests/impact-${score}.svg"
    if [ -n "$extra_cols" ]; then
      echo "| $crest_id | $name | $lang | $purpose | <img src=\"$badge_path\" width=\"40\"/> | [View](../$name) |" >> "$INDEX_FILE"
    else
      echo "| $crest_id | $name | $purpose | <img src=\"$badge_path\" width=\"40\"/> | [View](../$name) |" >> "$INDEX_FILE"
    fi
  done
}

render_section "📜 Governance & Root Artifacts" "governance" ""
render_section "🏛 Architecture & Lineage" "docs" ""
render_section "⚙ Infrastructure & Platform" "platform" ""
render_section "🛠 Services" "services" "Language"

# Scripts section (no crest IDs)
echo -e "\n## 🔄 Automation & Scripts" >> "$INDEX_FILE"
echo "| Name | Purpose | Link |" >> "$INDEX_FILE"
echo "|------|---------|------|" >> "$INDEX_FILE"
for script in "$REPO_ROOT"/scripts/*.sh; do
  name=$(basename "$script")
  echo "| $name | $(head -n 1 "$script" | sed 's/#\s*//') | [View](../scripts/$name) |" >> "$INDEX_FILE"
done

echo "✅ Codex Index regenerated at $INDEX_FILE"

# Commit & push if changes exist
if ! git diff --quiet "$INDEX_FILE"; then
  git add "$INDEX_FILE"
  git commit -m "chore(codex): auto‑update Codex Index with badges [ci skip]"
  git push origin main