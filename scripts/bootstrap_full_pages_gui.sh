#!/usr/bin/env bash
set -euo pipefail

DOCS="docs"
NAV="$DOCS/_data/navigation.yml"
IDX="$DOCS/index.md"
ADM="$DOCS/admin/index.md"

REP="${REPO:-Alli-Adeleke/finance-wallet-onboarding}"
API="https://api.github.com/repos/$REP"

mkdir -p "$DOCS/_data" "$DOCS/admin" assets/impact-crests

# Seed roles.yml (expanded roles)
if [ ! -f "$DOCS/_data/roles.yml" ]; then
  cat > "$DOCS/_data/roles.yml" <<'YAML'
roles:
  owner:
    name: Owner
    grants: [health:view, logs:view, crest:write, codex:write, workflows:dispatch, admin:guardrails]
  operator:
    name: Operator
    grants: [health:view, logs:view, crest:write, codex:write, workflows:dispatch]
  steward:
    name: Steward
    grants: [health:view, logs:view, codex:write]
  auditor:
    name: Auditor
    grants: [health:view, logs:view]
  contributor:
    name: Contributor
    grants: [health:view]
  automation:
    name: Automation (Bot)
    grants: [codex:write, workflows:dispatch]
  viewer:
    name: Viewer
    grants: [health:view, logs:view]
  board:
    name: Board
    grants: [health:view, logs:view]
  compliance:
    name: Compliance
    grants: [health:view, logs:view]
  audit:
    name: Audit
    grants: [health:view, logs:view]
  partner:
    name: Partner
    grants: [health:view]
  guest:
    name: Guest
    grants: [health:view]
YAML
fi

# Seed permissions.yml
if [ ! -f "$DOCS/_data/permissions.yml" ]; then
  cat > "$DOCS/_data/permissions.yml" <<'YAML'
permissions:
  - key: health:view
    label: View Repo Health
  - key: logs:view
    label: View Deploy & Actions Logs
  - key: crest:write
    label: Manage Crests
  - key: codex:write
    label: Write Codex & Docs Index
  - key: workflows:dispatch
    label: Trigger Workflows
  - key: admin:guardrails
    label: Edit Admin Settings & Guardrails
YAML
fi

# Live GitHub stats (best-effort)
AUTH=()
[ -n "${GITHUB_TOKEN:-}" ] && AUTH=(-H "Authorization: token $GITHUB_TOKEN")
JSON="$(curl -s "${AUTH[@]}" "$API" || true)"
OPEN="$(echo "$JSON" | grep -m1 '"open_issues_count":' | awk '{print $2}' | tr -d ',')"
STARS="$(echo "$JSON" | grep -m1 '"stargazers_count":' | awk '{print $2}' | tr -d ',')"
FORKS="$(echo "$JSON" | grep -m1 '"forks_count":' | awk '{print $2}' | tr -d ',')"
PUSHED="$(echo "$JSON" | grep -m1 '"pushed_at":' | cut -d '"' -f4)"
OPEN="${OPEN:-N/A}"; STARS="${STARS:-N/A}"; FORKS="${FORKS:-N/A}"; PUSHED="${PUSHED:-N/A}"

# Navigation by ceremonial phase + timestamps
echo "# Auto-generated navigation for Finance Wallet Onboarding™" > "$NAV"
echo "main:" >> "$NAV"
declare -A P=(
  ["services"]="Services"
  ["apps"]="Applications"
  ["platform"]="Platform"
  ["docs"]="Documentation"
  ["scripts"]="Automation Scripts"
  ["assets"]="Assets & Crests"
  ["tools"]="Tools"
)
for d in "${!P[@]}"; do
  [ -d "$d" ] || continue
  echo "  - title: \"${P[$d]}\"" >> "$NAV"
  echo "    children:" >> "$NAV"
  while IFS= read -r -d '' f; do
    rel="${f#./}"
    title="$(basename "$f")"
    updated="$(git log -1 --format="%Y-%m-%d" -- "$f" 2>/dev/null || echo "N/A")"
    echo "      - title: \"$title (updated $updated)\"" >> "$NAV"
    echo "        url: /$rel" >> "$NAV"
  done < <(find "$d" -type f -print0 | sort -z)
