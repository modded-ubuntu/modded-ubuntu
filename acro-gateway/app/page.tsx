'use client';

import { useState } from 'react';

export default function Home() {
  const [selectedTier, setSelectedTier] = useState<'proplus' | 'ultimate' | null>(null);

  const screenshots = [
    { src: '/screenshots/screenshot_blender.jpg', alt: 'Blender 3D Modeling', caption: 'Blender 4.3.2 - 3D Modeling & Animation' },
    { src: '/screenshots/screenshot_krita.jpg', alt: 'Krita Digital Painting', caption: 'Krita - Digital Painting' },
    { src: '/screenshots/screenshot_kdenlive.jpg', alt: 'Kdenlive Video Editor', caption: 'Kdenlive - Video Editing' },
    { src: '/screenshots/screenshot_lmms.jpg', alt: 'LMMS Music Production', caption: 'LMMS - Music Production' },
    { src: '/screenshots/screenshot_vscode.jpg', alt: 'VS Code IDE', caption: 'Visual Studio Code - Development' },
    { src: '/screenshots/screenshot_krita_splash.jpg', alt: 'Krita Splash', caption: 'Krita 25th Anniversary Edition' },
  ];

  const handleBuyClick = (tier: 'proplus' | 'ultimate') => {
    setSelectedTier(tier);
    // Open Trakteer payment page with correct quantity
    // Pro+ = 1 ACRON, Ultimate = 2 ACRON
    const quantity = tier === 'proplus' ? 1 : 2;
    const trakteerUrl = `https://trakteer.id/Aleocrophic/tip?quantity=${quantity}`;
    window.open(trakteerUrl, '_blank');
  };

  return (
    <main>
      {/* Navigation */}
      <nav style={{
        position: 'fixed',
        top: 0,
        left: 0,
        right: 0,
        zIndex: 100,
        padding: '16px 24px',
        background: 'rgba(26, 26, 46, 0.9)',
        backdropFilter: 'blur(12px)',
        borderBottom: '1px solid rgba(255, 255, 255, 0.05)',
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center'
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
          <span style={{ fontSize: '24px', fontWeight: 800 }} className="gradient-text">ACRO</span>
          <span style={{ fontSize: '14px', opacity: 0.7 }}>by ZetaGo-Aurum</span>
        </div>
        <div style={{ display: 'flex', gap: '16px' }}>
          <a href="#pricing" className="btn btn-outline" style={{ padding: '10px 20px' }}>Pricing</a>
          <a href="#gallery" className="btn btn-primary" style={{ padding: '10px 20px' }}>Gallery</a>
        </div>
      </nav>

      {/* Hero Section */}
      <section style={{
        minHeight: '100vh',
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'center',
        alignItems: 'center',
        textAlign: 'center',
        padding: '120px 24px 80px',
        position: 'relative',
        overflow: 'hidden'
      }}>
        {/* Background Effect */}
        <div style={{
          position: 'absolute',
          width: '600px',
          height: '600px',
          background: 'radial-gradient(circle, rgba(156, 77, 204, 0.2) 0%, transparent 70%)',
          top: '20%',
          left: '50%',
          transform: 'translateX(-50%)',
          pointerEvents: 'none'
        }} />
        
        <div style={{ position: 'relative', zIndex: 1 }}>
          {/* ACRON Coin */}
          <div className="animate-float" style={{ marginBottom: '32px' }}>
            <div className="acron-coin" style={{ 
              width: '100px', 
              height: '100px', 
              fontSize: '36px',
              margin: '0 auto',
              boxShadow: '0 0 60px rgba(255, 213, 79, 0.4)'
            }}>
              A
            </div>
          </div>

          <h1 style={{ 
            fontSize: 'clamp(40px, 8vw, 72px)', 
            fontWeight: 800,
            marginBottom: '16px',
            lineHeight: 1.1
          }}>
            <span className="gradient-text">ACRO PRO Edition</span>
          </h1>
          
          <p style={{ 
            fontSize: 'clamp(18px, 3vw, 24px)', 
            opacity: 0.8,
            maxWidth: '700px',
            margin: '0 auto 16px'
          }}>
            Premium Linux Distribution for Termux
          </p>
          
          <p style={{ 
            fontSize: '16px', 
            opacity: 0.6,
            marginBottom: '40px'
          }}>
            Ubuntu 25.10 | 1000+ Software | GPU Optimization | 24/7 Keep-Alive
          </p>

          <div style={{ display: 'flex', gap: '16px', justifyContent: 'center', flexWrap: 'wrap' }}>
            <a href="#pricing" className="btn btn-gold">
              🚀 Get Started Free
            </a>
            <a href="https://github.com/ZetaGo-Aurum/modded-ubuntu" target="_blank" className="btn btn-outline">
              ⭐ Star on GitHub
            </a>
          </div>
        </div>
      </section>

      {/* What is ACRO Section */}
      <section className="section" style={{ background: 'rgba(0,0,0,0.2)' }}>
        <div style={{ maxWidth: '900px', margin: '0 auto', textAlign: 'center' }}>
          <h2 className="section-title">What is ACRO?</h2>
          <p style={{ fontSize: '18px', lineHeight: 1.8, opacity: 0.85 }}>
            <strong>ACRO PRO Edition</strong> is a premium Ubuntu distribution designed specifically for Termux on Android. 
            It comes with <strong>1000+ pre-installed software</strong> including development tools, office suite, 
            graphic design apps, video editors, and more — all working out of the box without manual configuration.
          </p>
          
          <div style={{ 
            display: 'grid', 
            gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))',
            gap: '24px',
            marginTop: '48px'
          }}>
            {[
              { icon: '💻', title: '1000+ Apps', desc: 'VSCode, Blender, GIMP, LibreOffice...' },
              { icon: '🎮', title: 'GPU Ready', desc: 'OpenGL 4.5 for 3D apps & games' },
              { icon: '🔊', title: 'Full Audio', desc: 'PulseAudio works perfectly' },
              { icon: '📁', title: 'Storage Access', desc: 'Access Android storage directly' },
            ].map((item, i) => (
              <div key={i} className="card" style={{ textAlign: 'center' }}>
                <div style={{ fontSize: '40px', marginBottom: '12px' }}>{item.icon}</div>
                <h3 style={{ fontSize: '18px', fontWeight: 600, marginBottom: '8px' }}>{item.title}</h3>
                <p style={{ fontSize: '14px', opacity: 0.7 }}>{item.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Pricing Section */}
      <section id="pricing" className="section">
        <h2 className="section-title">Choose Your Edition</h2>
        
        <div style={{ 
          display: 'grid', 
          gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))',
          gap: '24px',
          maxWidth: '1100px',
          margin: '0 auto'
        }}>
          
          {/* FREE Tier - PRO */}
          <div className="card tier-free">
            <div style={{ textAlign: 'center' }}>
              <h3 style={{ fontSize: '24px', fontWeight: 700, marginBottom: '8px' }}>
                🆓 PRO
              </h3>
              <p style={{ opacity: 0.7, marginBottom: '16px' }}>Free Forever</p>
              <div className="price price-free">FREE</div>
              <p style={{ fontSize: '14px', opacity: 0.6 }}>Open Source on GitHub</p>
            </div>
            
            <ul className="feature-list">
              <li>1000+ Pre-installed Software</li>
              <li>XFCE Desktop Environment</li>
              <li>PulseAudio (Sound Works!)</li>
              <li>VNC Server Ready</li>
              <li>Storage Sharing</li>
              <li>neofetch ACRO Branding</li>
              <li>Basic GPU Support</li>
            </ul>
            
            <div className="code-block" style={{ marginBottom: '16px' }}>
              <code>git clone https://github.com/ZetaGo-Aurum/modded-ubuntu && cd modded-ubuntu && bash setup.sh</code>
            </div>
            
            <a 
              href="https://github.com/ZetaGo-Aurum/modded-ubuntu" 
              target="_blank"
              className="btn btn-outline"
              style={{ width: '100%' }}
            >
              📥 Install from GitHub
            </a>
          </div>

          {/* PRO+ Tier */}
          <div className="card tier-proplus card-glow-purple">
            <div style={{ textAlign: 'center' }}>
              <h3 style={{ fontSize: '24px', fontWeight: 700, marginBottom: '8px' }}>
                ⭐ PRO+
              </h3>
              <p style={{ opacity: 0.7, marginBottom: '16px' }}>Add-on Pack</p>
              <div className="price price-proplus">
                <span className="price-currency">Rp </span>62.500
              </div>
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '8px', marginTop: '8px' }}>
                <div className="acron-coin" style={{ width: '32px', height: '32px', fontSize: '14px' }}>A</div>
                <span style={{ opacity: 0.7 }}>= 1 ACRON</span>
              </div>
            </div>
            
            <ul className="feature-list">
              <li>🎮 GPU Gaming Optimization</li>
              <li>🕹️ 10+ Gaming Emulators</li>
              <li>🎨 15+ Premium Themes</li>
              <li>⚡ Performance Tools</li>
              <li>📺 OBS Streaming Ready</li>
              <li>🎯 Gaming Mode Toggle</li>
              <li>📞 Email Support (24h)</li>
            </ul>
            
            <div style={{ 
              background: 'rgba(156, 77, 204, 0.1)', 
              borderRadius: '12px', 
              padding: '12px',
              marginBottom: '16px',
              fontSize: '13px',
              textAlign: 'center'
            }}>
              ⚠️ <strong>PRO (Free)</strong> harus diinstall dahulu sebagai engine utama
            </div>
            
            <button 
              onClick={() => handleBuyClick('proplus')}
              className="btn btn-primary"
              style={{ width: '100%' }}
            >
              🛒 Buy with 1 ACRON
            </button>
          </div>

          {/* ULTIMATE Tier */}
          <div className="card tier-ultimate card-glow-gold">
            <div style={{ textAlign: 'center' }}>
              <h3 style={{ fontSize: '24px', fontWeight: 700, marginBottom: '8px' }}>
                🏆 ULTIMATE
              </h3>
              <p style={{ opacity: 0.7, marginBottom: '16px' }}>Full Pack Add-on</p>
              <div className="price price-ultimate">
                <span className="price-currency">Rp </span>125.000
              </div>
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '8px', marginTop: '8px' }}>
                <div className="acron-coin" style={{ width: '32px', height: '32px', fontSize: '14px' }}>A</div>
                <div className="acron-coin" style={{ width: '32px', height: '32px', fontSize: '14px' }}>A</div>
                <span style={{ opacity: 0.7 }}>= 2 ACRON</span>
              </div>
            </div>
            
            <ul className="feature-list">
              <li>✨ All PRO+ Features</li>
              <li>🔐 Full Pentest Suite</li>
              <li>🛡️ Privacy & Tor Tools</li>
              <li>💻 Developer Pro Pack</li>
              <li>🎬 Content Creator Bundle</li>
              <li>🔧 Forensics & RE Tools</li>
              <li>👑 VIP Support (6h)</li>
              <li>♾️ Lifetime Updates</li>
            </ul>
            
            <div style={{ 
              background: 'rgba(255, 213, 79, 0.1)', 
              borderRadius: '12px', 
              padding: '12px',
              marginBottom: '16px',
              fontSize: '13px',
              textAlign: 'center'
            }}>
              ⚠️ <strong>PRO (Free)</strong> harus diinstall dahulu sebagai engine utama
            </div>
            
            <button 
              onClick={() => handleBuyClick('ultimate')}
              className="btn btn-gold"
              style={{ width: '100%' }}
            >
              🛒 Buy with 2 ACRON
            </button>
          </div>
        </div>

        {/* Important Note */}
        <div style={{ 
          maxWidth: '700px', 
          margin: '48px auto 0',
          textAlign: 'center'
        }}>
          <div className="card" style={{ 
            background: 'rgba(156, 77, 204, 0.1)',
            border: '1px solid var(--md-primary)'
          }}>
            <h4 style={{ marginBottom: '12px', fontSize: '18px' }}>📌 Penting untuk Pembeli PRO+ / ULTIMATE</h4>
            <p style={{ fontSize: '14px', opacity: 0.85, lineHeight: 1.7 }}>
              PRO+ dan ULTIMATE adalah <strong>add-on pack</strong>, bukan software terpisah. 
              Anda harus menginstall <strong>ACRO PRO (Free)</strong> dari GitHub terlebih dahulu sebagai engine utama.
              Setelah pembayaran, Anda akan menerima <strong>License Key</strong> yang valid seumur hidup.
            </p>
          </div>
        </div>
      </section>

      {/* Gallery Section */}
      <section id="gallery" className="section" style={{ background: 'rgba(0,0,0,0.2)' }}>
        <h2 className="section-title">📸 Gallery</h2>
        
        <div className="gallery-grid" style={{ maxWidth: '1200px', margin: '0 auto' }}>
          {screenshots.map((shot, i) => (
            <div key={i} className="gallery-item card" style={{ padding: 0, overflow: 'hidden' }}>
              <div style={{ 
                aspectRatio: '16/9', 
                background: 'linear-gradient(135deg, #252542, #1a1a2e)',
                position: 'relative',
                overflow: 'hidden'
              }}>
                <img 
                  src={shot.src} 
                  alt={shot.alt}
                  style={{
                    width: '100%',
                    height: '100%',
                    objectFit: 'cover'
                  }}
                  onError={(e) => {
                    const target = e.target as HTMLImageElement;
                    target.style.display = 'none';
                    if (target.parentElement) {
                      target.parentElement.innerHTML = '<div style="display:flex;align-items:center;justify-content:center;height:100%;color:rgba(255,255,255,0.3);font-size:48px">🖼️</div>';
                    }
                  }}
                />
              </div>
              <div style={{ padding: '12px 16px' }}>
                <p style={{ fontSize: '14px', opacity: 0.8 }}>{shot.caption}</p>
              </div>
            </div>
          ))}
        </div>
        
        <p style={{ textAlign: 'center', marginTop: '24px', opacity: 0.6, fontSize: '14px' }}>
          Screenshots from ACRO PRO Edition running on Android via Termux + VNC
        </p>
      </section>

      {/* README Section */}
      <section className="section">
        <h2 className="section-title">📖 Quick Start Guide</h2>
        
        <div style={{ maxWidth: '800px', margin: '0 auto' }}>
          <div className="card">
            <h3 style={{ marginBottom: '16px', fontSize: '20px' }}>Requirements</h3>
            <ul className="feature-list">
              <li>Termux from F-Droid</li>
              <li>VNC Viewer (AVNC recommended)</li>
              <li>15-20GB free storage</li>
              <li>Stable internet connection</li>
            </ul>
            
            <h3 style={{ marginBottom: '16px', marginTop: '24px', fontSize: '20px' }}>Installation</h3>
            <div className="code-block" style={{ marginBottom: '12px' }}>
              <code># Update Termux</code><br />
              <code>yes | pkg up</code><br /><br />
              <code># Clone and install</code><br />
              <code>pkg install git wget -y</code><br />
              <code>git clone --depth=1 https://github.com/ZetaGo-Aurum/modded-ubuntu.git</code><br />
              <code>cd modded-ubuntu && bash setup.sh</code>
            </div>
            
            <h3 style={{ marginBottom: '16px', marginTop: '24px', fontSize: '20px' }}>After Installation</h3>
            <div className="code-block">
              <code># Restart Termux, then:</code><br />
              <code>ubuntu</code><br /><br />
              <code># Create user (first time):</code><br />
              <code>bash user.sh</code><br /><br />
              <code># Install GUI:</code><br />
              <code>sudo bash gui.sh</code>
            </div>
            
            <div style={{ marginTop: '24px', textAlign: 'center' }}>
              <a 
                href="https://github.com/ZetaGo-Aurum/modded-ubuntu" 
                target="_blank"
                className="btn btn-outline"
              >
                📄 Full Documentation on GitHub
              </a>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer style={{
        padding: '48px 24px',
        background: 'rgba(0,0,0,0.4)',
        textAlign: 'center'
      }}>
        <div className="gradient-text" style={{ fontSize: '28px', fontWeight: 700, marginBottom: '16px' }}>
          ACRO PRO Edition
        </div>
        <p style={{ opacity: 0.6, marginBottom: '16px' }}>
          Premium Linux Distribution for Termux
        </p>
        <p style={{ opacity: 0.5, fontSize: '14px' }}>
          © 2024-2026 <strong>ZetaGo-Aurum</strong> | <strong>ALEOCROPHIC</strong> Brand
        </p>
        <div style={{ marginTop: '24px', display: 'flex', gap: '16px', justifyContent: 'center', flexWrap: 'wrap' }}>
          <a href="https://github.com/ZetaGo-Aurum" target="_blank" style={{ opacity: 0.7, textDecoration: 'none', color: 'inherit' }}>GitHub</a>
          <a href="https://trakteer.id/Aleocrophic" target="_blank" style={{ opacity: 0.7, textDecoration: 'none', color: 'inherit' }}>Trakteer</a>
          <a href="mailto:support@aleocrophic.com" style={{ opacity: 0.7, textDecoration: 'none', color: 'inherit' }}>Support</a>
        </div>
      </footer>
    </main>
  );
}
