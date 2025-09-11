// scripts/log-codex-entry.js
import fs from 'fs';
import path from 'path';

const codexPath = path.resolve('codex/index.md');
const timestamp = new Date().toISOString();
const entry = `
## 🌟 Codex Entry — ${timestamp}

- Event: Validation Sweep
- Modules: GUI, Payments, Admin, Roles
- Status: ✅ Completed
- Author: Alli-Adeleke
`;

fs.appendFileSync(codexPath, entry);
console.log("📘 Codex entry logged.");
console.log("🌟 Codex logging complete.");