done
echo "  - title: \"Admin Console\"" >> "$NAV"
echo "    url: /admin/index.html" >> "$NAV"

# Admin Console (tabs + role gating) — variables expand at runtime
cat > "$ADM" <<EOF_ADMIN
---
layout: default
title: Admin Console — Finance Wallet Codex
---

# 🛡️ Admin Console — Finance Wallet Codex

<div class="tabs">
  <ul class="tab-links">
    <li class="active"><a href="#admin-tab1">📊 Repo Health</a></li>
    <li><a href="#admin-tab2">🖼 Crest Management</a></li>
    <li><a href="#admin-tab3">📜 Codex Controls</a></li>
    <li><a href="#admin-tab4">⚙️ Workflow Console</a></li>
    <li><a href="#admin-tab5">📄 Deploy Logs</a></li>
    <li><a href="#admin-tab6">🔐 Roles & Permissions</a></li>
  </ul>
  <div class="tab-content">
    <div id="admin-tab1" class="tab active" data-perm="health:view">
      <h3>📊 Repo Health & Lineage</h3>
      <ul>
        <li><strong>Branch:</strong> main</li>
        <li><strong>Last commit:</strong> $(git log -1 --format="%Y-%m-%d %H:%M:%S UTC" || echo "N/A")</li>
        <li><strong>Total commits:</strong> $(git rev-list --count HEAD || echo "N/A")</li>
        <li><strong>Stars:</strong> $STARS</li>
        <li><strong>Forks:</strong> $FORKS</li>
        <li><strong>Open issues:</strong> $OPEN</li>
        <li><strong>Last push:</strong> $PUSHED</li>
      </ul>
    </div>
    <div id="admin-tab2" class="tab" data-perm="crest:write">
      <h3>🖼 Crest Management</h3>
      <p><a href="../assets/impact-crests/">View all crests</a></p>
    </div>
    <div id="admin-tab3" class="tab" data-perm="codex:write">
      <h3>📜 Codex Index Controls</h3>
      <p><a href="../codex-index.md">Regenerate Codex Index</a></p>
    </div>
    <div id="admin-tab4" class="tab" data-perm="workflows:dispatch">
      <h3>⚙️ Workflow Console</h3>
      <ul>
        <li><a href="https://github.com/$REP/actions">View Actions</a></li>
        <li><a href="https://github.com/$REP/actions/workflows/pages.yml">Trigger Pages Deploy</a></li>
      </ul>
    </div>
    <div id="admin-tab5" class="tab" data-perm="logs:view">
      <h3>📄 Pages Deploy Log</h3>
      <p><a href="https://github.com/$REP/actions/workflows/pages.yml">Latest Logs</a></p>
    </div>
    <div id="admin-tab6" class="tab" data-perm="admin:guardrails">
      <h3>🔐 Roles & Permissions</h3>
      <label for="roleSelect"><strong>Active role:</strong></label>
      <select id="roleSelect">
        <option value="owner">Owner</option>
        <option value="operator">Operator</option>
        <option value="steward">Steward</option>
        <option value="auditor">Auditor</option>
        <option value="contributor">Contributor</option>
        <option value="automation">Automation (Bot)</option>
        <option value="viewer">Viewer</option>
        <option value="board">Board</option>
        <option value="compliance">Compliance</option>
        <option value="audit">Audit</option>
        <option value="partner">Partner</option>
        <option value="guest">Guest</option>
      </select>
      <h4>Role matrix</h4>
      <ul>
        {% for pair in site.data.roles.roles %}
          {% assign key = pair[0] %}{% assign role = pair[1] %}
          <li><strong>{{ role.name }} ({{ key }}):</strong> {{ role.grants | join: ", " }}</li>
        {% endfor %}
      </ul>
      <p><em>UI gating only; enforced via branch protection, CODEOWNERS, environments.</em></p>
    </div>
  </div>
