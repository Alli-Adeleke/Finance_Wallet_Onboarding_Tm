// scripts/test-workflows.js
import { execSync } from 'child_process';

const workflows = [
  { name: 'CI', command: 'yarn test' },
  { name: 'Lint', command: 'yarn lint' },
  { name: 'Build', command: 'yarn build' },
  { name: 'Payments Validation', command: 'yarn validate:payments' },
  { name: 'GUI Regen', command: 'yarn regen:gui' },
  { name: 'Admin Regen', command: 'yarn regen:admin' },
  { name: 'Roles Regen', command: 'yarn regen:roles' },
  { name: 'Codex Log', command: 'yarn codex:log' }
];

console.log('🔍 Starting workflow test sweep...\n');

for (const wf of workflows) {
  try {
    console.log(`🧪 Testing: ${wf.name}`);
    execSync(wf.command, { stdio: 'inherit' });
    console.log(`✅ Passed: ${wf.name}\n`);
  } catch (err) {
    console.error(`❌ Failed: ${wf.name}`);
    console.error(`🔍 Error: ${err.message}\n`);
  }
}

console.log('🧿 Workflow test sweep complete.');
console.log('🌟 All workflows tested.');