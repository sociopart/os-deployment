# List the available recipes and tweaks
default:
	just --list

# Add alias name with 'action' to "file"
alias name action file:
	echo "alias {{name}}='{{action}}'" >> {{file}}

# Sets the Git SSH key ("key-name")
git-user-init key-name:
	ssh-keygen -t rsa -b 4096 -C {{key-name}}

# Shows the Git SSH key
git-show-pkey:
	cat ~/.ssh/id_rsa.pub

# Sets the Git credentials like ("username") and ("email")
git-set-creds username email:
	git config --global user.name {{username}}
	git config --global user.email {{email}}

# Fix Linux/Windows duatboot time difference bug
set-rtc-time:
	timedatectl set-local-rtc 1

# Set Alt-Shift hotkey for language switch
set-hk-language:
	gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'ru')]"
	gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Shift>Alt_L']"
	gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['<Alt>Shift_L']"

# Set PrintScreen for in-file screenshot, and Super-Shift-S for showing screenshot interface
set-hk-screenshots:
	gsettings set org.gnome.shell.keybindings screenshot "['Print']"
	gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Super><Shift>S']"

# Set various useful tweaks for the system
set-various-tweaks:
	# Center new windows opened by Gnome (default placement was left-up)
	gsettings set org.gnome.mutter center-new-windows true
	
	# Disable auto-enabled Bluetooth on startup (set AutoEnable=false)
	sudo gedit /etc/bluetooth/main.conf

# Remove LibreOffice completely from the system
remove-libreoffice:
	sudo apt-get remove --purge "libreoffice*"
	sudo apt-get clean
	sudo apt-get autoremove

# Install Microsoft fonts for better compatibility inside Office files
install-ms-fonts:
	sudo add-apt-repository -y multiverse
	sudo apt update && sudo apt install -y ttf-mscorefonts-installer
	wget -q -O - https://gist.githubusercontent.com/Blastoise/72e10b8af5ca359772ee64b6dba33c91/raw/2d7ab3caa27faa61beca9fbf7d3aca6ce9a25916/clearType.sh | bash
	wget -q -O - https://gist.githubusercontent.com/Blastoise/b74e06f739610c4a867cf94b27637a56/raw/96926e732a38d3da860624114990121d71c08ea1/tahoma.sh | bash
	wget -q -O - https://gist.githubusercontent.com/Blastoise/64ba4acc55047a53b680c1b3072dd985/raw/6bdf69384da4783cc6dafcb51d281cb3ddcb7ca0/segoeUI.sh | bash
	wget -q -O - https://gist.githubusercontent.com/Blastoise/d959d3196fb3937b36969013d96740e0/raw/429d8882b7c34e5dbd7b9cbc9d0079de5bd9e3aa/otherFonts.sh | bash	

# Install latest Google Chrome from DEB package
install-chrome:
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	sudo dpkg -i google-chrome-stable_current_amd64.deb
	rm google-chrome-stable_current_amd64.deb
	
# Install latest Telegram Desktop from DEB package
install-telegram:
	wget https://telegram.org/dl/desktop/linux -O telegram-linux.tar.xz
	tar -xJf telegram-linux.tar.xz
	sudo cp ./Telegram /usr/bin
	rm telegram-linux.tar.xz

# Install latest Visual Studio Code from DEB package (with auto-updates)
install-vscode:
	echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections
	sudo apt-get install wget gpg
	wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
	sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
	echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
	rm -f packages.microsoft.gpg
	sudo apt install apt-transport-https
	sudo apt update
	sudo apt install code

# Test Docker Engine commands to verify the future installation
[private]
install-docker-test:
	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh ./get-docker.sh --dry-run

# Install Docker Engine
[private]
[confirm('Install Docker Engine?')]
install-docker-engine:
	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh ./get-docker.sh	

# Install latest Docker engine
install-docker: install-docker-test install-docker-engine

# Install essential software for work, like Git or so
install-essentials:
	sudo apt install git

# Install latest ULauncher
install-ulauncher:
	# https://github.com/Ulauncher/Ulauncher/wiki/Hotkey-In-Wayland
	sudo add-apt-repository universe -y && sudo add-apt-repository ppa:agornostal/ulauncher -y && sudo apt update && sudo apt install ulauncher
	systemctl --user enable --now ulauncher
	