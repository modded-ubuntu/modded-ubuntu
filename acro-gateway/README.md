# ACRO Payment Gateway

**Closed Source - Proprietary Software**  
**© 2024-2026 ZetaGo-Aurum | ALEOCROPHIC Brand**

---

## Overview

Official payment gateway website for ACRO PRO+ and ULTIMATE premium editions. This is a Next.js application integrated with Trakteer for payment processing.

---

## Deployment

### Vercel (Recommended)

1. Import this repository to Vercel
2. Add environment variables:
   - `TRAKTEER_WEBHOOK_SECRET`: Your Trakteer webhook secret
   - `LICENSE_SECRET`: Your license encryption secret
   - `NEXT_PUBLIC_BASE_URL`: Your production domain
3. Deploy

---

## Environment Variables

| Variable | Description |
|----------|-------------|
| `TRAKTEER_WEBHOOK_SECRET` | Trakteer webhook verification |
| `LICENSE_SECRET` | AES encryption key for licenses |
| `NEXT_PUBLIC_BASE_URL` | Production URL (e.g., https://acro.aleocrophic.com) |

---

## API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/webhook/trakteer` | POST | Trakteer payment webhook |
| `/api/license` | POST | License key verification |

---

## Pricing

| Edition | Price | ACRON |
|---------|-------|-------|
| PRO | FREE | - |
| PRO+ | Rp 62,500 | 1 |
| ULTIMATE | Rp 125,000 | 2 |

---

## Tech Stack

- **Framework**: Next.js 15
- **Styling**: Tailwind CSS + Custom CSS
- **Design**: Material You
- **Payment**: Trakteer Integration
- **Deployment**: Vercel

---

## License

**PROPRIETARY LICENSE**

This software is proprietary and confidential. Unauthorized copying, modification, distribution, or use of this software is strictly prohibited.

All rights reserved by ZetaGo-Aurum under the ALEOCROPHIC brand.

---

## Contact

- **Website**: [aleocrophic.com](https://aleocrophic.com)
- **Email**: support@aleocrophic.com
- **Trakteer**: [trakteer.id/Aleocrophic](https://trakteer.id/Aleocrophic)
