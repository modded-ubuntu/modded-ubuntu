<div align="center">

# 🚀 Termux Ubuntu Environment Manager  

**A highly advanced, modular, and production-grade platform transforming Termux into a full-fledged Linux distribution lab.**

![Version](https://img.shields.io/badge/version-3.0.0-blue.svg?style=for-the-badge)
![License](https://img.shields.io/badge/license-Apache_2.0-green.svg?style=for-the-badge)
![Bash](https://img.shields.io/badge/language-Bash-darkgreen.svg?style=for-the-badge)
![Stars](https://img.shields.io/github/stars/taezeem14/modded-ubuntu?style=for-the-badge)

*Built and engineered by **Muhammad Taezeem Tariq Matta***  
[GitHub](https://github.com/taezeem14) • [LinkedIn](https://linkedin.com/in/muhammad-taezeem-tariq-matta) • [Telegram](https://t.me/Taezeem_14)

</div>

---

## ✨ Features

### ⚙️ Core CLI Engine
An intelligent, subcommand-routing CLI framework (`ubuntu <module> <action>`). Complete with typo suggestions ("Did you mean..."), dynamic argument parsing, and built-in help systems.

### 🧩 Modular Plugin System
Hot-swappable plugins with `meta.json` manifests. Extend the OS capabilities without bloating the underlying system. Keep what you need, drop the rest. 

### 🖥️ Swappable GUI Support
Switch desktop environments like you switch browser tabs. Integrated hot-swapping between **XFCE** (balanced), **LXDE** (minimal), and **KDE** (heavy), backed by fully managed multi-instance VNC pipelines.

### 👨‍💻 Developer Tools
Idempotent environment provisioning. Spin up Node.js, Python, Git + GitHub CLI, and VS Code Server instances cleanly in seconds.

### 🛡️ Security Lab
Sandboxed cybersecurity toolkit modes. Installs Kali-grade tools (Nmap, Wireshark, Metasploit) securely. Supports isolated Kali `proot` containers. 

### 🌐 Web Dashboard
A lightweight, asynchronous local web dashboard (running over `localhost:8080`). Monitor system metrics, stream logs, and control your modules entirely from your mobile browser.

### 💾 Snapshot System
Because dependency hell is not a vibe. Create compressed system layers, timestamped and instantly restorable, directly from the CLI. 

---

## 🚀 Demo

```bash
# Install developer tools and instantly jump into a GUI
$ ubuntu dev enable
[INFO] Enabling Developer Toolkit...
[SUCCESS] Developer tools online.

$ ubuntu gui start --resolution 1280x720
[INFO] Starting GUI Server (VNC)...
[SUCCESS] GUI started on http://127.0.0.1:5901
```

---

## 📦 Installation

**Prerequisites:** Requires an Android device with Termux installed natively. 

```bash
# 1. Clone the repository
git clone https://github.com/taezeem14/modded-ubuntu.git
cd modded-ubuntu

# 2. Run the interactive installer
bash core/installer.sh

# 3. Apply the global CLI bindings
bash install.sh
```

---

## 🛠️ Usage

Once globally linked, the `ubuntu` command acts as your central command hub.

```bash
# Start the system processes
ubuntu start

# Start the local web dashboard for GUI control
ubuntu dashboard start

# Enter the isolated Kali lab
ubuntu security lab start

# Take an environment snapshot
ubuntu snapshot create "stable-setup"
```

---

## 🏗️ Architecture Overview

Built for the terminal, engineered for scale. 

```text
/core      - Core CLI engine, module loaders, and system logic
/modules   - Independent plugin directories (gui, dev, security)
/utils     - Shared components (colors, parsers, logs)
/config    - Persistent environment definitions
/snapshots - Compressed system state archives 
```

---

## 🧩 Module System (`meta.json`)

Each module operates independently. The overarching engine dynamically registers plugins by scanning their `meta.json`. 

Example `modules/dev/meta.json`:
```json
{
  "name": "Dev",
  "version": "1.1",
  "description": "Developer toolkit management (Node, Python, Git)",
  "dependencies": ["core"]
}
```

---

## ⚠️ Safety Notes (Security Mode)

**Option 1 (Default):** Security tools are safely fetched via native Ubuntu standard repos.  
**Option 2 (Kali Lab):** Spins up an entirely discrete `proot-distro` Kali image (Recommended for heavy pentesting).  
**Option 3 (Experimental):** Blends Kali rolling repos with Ubuntu. **We do not recommend this**. Pinning is enforced, but use at your own risk.

---

## 💻 CLI Help Preview

```text
Usage: ubuntu <command> [options]

Commands:
  start      Start the Ubuntu environment
  stop       Stop the Ubuntu environment
  gui        Manage GUI sessions (start, stop, switch)
  dev        Developer toolkit management (enable, disable)
  security   Cybersecurity toolkit mode management
  network    SSH server and Cloudflare tunnel integrations
  dashboard  Start/stop the local web UI
  modules    List actively loaded system modules
  snapshot   Create, list, and restore environment states
  status     Display system dashboard & utilization
```

---

## 📸 Screenshots

* **CLI Usage:** Clean ANSI-colored terminal output with timestamped logging and error catching.
* **Dashboard UI:** A sleek, dark-mode JSON status readout parsing live stats over a Flask local server.
* **GUI Desktop:** A full desktop Linux graphical environment (XFCE) rendering at 60fps via VNC Viewer on Android. 

---

## 🗺️ Roadmap & Features Implemented

- [x] **Remote SSH tunnel integrations** (Use `ubuntu network ssh-start` & `tunnel` via Cloudflare).
- [x] **Automated GUI resolution adjustments** (Use `ubuntu gui auto-resize` based on device orientation).
- [x] **GUI-based Marketplace on the Web Dashboard** (Check the `/marketplace` route on your local dashboard!).
- [x] **Hardware acceleration (VirGL) support** (Use `ubuntu gui start --virgl` for smooth KDE/XFCE rendering).

---

## 🤝 Contributing

Contributions are always welcome! Feel free to open a PR or raise an issue. 

1. Fork the repo.
2. Create your module in `/modules/your-module`.
3. Provide a `meta.json` and `cli.sh`.
4. Submit a Pull Request.

---

## 📄 License

This masterpiece is distributed under the **Apache 2.0 License**. See `LICENSE` for more information.

---
<div align="center">
<b>Initiated, designed, and authored by Muhammad Taezeem Tariq Matta</b>
</div>
