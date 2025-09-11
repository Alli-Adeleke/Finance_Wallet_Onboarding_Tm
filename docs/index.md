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
