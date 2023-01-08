<p align="center">
<img src="./distro/image.jpg">
</p>
<p align="center">
<img src="https://img.shields.io/badge/MADE%20IN-BANGLADESH-green?colorA=%23ff0000&colorB=%23017e40&style=for-the-badge">
<img src="https://img.shields.io/badge/Version-1.0-blue?style=for-the-badge">
</p>
<p align="center">
<img src="https://img.shields.io/badge/Written%20In-Bash-darkgreen?style=flat-square">
<img src="https://img.shields.io/badge/Open%20Source-Yes-darkviolet?style=flat-square">
<img src="https://img.shields.io/github/stars/modded-ubuntu/modded-ubuntu?style=flat-square">
<img src="https://img.shields.io/github/issues/modded-ubuntu/modded-ubuntu?color=red&style=flat-square">
<img src="https://img.shields.io/github/forks/modded-ubuntu/modded-ubuntu?color=teal&style=flat-square">
</p>
<p align="center"><b>Run Ubuntu GUI on your termux with much features.</b></p>

### Features

- Fixed Audio Output
- Lightweight {Requires at least 4GB Storage}
- Katoolin3 tool for installing kali tools
- 2 Browsers (Chromium & Mozilla Firefox)
- Supports Bangla Fonts
- VLC Media Player and MPV media player
- Visual Studio Code (buggy on arm )
- Sublime Text Editor (only for arm64/aarch64)
- Easy for Beginners
- Comes with some cool themes.

### Installation
- Firstly install [Termux](https://termux.com) apk from [HERE](https://f-droid.org/repo/com.termux_118.apk)
- Secondly Clone the Repository & Run the setup File

  - `pkg update -y && pkg upgrade -y`
  - `pkg install git wget -y`
  - `git clone https://github.com/modded-ubuntu/modded-ubuntu.git`
  - `cd modded-ubuntu`
  - `bash setup.sh`

- Then Restart your Termux & Type the following commands

  - `ubuntu`
  - `bash user.sh`

- Type your ubuntu root username. Must be lowercase & no space included.

- Then Again Restart your Termux & Type the following commands

  - `ubuntu`
  - `bash gui.sh`

- **You have to note your VNC password !!**

- Ubuntu image is now successfully installed .

  - Type `vncstart` to run Vncserver
  - Type `vncstop` to stop Vncserver

- Install VNC VIEWER Apk on your Device. [Google Play Store](https://play.google.com/store/apps/details?id=com.realvnc.viewer.android&hl=en)

- Open VNC VIEWER & Click on + Button & Enter the Address `localhost:1` & Name anything you like
- Set the Picture Quality to High for better Quality
- Click on Connect & Input the Password 
- Enjoy :D

### NOTE :

- **Type `ubuntu` to run Ubuntu CLI.**
- **Type `vncstart` to run Vncserver**
- **Type `vncstop` to stop Vncserver**

- **Type `bash remove.sh` to remove Ubuntu Modded Os**

### Video Tutorial : 

[![Watch the Tutorial](./distro/image1.jpg)](https://mega.nz/embed/QvIC1TLQ#3z27MRNPwANAg6JTtx1Ei8kDouOZsZgk00bg4TsJMNQ!1m)

### Credits : 

```
This Tool Uses the ubuntu image provided by the termux package `proot-distro` 

Full Credit of the Ubuntu image goes to them .

Termux Proot Distro - https://github.com/termux/proot-distro
```
### Issues :
 [**FIXED**]Firefox browser not working:- [issue](https://github.com/modded-ubuntu/modded-ubuntu/issues/73)
- solution:- [click here](https://www.omgubuntu.co.uk/2022/04/how-to-install-firefox-deb-apt-ubuntu-22-04/amp)
- solution 2:- [click here](https://github.com/modded-ubuntu/modded-ubuntu/issues/76#issuecomment-1243747144) -- Thanks to [Reddysan1433](https://github.com/Reddysan1433)
### Maintainers

- [**Mustakim Ahmed**](https://github.com/BDhackers009)
- [**Tahmid Rayat**](https://github.com/htr-tech)

### If you like our work then dont forget to give a Star :)

