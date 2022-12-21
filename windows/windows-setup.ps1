# enable pwshell run not signed script
Set-ExecutionPolicy Unrestricted

# Install scoop
# When scoop already installed, run 'D:\Software\Scoop\apps\scoop\current\bin\refresh.ps1' to enable scoop agian
# You may also add %SCOOP%\shims to PATH
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
$env:SCOOP='D:\Software\Scoop'
[Environment]::SetEnvironmentVariable('SCOOP', $env:SCOOP, 'User')
$env:SCOOP_GLOBAL='D:\Software\Scoop'
[Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', $env:SCOOP_GLOBAL, 'Machine')
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
# Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
irm https://raw.fastgit.org/scoopinstaller/install/master/install.ps1 -o scoop-install.ps1
# If want to work under proxy, scoop also obey to general proxy environment variables.
# all install command will bypass proxy, eg.:
# [Environment]::SetEnvironmentVariable('http_proxy','localhost:8889', 'Machine')
# [Environment]::SetEnvironmentVariable('https_proxy','localhost:8889', 'Machine')
# or by internal config: scoop config proxy localhost:8889
(Get-Content scoop_install.ps1).replace('https://github.com/ScoopInstaller/', 'https://hub.fastgit.xyz/ScoopInstaller/') | Set-Content scoop_install.ps1
.\scoop_install.ps1

scoop install sudo
# TODO: install git-windows.exe from inland mirror site
sudo Copy-Item .gitconfig ~ -Force

scoop bucket add \
	extras \
	mochi \
	nonportable \
	nerd-fonts \
    java
scoop install \
	arduino \
	obs-studio \
	goldendict \
	irfanview \
	clion \
	pulseview \
	openocd \
	gcc-arm-none-eabi \
	ninja \
	wireshark \
	kdiff3 \
	kicad \
	mingw \
	portable-virtualbox \
	v2ray \
	qv2ray \
    aria2 \
    typora \
    sudo \
    busybox \
    deskpins \
    ditto \
    vim \
    windows-terminal \
    sumatrapdf \
    everything \
    winpython \
    adoptopenjdk-lts-hotspot \
	vscode \
    windows-terminal \
    alacritty \
    etcher \
	notepad3 \
	googlechrome \
	listary1desktop \
	telegram \
    cmake \
	winscp \
    anki@2.1.15 \
    picgo \
    nodejs \
    yarn \
    vlc \
    rufus \
    hugo \
    vcredist2022 \
    zeal \
    logseq \
	mosh-client \
    powertoys \
	vncviewer \
	snipaste \
	trafficmonitor \
	zadig-np

scoop install --global \
    firacode \
    JetBrains-Mono \
    Cascadia-Code \
    SarasaGothic-ttc

# setup wsl + arch linux （Version 1903 or higher, with Build 18362 or higher）
# maybe wsl.exe --install alse works
# refers to:
# https://rashil2000.me/blogs/kde-arch-wsl
# https://github.com/yuk7/ArchWSL/issues/190
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
# reboot !!!
# install  wsl_update_x64.msi from https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi

wsl --set-default-version 2
scoop install lxrunoffline
if (!(Test-Path -Path 'D:\Download')) {
      mkdir 'D:\Download'
}
Invoke-WebRequest -Uri https://mirrors.edge.kernel.org/archlinux/iso/2022.10.01/archlinux-bootstrap-2022.10.01-x86_64.tar.gz -Out D:\Download\archlinux-bootstrap.tar.gz

if (!(Test-Path -Path 'D:\WSL\arch')) {
      mkdir 'D:\WSL\arch'
}

lxrunoffline.exe i -n Arch -d D:\WSL\arch\ -f D:\Download\archlinux-bootstrap.tar.gz -r root.x86_64

# check whether install on wsl2
# wsl -l -v
# if not, convert to wsl2
# wsl --set-version Arch 2

# start archlinux
wsl ~ -d Arch
# config use tencent source mirror:
# Server = https://mirrors.cloud.tencent.com/archlinux/$repo/os/$arch
notepad.exe /etc/pacman.d/mirrorlist
# install basic devel tools
pacman-key --init
pacman-key --populate archlinux
pacman -Syu base base-devel vim
# add non-root user:
# useradd -m -G wheel username
# passwd username
# EDITOR=vim visudo
# uncomment the line that says %wheel ALL=(ALL) ALL
# Exit Arch. To make this new user the default user of Arch:
# LxRunOffline su -n Arch -v 1000

# oh-my-posh command prompt fot microsoft terminal:
# Install-Module posh-git -Scope CurrentUser
# Install-Module oh-my-posh -Scope CurrentUser

