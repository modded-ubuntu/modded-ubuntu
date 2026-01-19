import CryptoJS from 'crypto-js';
import { v4 as uuidv4 } from 'uuid';

const LICENSE_SECRET = process.env.LICENSE_SECRET || 'ACRO-ZetaGo-Aurum-2026-SecretKey';

export type LicenseType = 'proplus' | 'ultimate';

export interface LicenseData {
  type: LicenseType;
  email: string;
  supporterName: string;
  transactionId: string;
  createdAt: string;
  acronCount: number;
}

/**
 * Generate a secure license key
 * Format: ACRO-PP-XXXXXXXX-XXXX (Pro+) or ACRO-ULT-XXXXXXXX-XXXX (Ultimate)
 */
export function generateLicenseKey(type: LicenseType): string {
  const prefix = type === 'proplus' ? 'ACRO-PP' : 'ACRO-ULT';
  const uuid = uuidv4().replace(/-/g, '').toUpperCase();
  const part1 = uuid.substring(0, 8);
  const part2 = uuid.substring(8, 12);
  
  return `${prefix}-${part1}-${part2}`;
}

/**
 * Encrypt license data for storage
 */
export function encryptLicenseData(data: LicenseData): string {
  const jsonData = JSON.stringify(data);
  return CryptoJS.AES.encrypt(jsonData, LICENSE_SECRET).toString();
}

/**
 * Decrypt license data
 */
export function decryptLicenseData(encryptedData: string): LicenseData | null {
  try {
    const bytes = CryptoJS.AES.decrypt(encryptedData, LICENSE_SECRET);
    const decrypted = bytes.toString(CryptoJS.enc.Utf8);
    return JSON.parse(decrypted);
  } catch {
    return null;
  }
}

/**
 * Validate ACRON count for tier
 * Pro+ = 25 ACRON (75,000 IDR @ Rp 3,000/ACRON)
 * Ultimate = 50 ACRON (150,000 IDR @ Rp 3,000/ACRON)
 */
export function validateAcronForTier(acronCount: number, requestedTier: LicenseType): {
  valid: boolean;
  actualTier: LicenseType | null;
  message: string;
} {
  const PROPLUS_REQUIRED = 25;
  const ULTIMATE_REQUIRED = 50;
  
  if (acronCount >= ULTIMATE_REQUIRED) {
    return {
      valid: true,
      actualTier: requestedTier === 'ultimate' ? 'ultimate' : 'proplus',
      message: requestedTier === 'ultimate' 
        ? 'Payment valid for Ultimate Edition!'
        : 'Payment valid for Pro+ Edition!'
    };
  } else if (acronCount >= PROPLUS_REQUIRED) {
    if (requestedTier === 'ultimate') {
      return {
        valid: false,
        actualTier: 'proplus',
        message: `Insufficient ACRON for Ultimate. You paid ${acronCount} ACRON which is valid for Pro+ only. Add ${ULTIMATE_REQUIRED - acronCount} more ACRON for Ultimate or proceed with Pro+.`
      };
    }
    return {
      valid: true,
      actualTier: 'proplus',
      message: 'Payment valid for Pro+ Edition!'
    };
  }
  
  return {
    valid: false,
    actualTier: null,
    message: `Insufficient ACRON. Minimum ${PROPLUS_REQUIRED} ACRON required for Pro+, ${ULTIMATE_REQUIRED} for Ultimate.`
  };
}

/**
 * Create license response
 */
export function createLicenseResponse(
  type: LicenseType,
  email: string,
  supporterName: string,
  transactionId: string,
  acronCount: number
) {
  const licenseKey = generateLicenseKey(type);
  
  const licenseData: LicenseData = {
    type,
    email,
    supporterName,
    transactionId,
    createdAt: new Date().toISOString(),
    acronCount
  };
  
  const encryptedData = encryptLicenseData(licenseData);
  
  return {
    licenseKey,
    licenseData,
    encryptedData,
    tierName: type === 'proplus' ? 'ACRO PRO+ Edition' : 'ACRO ULTIMATE Edition',
    features: type === 'proplus' 
      ? ['GPU Gaming Optimization', '10+ Emulators', '15+ Premium Themes', 'Performance Tools', 'Streaming Tools']
      : ['All Pro+ Features', 'Full Pentest Suite', 'Privacy Tools', 'Developer Pack', 'Content Creator Bundle', 'VIP Support']
  };
}
