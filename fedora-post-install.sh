#!/usr/bin/bash
# Script optimizing a Fedora Workstation 38 Gnome installation
# Check RPMFusion site for more info: rpmfusion.org/Howto
 
# enable dnf parallel downloads
echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf
 
# update
sudo dnf upgrade -y
 
# flathub
sudo flatpak remote-delete flathub
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update -y
 
# enable RPMFusion free and nonfree
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
 
# Add the Appstream metadata
sudo dnf groupupdate -y core
 
# Add the tainted rpm repo
# needed ?
 
# Switch to full ffmpeg
sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
 
# Install the multimedia pkgs need by gstreamer enabled applications
sudo dnf groupupdate -y multimedia --setop "install_weak_deps=False" --exclude="PackageKit-gstreamer-plugin"
 
# Install the sound-and-video complement packages needed by some applications
sudo dnf groupupdate -y sound-and-video
 
# install intel driver
sudo dnf install -y intel-media-driver
 
# install nvidia driver
#sudo dnf install -y akmod-nvidia nvidia-vaapi-driver
 
# install vulkan
sudo dnf install -y vulkan
 
# install GNOME Extension manager
flatpak install -y com.mattjakeman.ExtensionManager
 
# enable virtualization support
#sudo dnf install -y @virtualization
#sudo systemctl enable libvirtd
 
# cleanup
sudo dnf autoremove -y
 
# Make systemd stop services faster on shutdown
sudo sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf
sudo sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/user.conf
 
# Disable useless services
sudo systemctl disable NetworkManager-wait-online.service
sudo systemctl mask NetworkManager-wait-online.service
sudo systemctl disable ModemManager.service
sudo systemctl mask ModemManager.service
 
#mv.max_map_count tweak (Remove for Fedora 39, as it will be included)
echo "vm.max_map_count=2147483642" | sudo tee -a /etc/sysctl.conf
 
# shorter grub timeout
sudo sed -i 's/GRUB_TIMEOUT.*/GRUB_TIMEOUT=1/' /etc/default/grub
sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
 
## TODO
# add kernel params
# add io schedulers
# disable xdg/etc/autostart
# find intel/nvidia missing drivers and hw accel packages
# mess more with systemctl services and components
# default dnf to Y
# debloat more (drivers and firmware blobs)
# implement cleaning of old kernels / boot images

# remove gnome apps
sudo dnf remove -y \
gnome-calendar \
gnome-contacts \
gnome-maps \
gnome-weather \
gnome-photos \
gnome-software \
gnome-user-docs \
gnome-user-share \
gnome-remote-desktop \
simple-scan \
totem \
yelp \
rygel \
tracker-miners

# evolution-data-server 
# malcontent

# disable gnome services
systemctl --user mask org.gnome.SettingsDaemon.Wacom.service
systemctl --user mask org.gnome.SettingsDaemon.PrintNotifications.service
systemctl --user mask org.gnome.SettingsDaemon.Color.service
systemctl --user mask org.gnome.SettingsDaemon.A11ySettings.service
systemctl --user mask org.gnome.SettingsDaemon.Wwan.service
systemctl --user mask org.gnome.SettingsDaemon.UsbProtection.service
systemctl --user mask org.gnome.SettingsDaemon.ScreensaverProxy.service
systemctl --user mask org.gnome.SettingsDaemon.Sharing.service
systemctl --user mask org.gnome.SettingsDaemon.Rfkill.service
systemctl --user mask org.gnome.SettingsDaemon.Keyboard.service
systemctl --user mask org.gnome.SettingsDaemon.Sound.service
systemctl --user mask org.gnome.SettingsDaemon.Smartcard.service
systemctl --user mask org.gnome.SettingsDaemon.Power.service
systemctl --user mask evolution-addressbook-factory.service
systemctl --user mask evolution-calendar-factory.service
systemctl --user mask evolution-source-registry.service
systemctl --user mask tracker-miner-fs-3.service

# clean gnome tracker cache and kill tracker daemon
rm -rf ~/.cache/tracker ~/.local/share/tracker
tracker3 daemon -t
