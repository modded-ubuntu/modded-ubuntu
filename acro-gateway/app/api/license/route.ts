import { NextRequest, NextResponse } from 'next/server';
import { decryptLicenseData, LicenseType } from '@/lib/license';

// In production, use a database to store licenses
// This is a simple in-memory store for demonstration
const validLicensePatterns = {
  proplus: /^ACRO-PP-[A-Z0-9]{8}-[A-Z0-9]{4}$/,
  ultimate: /^ACRO-ULT-[A-Z0-9]{8}-[A-Z0-9]{4}$/
};

export async function POST(request: NextRequest) {
  try {
    const { licenseKey } = await request.json();
    
    if (!licenseKey || typeof licenseKey !== 'string') {
      return NextResponse.json({
        valid: false,
        error: 'License key is required'
      }, { status: 400 });
    }
    
    // Determine license type from key format
    let licenseType: LicenseType | null = null;
    
    if (validLicensePatterns.proplus.test(licenseKey)) {
      licenseType = 'proplus';
    } else if (validLicensePatterns.ultimate.test(licenseKey)) {
      licenseType = 'ultimate';
    }
    
    if (!licenseType) {
      return NextResponse.json({
        valid: false,
        error: 'Invalid license key format'
      }, { status: 400 });
    }
    
    // In production, verify against database
    // For now, we validate format only
    // TODO: Add database lookup
    
    return NextResponse.json({
      valid: true,
      licenseType,
      tierName: licenseType === 'proplus' ? 'ACRO PRO+ Edition' : 'ACRO ULTIMATE Edition',
      message: 'License key is valid!'
    });
    
  } catch (error) {
    console.error('License verification error:', error);
    return NextResponse.json({
      valid: false,
      error: 'Failed to verify license'
    }, { status: 500 });
  }
}

export async function GET() {
  return NextResponse.json({
    endpoint: '/api/license',
    methods: ['POST'],
    usage: {
      POST: 'Send { licenseKey: "ACRO-XX-XXXXXXXX-XXXX" } to verify a license'
    }
  });
}
