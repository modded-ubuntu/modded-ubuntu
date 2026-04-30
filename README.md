<div align="center">

# 🚀 Termux Ubuntu Environment Manager

**A highly advanced, modular, and production-grade platform transforming Termux into a full-fledged Linux distribution lab.**

> Turn your Android device into a fully modular Linux workstation — powered entirely from Termux.

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

An intelligent, subcommand-routing CLI framework (`ubuntu <module> <action>`). Complete with typo suggestions, dynamic argument parsing, and built-in help systems.

### 🧩 Modular Plugin System

Hot-swappable plugins with `meta.json` manifests. Extend the OS capabilities without bloating the system.

### 🖥️ Swappable GUI Support

Switch between **XFCE**, **LXDE**, and **KDE** with managed multi-instance VNC pipelines.

### 👨‍💻 Developer Tools

Quickly provision Node.js, Python, Git + CLI, and VS Code Server.

### 🛡️ Security Lab

Sandboxed toolkit with safe installs (Nmap, Wireshark, Metasploit) + isolated Kali containers.

### 🌐 Web Dashboard

Control everything from a local web UI (`localhost:8080`) — monitor stats, logs, and modules.

### 💾 Snapshot System

Create and restore full system states instantly. No more dependency nightmares.

---

## 🧠 Why This Exists

Because a phone shouldn’t just be a phone.

This project transforms Termux into a controllable Linux environment with modular architecture, dev tools, and cybersecurity capabilities — without unnecessary bloat.

---

## 🚀 Demo

```bash
$ ubuntu dev enable
[INFO] Enabling Developer Toolkit...
[✔] Node.js installed
[✔] Python environment ready
[✔] Git configured
[SUCCESS] Developer tools online.

$ ubuntu gui start --resolution 1280x720
[INFO] Starting GUI Server (VNC)...
[INFO] Allocating display :1
[SUCCESS] GUI available at http://127.0.0.1:5901
```

---

## 📦 Installation

**Prerequisites:** Android device with Termux installed

> ⚡ Installation takes ~5–10 minutes depending on device performance.

```bash
git clone https://github.com/taezeem14/modded-ubuntu.git
cd modded-ubuntu

bash core/installer.sh
bash install.sh
```

---

## 🛠️ Usage

```bash
ubuntu start
ubuntu dashboard start
ubuntu security lab start
ubuntu snapshot create "stable-setup"
```

---

## 🏗️ Architecture Overview

```text
/core      - Core CLI engine & system logic
/modules   - Plugin-based modules
/utils     - Shared utilities
/config    - Persistent configs
/snapshots - System state backups
```

---

## 🧩 Module System

Modules are dynamically discovered at runtime — no manual linking required.

Example:

```json
{
  "name": "Dev",
  "version": "1.1",
  "description": "Developer toolkit",
  "dependencies": ["core"]
}
```

---

## ⚠️ Safety Notes

* Default: Safe Ubuntu packages
* Kali Lab: Isolated container (recommended)
* Kali Repo: Experimental ⚠️ (not recommended)

---

## 💻 CLI Help Preview

```bash
Usage: ubuntu <command> [options]

Commands:
  start      Start environment
  stop       Stop environment
  gui        Manage GUI
  dev        Developer tools
  security   Security lab
  dashboard  Web UI
  modules    List modules
  snapshot   Manage states
  status     System info
```

---

## 📸 Screenshots

> What this actually looks like in action 👇

* CLI: Colored logs + clean output
* Dashboard: Dark-mode local web UI
* GUI: Full Linux desktop via VNC

---

## 🗺️ Roadmap

* [x] SSH + Cloudflare tunnels
* [x] Auto GUI scaling
* [x] Dashboard marketplace
* [x] VirGL acceleration
* [ ] CLI module marketplace
* [ ] Multi-profile system

---

## 🤝 Contributing

1. Fork repo
2. Create module in `/modules/`
3. Add `meta.json` + `cli.sh`
4. Submit PR

---

## 📄 License

Apache 2.0 License — see `LICENSE`.

---

<div align="center">

<b>Initiated, designed, and engineered by Muhammad Taezeem Tariq Matta</b>

<br>

> Built with obsession, late nights, and a deep love for Linux.

</div>
