console.log("🔧 Regenerating Roles...");

import fs from 'fs';
import path from 'path';

const rolesPath = path.resolve('src/gui');
fs.writeFileSync(path.join(rolesPath, 'Roles.tsx'), `
import React from 'react';
export default function Roles() {
  return <div>🎭 Roles Rendered</div>;
}
`);

console.log("✅ Roles regenerated.");
console.log("🌟 Roles regeneration complete.");