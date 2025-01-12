# Description: Makefile for supported Windows deployment and configuration
# Usage:       make.exe -i -f windows.mk <command>

# To get Make on Windows:
# 32-bit: https://www.equation.com/ftpdir/make/32/make.exe
# 64-bit: https://www.equation.com/ftpdir/make/64/make.exe

.PHONY: install-winget install-msvcrt install-runtimes \ 
		install-browser install-klcp install-websvc    \
		install-dev  install-misc install-office       \
		install-klcp install-essentials install

# Helper variables
TEMP_DIR      = $(or $(temp),$(TEMP))
VER           = cmd /c ver
WINGET        = winget
WINDOWNLOAD   = bitsadmin /transfer downloadJob /download /priority normal
WINVERWORDS   = $(wordlist 1,2,$(subst ., ,$(lastword $(shell $(VER)))))
WINVER        = $(firstword $(WINVERWORDS)).$(lastword $(WINVERWORDS)) # ifeq '$(WINVER)' '5.1'

# download-gh-release (user, project, version(or skip it if latest), filename, output_path)
download-gh-release-latest = $(WINDOWNLOAD) https://github.com/$(1)/$(2)/releases/latest/download/$(3)  $(4)
download-gh-release-ver    = $(WINDOWNLOAD) https://github.com/$(1)/$(2)/releases/download/$(3)/$(4)    $(5)

# TODO: 
# - explorer settings
# - create games folder
# - create soft folder
# - script for "cure" :)
# - misc stuff that was on .bat files

# Install Winget on non-Store Windows builds
install-winget:
	@echo "Installing Winget..."
	powershell "irm https://github.com/asheroto/winget-install/releases/latest/download/winget-install.ps1 | iex"

# Install VCRedist runtime
install-msvcrt:
	@echo "Installing VCRedist..."
	$(call download-gh-release-latest,abbodi1406,vcredist,VisualCppRedist_AIO_x86_x64.exe,"$(TEMP_DIR)\VisualCppRedist_AIO_x86_x64.exe")
	$(TEMP_DIR)\VisualCppRedist_AIO_x86_x64.exe /y

# Install essential runtimes
install-runtimes: install-msvcrt
	@echo "Installing essential runtimes..."
	$(WINGET) install -e --id Oracle.JavaRuntimeEnvironment

# Install browser(s)
install-browser:
	@echo "Installing browser(s)..."
	$(WINGET) install -e --id Google.Chrome
#	$(WINGET) install -e --id Mozilla.Firefox
#	$(WINGET) install -e --id Hibbiki.Chromium
#	$(WINGET) install -e --id win32ss.Supermium
#	$(WINGET) install -e --id Opera.Opera
#	$(WINGET) install -e --id Opera.OperaGX
#	$(WINGET) install -e --id Yandex.Browser
#	$(WINGET) install -e --id Brave.Brave
#	$(WINGET) install -e --id Microsoft.Edge
#	$(WINGET) install -e --id Vivaldi.Vivaldi

# Install desktop apps for popular web services
install-websvc:
	@echo "Installing desktop apps for popular web services..."
# $(WINGET) install -e --id Yandex.Music
	$(WINGET) install -e --id Discord.Discord
	$(WINGET) install -e --id Valve.Steam
	$(WINGET) install -e --id Telegram.TelegramDesktop
# $(WINGET) install -e --id Spotify.Spotify
# $(WINGET) install -e --id Microsoft.Teams
# $(WINGET) install -e --id Zoom.Zoom
# $(WINGET) install -e --id Microsoft.Skype
	
# Install tools useful for developers
install-dev:
	@echo "Installing tools useful for developers..."
	$(WINGET) install -e --id Git.Git
	$(WINGET) install -e --id Notepad++.Notepad++
	$(WINGET) install -e --id Microsoft.VisualStudioCode

# Install miscellaneous utilities
install-misc:
	@echo "Installing miscellaneous utilities..."
	$(WINGET) install -e --id voidtools.Everything
	$(WINGET) install -e --id Greenshot.Greenshot
	$(WINGET) install -e --id OBSProject.OBSStudio

# Install office productivity suite
install-office:
	@echo "Installing office productivity suite..."
	$(WINGET) install -e --id Kingsoft.WPSOffice
	$(WINGET) install -e --id TheDocumentFoundation.LibreOffice
	$(WINGET) install -e --id Apache.OpenOffice

# Install K-Lite Codec Pack
install-klcp:
	@echo "Installing K-Lite Codec Pack..."
#   Basic / Standard / Full / Mega
	$(eval KLCP_VERSION = Mega) 
	$(WINGET) install -e --id CodecGuide.K-LiteCodecPack.$(KLCP_VERSION)

# Install essential tools
install-essentials:
	@echo "Installing essential tools..."
	$(WINGET) install -e --id qBittorrent.qBittorrent
	$(WINGET) install -e --id 7zip.7zip
	$(WINGET) install -e --id Unchecky.Unchecky
#	$(WINGET) install -e --id Adobe.Acrobat.Reader.32-bit
#	$(WINGET) install -e --id Adobe.Acrobat.Reader.64-bit
# $(WINGET) install -e --id SumatraPDF.SumatraPDF

# Launch installation process
install: install-browser install-essentials install-runtimes install-klcp \
		 install-office install-misc                                      \
		 install-dev install-websvc                                       \