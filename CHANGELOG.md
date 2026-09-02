## Changelog

## [2.1.0] - 2026-09-02

### Added
- **Ubuntu 26.04 Support**: Updated base system installation to Ubuntu 26.04 LTS.
- **Automated User Setup**: Automated `user.sh` execution directly within `setup.sh` upon initial install.
- **Bubblewrap (bwrap) Sandbox Bypass**: Added PRoot sandbox bypass shims and `no-sandbox` wrappers for Chromium and Firefox.
- **Debian Repository Fallback**: Integrated Debian archive keys and Debian Testing repository support for Chromium on Ubuntu 26.04+.
- **Official Mozilla PPA Migration**: Migrated Firefox installation to the official Mozilla PPA repository (`ppa:mozillateam/ppa`) with package downgrade support.
- **Modular Software Installers**: Split software installation into separate scripts (`chromium.sh`, `vscode.sh`, `sublime.sh`) with skip options.
- **Idempotent System Configuration**: Added marker files (`.config-done`) to make font, theme, sound, and profile setup idempotent.
- **Samsung Audio Support**: Added Samsung-specific PulseAudio bug fixes and sound routing configurations.
- **Additional Utilities**: Added `tigervnc-tools` to default package installation list.

### Changed
- **Non-Interactive APT Setup**: Exported `DEBIAN_FRONTEND=noninteractive` and non-interactive `tzdata` configuration to prevent interactive prompts during setup.
- **Modern GPG Keyring**: Replaced deprecated `apt-key` usage with `gpg --dearmor` keyrings to avoid `dirmngr` errors in PRoot containers.
- **Shell Script Refactoring**: Converted script outputs to heredocs, added explicit shebangs (`#!/usr/bin/env bash`), and used `exec` in wrapper scripts to prevent parent shell exit issues.
- **XtraDeb Setup**: Updated XtraDeb repository setup script and enabled live log streaming during installation.
- **Installer UI & Banners**: Updated welcome banner, installation progress logs, and final completion status messages.

### Fixed
- **Chromium Sandbox & Launch**: Fixed Chromium execution failures by patching desktop files and injecting sandbox wrappers.
- **`bwrap_fix()` Hang**: Resolved process hang when `bwrap_fix()` receives no trailing command arguments.
- **Distro Setup Failure**: Fixed "Error Installing Distro" failure during initial environment provisioning.
- **User & Sudo Persistence**: Fixed username auto-detection, sudo password override behavior, and software directory persistence.
- **Script Error Cleanup**: Resolved syntax errors, unquoted variables, array closures, missing error handling, and logical operator spacing across all installer scripts (`user.sh`, `gui.sh`, `chromium.sh`, `vscode.sh`, `sublime.sh`, `vncstop`).

### Thanks
- Special thanks to [@Superchavo](https://github.com/Superchavo) for significant contributions, bug fixes, and repository maintenance patches!

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
