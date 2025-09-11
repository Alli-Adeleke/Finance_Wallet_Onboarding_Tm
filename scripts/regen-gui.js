// scripts/regen-gui.js
import fs from 'fs';
import path from 'path';

console.log("🔧 Regenerating GUI components...");

const guiPath = path.resolve('src/gui');
if (!fs.existsSync(guiPath)) {
  fs.mkdirSync(guiPath, { recursive: true });
  console.log("📁 GUI directory created.");
}

// Example component scaffold
const component = `
import React from 'react';

export default function Dashboard() {
  return <div>🛡️ Sovereign Dashboard Loaded</div>;
}
`;

fs.writeFileSync(path.join(guiPath, 'Dashboard.tsx'), component);
console.log("✅ GUI component 'Dashboard.tsx' regenerated.");
console.log("🌟 GUI regeneration complete.");