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
        <li><strong>Last commit:</strong> %Y->- (grafted, HEAD -> main, origin/main) f2b2da72cc815d08ec0039f8bd2e3728a6474787:%M:HEAD UTC</li>
        <li><strong>Total commits:</strong> 1</li>
        <li><strong>Stars:</strong> 0</li>
        <li><strong>Forks:</strong> 0</li>
        <li><strong>Open issues:</strong> 9</li>
        <li><strong>Last push:</strong> 2025-09-11T21:28:07Z</li>
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
        <li><a href="https://github.com/Alli-Adeleke/Finance_Wallet_Onboarding_Tm/actions">View Actions</a></li>
        <li><a href="https://github.com/Alli-Adeleke/Finance_Wallet_Onboarding_Tm/actions/workflows/pages.yml">Trigger Pages Deploy</a></li>
      </ul>
    </div>
    <div id="admin-tab5" class="tab" data-perm="logs:view">
      <h3>📄 Pages Deploy Log</h3>
      <p><a href="https://github.com/Alli-Adeleke/Finance_Wallet_Onboarding_Tm/actions/workflows/pages.yml">Latest Logs</a></p>
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
