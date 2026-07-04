# BugNix
This is my personal NixOS config that I use for Gamedev, Gaming, and Vtubing. It's currently very messy, but I am working on cleaning it up. 

# My Setup
I am running NixOS bare metal on my desktop machine. I run it dual booted with Windows 11 using systemd-boot. 

I decided to go with NixOS as the declarative nature of it is more comfortable for me, as I can very quickly get out of control with imperative package management. Having a file to declare packages and versions makes organization significantly easier for me. Also, the reproducability is an extra cherry on top, as it allows me to instantly copy my main workstation over to my laptop. 
Hyprland was my immediate choice for a compositor, as the highly customizable nature of the binds allows me to streamline my multitask workflow. (also it has vibes)

# What I Use NixOS For
I am a Vtuber (twitch.tv/bugeenka, btw), Content Creator, Game Developer, Tinkerer and Gaymer. I needed a hyper customized work environment that I can fine tune to my needs. I was constantly finding myself needing to bounce back in forth between Fedora and Windows to accomplish what I wanted (even running my fedora laptop into my Windows desktop with a capture card at one point).
I decided to bite the bullet and learn nix, and it's been perfect for my needs.

## Programs I Use
I mean you can see the packages in the .nix files, but my primary programs are:
- OBS
- Steam
- Warudo
- Scarlett2
- Spotify
- Wine
- Bottles
- Lutris
- Thunar
- Deckmaster
- VSCodium
- Kitty
- Swayimg
- Audacity
- Chatterino
- Godot
- GIMP
- Blender
- VLC
- Thunderbird
- And More!

# My To do:
- Move packages and configs to their respective .nix files
- Fix Pipewire + Wireplumber configuration
- Add hyprland.lua config to a .nix
- Add Waybar config to a .nix
- Properly configure flake.nix
- remove home-manager(?)
- Add deckmaster config to a .nix (Maybe)