</div>

<style>
.tabs { margin-top: 15px; }
.tab-links { list-style: none; padding: 0; display: flex; gap: 8px; border-bottom: 2px solid #ccc; flex-wrap: wrap; }
.tab-links a { padding: 8px 12px; background: #f4f4f4; color: #333; text-decoration: none; border-radius: 5px 5px 0 0; display: block; }
.tab-links li.active a { background: #0366d6; color: #fff; }
.tab-content .tab { display: none; padding: 15px; border: 1px solid #ccc; border-top: none; }
.tab-content .tab.active { display: block; }
</style>

<script>
document.addEventListener("DOMContentLoaded",function(){
  // tabs
  const l=document.querySelectorAll(".tab-links a"), t=document.querySelectorAll(".tab");
  l.forEach(a=>a.addEventListener("click",e=>{
    e.preventDefault();
    l.forEach(x=>x.parentElement.classList.remove("active"));
    t.forEach(n=>n.classList.remove("active"));
    a.parentElement.classList.add("active");
    document.querySelector(a.getAttribute("href")).classList.add("active");
  }));
  // role gating
  const saved=localStorage.getItem("fw_role")||"viewer";
  const sel=document.getElementById("roleSelect");
  if(sel){ sel.value=saved; sel.addEventListener("change",()=>{ localStorage.setItem("fw_role",sel.value); applyRole(sel.value); }); }
  const roles = {{ site.data.roles.roles | jsonify }};
  function applyRole(roleKey){ const grants=new Set((roles[roleKey]&&roles[roleKey].grants)||[]);
    document.querySelectorAll("[data-perm]").forEach(el=>{
      el.style.display = grants.has(el.getAttribute("data-perm")) ? "" : "none";
    });
  }
  applyRole(saved);
});
</script>
EOF_ADMIN

# Unified index with master tabs (Public + Admin) — Liquid must be literal
cat > "$IDX" <<'HTML'
---
layout: default
title: Finance Wallet Codex — Unified Console
---

# 🛡️ Finance Wallet Codex — Unified Console

Welcome to the sovereign control deck.

![First Crest](../assets/impact-crests/first-crest.svg)

<div class="master-tabs">
  <ul class="master-tab-links">
    <li class="active"><a href="#public-codex">🌐 Public Codex</a></li>
    <li><a href="#admin-console">🛡️ Admin Console</a></li>
  </ul>
  <div class="master-tab-content">
    <div id="public-codex" class="master-tab active">
      <div class="tabs">
        <ul class="tab-links">
          {% for section in site.data.navigation.main %}
            {% unless section.title == "Admin Console" %}
              <li{% if forloop.first %} class="active"{% endif %}>
                <a href="#pub-tab{{ forloop.index }}">{{ section.title }}</a>
              </li>
            {% endunless %}
          {% endfor %}
        </ul>
        <div class="tab-content">
          {% for section in site.data.navigation.main %}
            {% unless section.title == "Admin Console" %}
              <div id="pub-tab{{ forloop.index }}" class="tab{% if forloop.first %} active{% endif %}">
                {% if section.children %}
                  <ul>
                    {% for item in section.children %}
                      <li><a href="{{ item.url }}">{{ item.title }}</a></li>
                    {% endfor %}
                  </ul>
                {% else %}
                  <p>No items in this section.</p>
                {% endif %}
              </div>
            {% endunless %}
          {% endfor %}
        </div>
      </div>
    </div>
    <div id="admin-console" class="master-tab">
      <div class="tabs">
        <ul class="tab-links">
          <li class="active"><a href="#admin-tab1">📊 Repo Health</a></li>
          <li><a href="#admin-tab2">🖼 Crest Management</a></li>
          <li><a href="#admin-tab3">📜 Codex Controls</a></li>
          <li><a href="#admin-tab4">⚙️ Workflow Console</a></li>
          <li><a href="#admin-tab5">📄 Deploy Logs</a></li>
          <li><a href="#admin-tab6">🔐 Roles & Permissions</a></li>
        </ul>
        <div class="tab-content">
          <div id="admin-tab1" class="tab active">
            <h3>📊 Repo Health & Lineage</h3>
            <p>See stats in <a href="/admin/index.html">Admin Console</a>.</p>
          </div>
          <div id="admin-tab2" class="tab">
            <h3>🖼 Crest Management</h3>
            <p>Manage crests in <a href="/admin/index.html#admin-tab2">Admin Console</a>.</p>
          </div>
          <div id="admin-tab3" class="tab">
            <h3>📜 Codex Index Controls</h3>
            <p>Controls in <a href="/admin/index.html#admin-tab3">Admin Console</a>.</p>
          </div>
          <div id="admin-tab4" class="tab">
            <h3>⚙️ Workflow Console</h3>
            <p>Triggers in <a href="/admin/index.html#admin-tab4">Admin Console</a>.</p>
          </div>
          <div id="admin-tab5" class="tab">
            <h3>📄 Pages Deploy Log</h3>
            <p>Logs at <a href="/admin/index.html#admin-tab5">Admin Console</a>.</p>
          </div>
          <div id="admin-tab6" class="tab">
            <h3>🔐 Roles & Permissions</h3>
            <p>Manage roles in <a href="/admin/index.html#admin-tab6">Admin Console</a>.</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<style>
.master-tabs { margin-top: 20px; }
.master-tab-links { display: flex; list-style: none; border-bottom: 3px solid #444; padding: 0; }
.master-tab-links li { margin-right: 10px; }
.master-tab-links a { padding: 10px 20px; background: #eee; color: #333; text-decoration: none; border-radius: 5px 5px 0 0; display: block; }
.master-tab-links .active a { background: #0366d6; color: #fff; }
.master-tab-content .master-tab { display: none; }
.master-tab-content .master-tab.active { display: block; }
.tabs { margin-top: 15px; }
.tab-links { display: flex; gap: 8px; border-bottom: 2px solid #ccc; list-style: none; padding: 0; flex-wrap: wrap; }
.tab-links a { padding: 8px 12px; background: #f4f4f4; color: #333; text-decoration: none; border-radius: 5px 5px 0 0; display: block; }
.tab-links li.active a { background: #0366d6; color: #fff; }
.tab-content .tab { display: none; padding: 15px; border: 1px solid #ccc; border-top: none; }
.tab-content .tab.active { display: block; }
</style>

<script>
document.addEventListener("DOMContentLoaded",function(){
  // master tabs
  const ML=document.querySelectorAll(".master-tab-links a"),
        MT=document.querySelectorAll(".master-tab");
  ML.forEach(a=>a.addEventListener("click",e=>{
    e.preventDefault();
    ML.forEach(x=>x.parentElement.classList.remove("active"));
    MT.forEach(t=>t.classList.remove("active"));
    a.parentElement.classList.add("active");
    document.querySelector(a.getAttribute("href")).classList.add("active");
  }));
  // inner tabs
  document.querySelectorAll(".tabs").forEach(ct=>{
    const links=ct.querySelectorAll(".tab-links a"),
          tabs=ct.querySelectorAll(".tab");
    links.forEach(a=>a.addEventListener("click",e=>{
      e.preventDefault();
      links.forEach(x=>x.parentElement.classList.remove("active"));
      tabs.forEach(t=>t.classList.remove("active"));
      a.parentElement.classList.add("active");
      ct.querySelector(a.getAttribute("href")).classList.add("active");
    }));
  });
});
</script>
HTML

echo "✅ Bootstrap complete."

