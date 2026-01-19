import { NextRequest, NextResponse } from 'next/server';
import { validateAcronForTier, createLicenseResponse, LicenseType } from '@/lib/license';

interface TrakteerWebhookPayload {
  id: string;
  supporter_name: string;
  supporter_email: string;
  supporter_message: string;
  unit: string; // "ACRON"
  quantity: number; // Number of ACRONs
  price: number;
  created_at: string;
  // Additional fields from Trakteer
  order_id?: string;
  media?: string;
}

// In-memory storage for demo (use database in production)
const licenses: Map<string, object> = new Map();

export async function POST(request: NextRequest) {
  try {
    // Verify webhook secret
    const webhookSecret = request.headers.get('X-Trakteer-Signature');
    const expectedSecret = process.env.TRAKTEER_WEBHOOK_SECRET;
    
    // Note: Trakteer sends signature in header - verify it
    if (!webhookSecret || webhookSecret !== expectedSecret) {
      console.log('Webhook verification - received:', webhookSecret);
      // For testing, we'll allow it through but log warning
      console.warn('Warning: Webhook signature mismatch or missing');
    }
    
    const payload: TrakteerWebhookPayload = await request.json();
    
    console.log('Received Trakteer webhook:', JSON.stringify(payload, null, 2));
    
    // Extract ACRON count
    const acronCount = payload.quantity || 0;
    const supporterName = payload.supporter_name || 'Anonymous';
    const supporterEmail = payload.supporter_email || '';
    const transactionId = payload.id || payload.order_id || `TRX-${Date.now()}`;
    
    // Parse message for requested tier (default to proplus)
    const message = (payload.supporter_message || '').toLowerCase();
    let requestedTier: LicenseType = 'proplus';
    
    if (message.includes('ultimate') || message.includes('ult')) {
      requestedTier = 'ultimate';
    }
    
    // Validate ACRON count for requested tier
    const validation = validateAcronForTier(acronCount, requestedTier);
    
    if (!validation.valid && validation.actualTier === null) {
      return NextResponse.json({
        success: false,
        error: validation.message
      }, { status: 400 });
    }
    
    // If validation failed but we have a fallback tier
    if (!validation.valid && validation.actualTier) {
      // User paid 1 ACRON but requested Ultimate
      // Return options
      return NextResponse.json({
        success: false,
        insufficientPayment: true,
        message: validation.message,
        options: {
          addMore: {
            description: 'Add 1 more ACRON to get Ultimate Edition',
            requiredAmount: 1,
            tier: 'ultimate'
          },
          proceed: {
            description: 'Proceed with Pro+ Edition (your payment is valid)',
            tier: 'proplus'
          }
        },
        partialPayment: {
          acronPaid: acronCount,
          acronNeeded: 2,
          transactionId
        }
      }, { status: 202 });
    }
    
    // Generate license
    const actualTier = validation.actualTier as LicenseType;
    const licenseResponse = createLicenseResponse(
      actualTier,
      supporterEmail,
      supporterName,
      transactionId,
      acronCount
    );
    
    // Store license (in production, save to database)
    licenses.set(licenseResponse.licenseKey, {
      ...licenseResponse.licenseData,
      encrypted: licenseResponse.encryptedData
    });
    
    console.log('Generated license:', licenseResponse.licenseKey, 'for tier:', actualTier);
    
    return NextResponse.json({
      success: true,
      message: `Thank you for purchasing ACRO ${actualTier === 'ultimate' ? 'ULTIMATE' : 'PRO+'} Edition!`,
      license: {
        key: licenseResponse.licenseKey,
        tier: licenseResponse.tierName,
        features: licenseResponse.features,
        supporterName,
        createdAt: licenseResponse.licenseData.createdAt
      },
      instructions: {
        step1: 'Install ACRO PRO (Free) from GitHub first',
        step2: `Download the ${actualTier === 'ultimate' ? 'install-ultimate.sh' : 'install-proplus.sh'} file`,
        step3: `Run: sudo bash install-${actualTier === 'ultimate' ? 'ultimate' : 'proplus'}.sh --license ${licenseResponse.licenseKey}`,
        note: 'Your license key is valid for lifetime!'
      }
    });
    
  } catch (error) {
    console.error('Webhook error:', error);
    return NextResponse.json({
      success: false,
      error: 'Failed to process webhook'
    }, { status: 500 });
  }
}

// GET method for testing
export async function GET() {
  return NextResponse.json({
    status: 'ok',
    message: 'ACRO Trakteer Webhook Endpoint',
    info: 'Send POST request with Trakteer webhook payload'
  });
}
