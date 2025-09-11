console.log("🔧 Regenerating Admin Console...");

import fs from 'fs';
import path from 'path';

const adminPath = path.resolve('src/gui');
fs.writeFileSync(path.join(adminPath, 'AdminConsole.tsx'), `
import React from 'react';
export default function AdminConsole() {
  return <div>🧭 Admin Console Activated</div>;
}
`);

console.log("✅ Admin Console regenerated.");
console.log("🌟 Admin regeneration complete.");