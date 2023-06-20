# fedora-post-install
A Fedora Workstation post installation script

This is WIP! More features to be added and a lot of code cleanup and compartmentalization.  

## How to use
- `git clone` this repo  
- `cd fedora-post-install`  
- `./fedora-post-install.sh`
  
## What it includes

- ### Enable RPM Fusion
Enables the RPM Fusion free and non-free repos.

- ### Update system
Updates the system packages to the latest version. Does not upgrade to a new Fedora release.

- ### Enable flathub repository
Removes Fedora's filtered flathub version and adds the full Flathub repository. Also updates any flatpaks that are installed.

- ### Installs ffmpeg (full version), multimedia codecs, Vulkan

- ### Install Intel Drivers to enable hardware accelerated video envoding/decoding

- ### Installs NVidia drivers  

- ### Installs Extension Manager for GNOME  

- ### Speed up performance, boot and shutdown
:warning:**! These are not tested on AMD machines. !**  
Grub timeout changed from 5 secs to 2 secs.  
Systemd stop units timeouts changed from 90secs to 15secs.  
Disables mitigations for Intel processors.  
Disables boot splash screen.  
Disables Staggered Spin-up. [(archwiki)](https://wiki.archlinux.org/title/Improving_performance/Boot_process#Staggered_spin-up)  
Disables NetworkManager-wait-online.service  
Disables ModemManager.service  
Enables Sata Active Link Power Management to med_power_with_dipm. [(archwiki)](https://wiki.archlinux.org/title/Power_management#SATA_Active_Link_Power_Management)  
Sets I/O schedulers: *bfq* for HDD and SSD, *none* for NVMe. [(youtube)](https://youtu.be/1B3P3OziWlI)  
Increases vm.max_map_count to 2147483642 [(fedora)](https://fedoraproject.org/wiki/Changes/IncreaseVmMaxMapCount)  

- ### Removes GNOME's applications
Calendar, Contacts, Maps, Weather, Photos, Software Center, Remote Desktops, Simple Scan, Totem, Help, Rygel, Tracker miners

- ### Disables some of GNOME's services for a smoother experience
