// scripts/validate-payments.js
import fs from 'fs';
import path from 'path';

console.log("💳 Validating Payments Module...");

const configPath = path.resolve('config/payments.config.ts');
if (!fs.existsSync(configPath)) {
  console.error("❌ payments.config.ts not found. Validation aborted.");
  process.exit(1);
}

const configContent = fs.readFileSync(configPath, 'utf-8');
const gateways = ['Visa', 'Mastercard', 'Bitcoin'];

const missing = gateways.filter(g => !configContent.includes(g));
if (missing.length > 0) {
  console.warn(`⚠️ Missing gateways: ${missing.join(', ')}`);
} else {
  console.log("✅ All payment gateways validated.");
}
console.log("🌟 Payments module validation complete.");