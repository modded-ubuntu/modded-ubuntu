# Changelog

## [3.1.0 PRO] - 2026-01-04

### 🚀 Major Update - 1000+ Packages

**Remake by ZetaGo-Aurum | ALEOCROPHIC Brand**

This is the biggest update yet, expanding from 124 to 1000+ software packages with comprehensive system configuration tools.

### ✨ Added - New Features

#### Update System

- New `update.sh` script for existing installations
- Interactive menu with Quick/Full/GUI/Settings options
- Command-line arguments support (`--quick`, `--full`, `--gui`, `--settings`)

#### Settings Utility (mu-settings)

- 🌐 Language configuration (23+ languages including Indonesian)
- 🕐 Timezone settings with region/city selection
- 🖥️ VNC display settings (resolution, color depth, scale)
- 🔊 Audio settings (test output, test mic, restart PulseAudio)
- 🎨 Appearance settings (themes, font scaling, DPI)

#### Software Expansion (1000+ packages)

**Development:**
- Full Python stack (NumPy, SciPy, Matplotlib, Pandas, Flask, Django)
- Ruby, Perl, Lua, Go, Rust, PHP, Java (OpenJDK)
- Clang, LLVM, GDB, Valgrind
- Database clients (SQLite, MariaDB, PostgreSQL, Redis)
- Jupyter Notebook, IPython

**Graphics & Design:**
- Blender (64-bit only)
- DaVinci Resolve support
- Darktable, RawTherapee (RAW processing)
- FontForge, Synfig, Pencil2D
- DigiKam photo manager

**Video Production:**
- OBS Studio
- OpenShot, Shotcut, Pitivi
- HandBrake, SimpleScreenRecorder

**Audio Production:**
- Ardour DAW
- Hydrogen drum machine
- MIDI support (Timidity, FluidSynth)
- PulseEffects

**Security Tools:**
- Wireshark, Nmap, Netcat
- John, Hashcat, Hydra
- OpenVPN, WireGuard
- ClamAV

**Fonts & Languages:**
- 100+ font families for all regions
- Full CJK support
- Arabic, Hebrew, Indic scripts
- Thai, Indonesian, Vietnamese
- Programming fonts collection

#### Hardware Virtualization

- QEMU user-static
- Virtualization utilities (limited in proot)

#### Audio System Enhancement

- Microphone input support via module-aaudio-source
- Input device selection in settings
- Audio recording capability

### 🔧 Changed

#### CLI Design Overhaul

- Modern pip-style progress bars
- Spinner animations
- Extended 256-color palette
- Cleaner section headers
- No design artifacts on Termux

#### VNC Configuration

- Settings now read from ~/.vnc/config
- Dynamic resolution changing via mu-settings
- Color depth options (16/24/32-bit)
- Scale factor support

#### Installation Flow

- Estimated time: 60-120 minutes for full install
- Storage requirement: 15-20GB
- Category-based installation with progress tracking

### 🐛 Fixed

#### Neofetch

- Proper distro detection in proot environment
- Custom config for Ubuntu branding
- No more "Unknown" distro

#### Pavucontrol

- Fixed PULSE_SERVER environment issue
- Desktop file patched for proot
- Volume control now works correctly

#### Audio Input

- Microphone support enabled
- AAUDIO source module loaded
- Recording apps can access mic

#### Package Installation

- Alternative package fallback system
- Graceful handling of unavailable packages
- Better error logging

### 📦 Package Categories

| Category | Count |
|----------|-------|
| Base System | ~50 |
| XFCE Desktop | ~50 |
| VNC Server | ~10 |
| Fonts | ~100 |
| Themes | ~20 |
| Development | ~150 |
| Databases | ~10 |
| Office | ~40 |
| Graphics | ~50 |
| Audio | ~30 |
| Video | ~80 |
| Utilities | ~100 |
| Network | ~60 |
| Security | ~30 |
| Virtualization | ~5 |
| Locales | ~30 |
| **TOTAL** | **~1000+** |

---

## [3.0.0 PRO] - 2026-01-03

### 🚀 Major PRO Edition Release

**Remake by ZetaGo-Aurum | ALEOCROPHIC Brand**

This is a complete overhaul of the original modded-ubuntu script, transforming it into a premium, high-performance, fully automated Ubuntu GUI installer.

### ✨ Added - 124+ New Features

#### Development & IDE

- Visual Studio Code (with proot patches)
- Sublime Text Editor
- Geany IDE
- Git & Git configuration
- Node.js & npm
- Python 3 & pip
- Build-essential (gcc, g++, make)
- CMake

#### Office Suite

- LibreOffice Writer
- LibreOffice Calc
- LibreOffice Impress
- LibreOffice Draw
- LibreOffice Math
- Evince PDF Reader

#### Graphics & Design

- GIMP (Image Editor)
- Inkscape (Vector Graphics)
- Krita (Digital Painting)
- ImageMagick

#### Audio Production

- Audacity (Audio Editor)
- LMMS (Music Production)
- Pavucontrol (Volume Control)

#### Video & Media

- VLC Media Player
- MPV Media Player
- Kdenlive (Video Editor)
- FFmpeg suite

#### System Utilities

- Thunar (Enhanced File Manager)
- XArchiver
- Htop & Btop
- Neofetch
- GParted
- Synaptic Package Manager
- Bleachbit (System Cleaner)

#### Network Tools

- FileZilla
- Transmission
- Net-tools
- OpenSSH

#### Premium Theme Package

- Orchis Dark GTK Theme
- Papirus Dark Icon Theme
- Breeze Hacked Cursor
- Custom XFCE Panel Layout
- 20+ Premium Wallpapers
- Nerd Fonts Collection (JetBrains, Fira, Hack)

### 🔧 Changed

#### Installation Flow

- **Fully Automatic** - No more user prompts during software installation
- Progress indicators with percentage
- Estimated time remaining display
- Installation logging for troubleshooting

#### Audio System

- Complete PulseAudio overhaul
- AAudio sink module integration
- Automatic PULSE_SERVER configuration
- Volume control applets pre-installed

#### VNC Configuration

- Higher default resolution (1920x1080)
- Optimized compression for mobile
- Better session management

#### User Interface

- Premium CLI installer with ASCII art
- Colored progress bars
- Status indicators
- Modern branding

#### Theme & Appearance

- Complete XFCE theme overhaul
- Dark sleek modern appearance
- Custom panel layout
- Modern icon theme
- Premium cursor theme

### 🐛 Fixed

#### Audio

- PulseAudio connection issues
- Firefox audio playback
- VLC audio output
- General audio routing

#### Stability

- Package dependency conflicts
- Repository errors
- Installation interruptions
- VNC session cleanup

#### Performance

- Reduced memory footprint
- Faster startup time
- Optimized package selection

---

## [2.0.0] - 2023-01-20

### Added

- Options to choose browser, IDE, media player
- Optimized code
- Better stability
- Breeze Hacked cursor theme
- Kora Icon Theme
- Custom config
- Some wallpapers
- Nerd fonts

### Changed

- The installer UI
- Default wallpaper
- Default font
- Default theme

### Fixed

- Firefox (added new installer)
- Repository error

---

## [1.0.0] - Initial Release

- Basic Ubuntu GUI for Termux
- XFCE Desktop
- VNC support
- Firefox browser
- Basic theming

---

**Original Authors:** Mustakim Ahmed, Tahmid Rayat, 0xBaryonyx
**PRO Remake:** ZetaGo-Aurum | ALEOCROPHIC
