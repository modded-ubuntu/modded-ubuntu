import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  metadataBase: new URL(process.env.NEXT_PUBLIC_BASE_URL || 'https://acro.aleocrophic.com'),
  title: 'ACRO PRO Edition - Premium Linux for Termux',
  description: 'Premium Ubuntu distribution for Termux with 1000+ pre-installed software. GPU optimization, gaming emulators, security tools, and more.',
  keywords: 'ACRO, Termux, Ubuntu, Linux, Android, proot, premium, pro, ultimate',
  authors: [{ name: 'ZetaGo-Aurum' }],
  openGraph: {
    title: 'ACRO PRO Edition',
    description: 'Premium Linux Distribution for Termux',
    type: 'website',
  },
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <head>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
      </head>
      <body>{children}</body>
    </html>
  )
}
