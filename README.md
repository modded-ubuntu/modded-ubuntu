<div align="center">

# 🐧 Modded Ubuntu for Termux

### *Modern Ubuntu Desktop (XFCE4) environment for Android without root.*

<p align="center">
  <a href="#"><img src="https://img.shields.io/badge/Ubuntu-26.04%20LTS-E95420?style=for-the-badge&logo=ubuntu&logoColor=white" alt="Ubuntu 26.04 LTS" /></a>
  <a href="#"><img src="https://img.shields.io/badge/Platform-Termux%20%7C%20Android-17B877?style=for-the-badge&logo=android&logoColor=white" alt="Termux" /></a>
  <a href="#"><img src="https://img.shields.io/badge/Desktop-XFCE4-0099FF?style=for-the-badge&logo=xfce&logoColor=white" alt="XFCE4" /></a>
  <a href="./LICENSE"><img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg?style=for-the-badge" alt="License" /></a>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu.github.io/refs/heads/master/img/1.png" alt="Preview" aspect width="100%"/>
</p>

<p align="center">
  <a href="https://github.com/modded-ubuntu/modded-ubuntu/stargazers"><img src="https://img.shields.io/github/stars/modded-ubuntu/modded-ubuntu?style=flat-square&logo=github&color=gold" alt="Stars" /></a>
  <a href="https://github.com/modded-ubuntu/modded-ubuntu/network/members"><img src="https://img.shields.io/github/forks/modded-ubuntu/modded-ubuntu?style=flat-square&logo=github&color=teal" alt="Forks" /></a>
  <a href="https://github.com/modded-ubuntu/modded-ubuntu/issues"><img src="https://img.shields.io/github/issues/modded-ubuntu/modded-ubuntu?style=flat-square&color=red" alt="Issues" /></a>
  <a href="https://github.com/modded-ubuntu/modded-ubuntu/pulls"><img src="https://img.shields.io/github/issues-pr/modded-ubuntu/modded-ubuntu?style=flat-square&color=orange" alt="PRs" /></a>
  <a href="https://github.com/modded-ubuntu/modded-ubuntu/commits/master"><img src="https://img.shields.io/github/last-commit/modded-ubuntu/modded-ubuntu?style=flat-square&logo=git&color=informational" alt="Last Commit" /></a>
  <a href="./CHANGELOG.md"><img src="https://img.shields.io/badge/Version-2.1.0-blue?style=flat-square" alt="2.1.0" /></a>
</p>

<p align="center">
  <a href="#-features">Features</a> •
  <a href="#-system-requirements">Requirements</a> •
  <a href="#-installation">Installation</a> •
  <a href="#-video-tutorial">Video Tutorial</a> •
  <a href="#-contributors">Contributors</a> •
  <a href="./CHANGELOG.md">Changelog</a>
</p>

---

</div>

## 🌟 Features

- 🔒 **No Root Required**
- 🚀 **Latest Ubuntu 26.04**
- ⚡ **Fully Automatic Setup**
- 🌐 **Pre-patched Web Browsers**
- 🔊 **Fixed Audio Output**
- 🎨 **Beautiful Desktop Look**
- 🖱️ **Lightweight & Modular**


  |Web Browsers|IDE|
  |--|--|
  |![firefox](https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu.github.io/refs/heads/master/img/3.png)|![vscode](https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu.github.io/refs/heads/master/img/5.png)|
  |![chromium](https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu.github.io/refs/heads/master/img/2.png)|![sublime](https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu.github.io/refs/heads/master/img/4.png)|

---

## 📋 System Requirements

| Requirement | Recommended Specification |
|:---|:---|
| **Operating System** | Android 7.0 (Nougat) or higher |
| **Terminal App** | Termux *(v0.118+ from F-Droid or GitHub)* • [**F-Droid**](https://f-droid.org/en/packages/com.termux/) • [Github](https://github.com/termux/termux-app/releases/latest) |
| **Available Storage** | At least **4 GB - 8 GB** free space |
| **Architecture** | `aarch64` / `arm64` *(recommended)*, `armhf`, `x86_64` |
| **VNC Client** | [**RealVNC Viewer**](https://play.google.com/store/apps/details?id=com.realvnc.viewer.android) or [AVNC](https://f-droid.org/packages/com.gaurav.avnc/) |

---

## ⚡ Installation

> [!IMPORTANT]
> Always install **Termux** from [F-Droid](https://f-droid.org/en/packages/com.termux/) or [GitHub Releases](https://github.com/termux/termux-app/releases/latest).

### Step 1: Clone & Run Installer

Open Termux and execute the following commands:

```bash
yes | pkg up

pkg install git wget -y

# Clone repository
git clone --depth=1 https://github.com/modded-ubuntu/modded-ubuntu.git
cd modded-ubuntu
bash setup.sh
```

> [!NOTE]
> During setup, you will be prompted to enter a **username** for your Ubuntu environment *(must be lowercase, no spaces)*.

---

### Step 2: Configure Desktop GUI

After the base environment finishes installing, restart Termux and run:

```bash
ubuntu
sudo bash gui.sh
```

> [!NOTE]
> Follow the on-screen prompts to select your desired desktop components and **set your VNC password**.

---

## 🖥️ How to Connect

### 1. Start the VNC Server

Inside Ubuntu start the VNC server:

```bash
vncstart
```

To shut down the server:

```bash
vncstop
```

### 2. Connect via VNC Viewer

1. Tap the **`+`** (Add) button.
2. Configure the connection:
   - **Address**: `localhost:1`
   - **Name**: `Modded Ubuntu` (or anything you prefer)
3. Set **Picture Quality** to **High**.
4. Tap **Connect**, enter the password and enjoy your Linux desktop!

---

## 📹 Video Tutorial

Need a step-by-step demonstration? Watch the video below:

<div align="center">
  <a href="https://modded-ubuntu.github.io/#tutorial" target="_blank" rel="noopener noreferrer">
    <img src="https://raw.githubusercontent.com/modded-ubuntu/modded-ubuntu.github.io/refs/heads/master/img/7.png" alt="Tutorial" width="85%" />
  </a>
</div>

---

## 👥 Contributors

A huge shoutout to everyone who has contributed to improving this project!

<div align="center">
  <a href="https://github.com/modded-ubuntu/modded-ubuntu/graphs/contributors">
    <img src="https://contrib.rocks/image?repo=modded-ubuntu/modded-ubuntu" alt="Contributors" style="border-radius: 8px;" />
  </a>
</div>


## 📄 Credits

```
This project utilizes the official Ubuntu rootfs distribution powered by Termux PRoot-Distro

All credit for base container distribution goes to the PRoot-Distro maintainers.

Termux Proot Distro - https://github.com/termux/proot-distro
```

### See the full [Changelog](./CHANGELOG.md) for version release notes.

---

## Star History

<a href="https://www.star-history.com/?repos=modded-ubuntu%2Fmodded-ubuntu&type=date&legend=top-left">
 <picture>
   <source srcset="https://api.star-history.com/chart?repos=modded-ubuntu/modded-ubuntu&type=date&theme=dark&legend=top-left" />
   <source srcset="https://api.star-history.com/chart?repos=modded-ubuntu/modded-ubuntu&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=modded-ubuntu/modded-ubuntu&type=date&legend=top-left" />
 </picture>
</a>

<div align="center">
  <h4>⭐ If you find this project helpful, please consider giving it a star! ⭐</h4>
</div>
