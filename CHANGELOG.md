## Changelog

## [3.0.0] - 2026-03-20

### Platform Overhaul (by Muhammad Taezeem Tariq Matta)
- **Complete Modular Architecture**: System transitioned into a plugin-based extensible CLI manager (`/core`, `/modules`, `/config`).
- **Unified CLI Engine**: Introduced the global `ubuntu` command hub with intelligent typo routing and module sub-commands.
- **Web Dashboard**: Built a lightweight Python/Flask local web UI accessible at `localhost:8080/` with a built-in marketplace viewer and real-time logs.
- **Advanced Snapshot System**: Replaced legacy backups with timestamped, compressed system snapshots.
- **Extended Developer Tools**: Fast installation of VS Code Server, Git, Python, and Node environments.
- **Hybrid Security Lab**: Full sandboxing for Kali-grade pentesting tools; safe isolation through dedicated `proot` containers.
- **Hardware Acceleration (VirGL)**: Added `ubuntu gui start --virgl` for seamless KDE/XFCE frame rendering.
- **Remote Networking**: Integrated SSH tunneling via Cloudflared (`ubuntu network tunnel`). 
- **AI Command Routing**: Experimental `ubuntu ai` parsing for natural language command routing.

## [2.0.0] - 2023-01-20

### Added
- Options to choose browser,IDE,media player (to reduce storage consumtion)
- Optimized code
- Better stability 
- Breeze Hacked (cursor theme)
- Kora Icon Theme 
- Custom config (to customize the ui by default)
- Some wallpaper
- Nerd fonts
- many more.

### Changed
- The installer UI (little bit)
- Default wallpaper
- Default font
- Default theme

### Fixed
- Firefox  (added new installer)
- Repository error 
- many many more.

<!-- END -->
