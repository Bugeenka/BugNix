{ config, pkgs, ... }:

{


## Packages
environment.systemPackages = with pkgs; [

  kitty
  hyprlock
  dunst
  waybar
  hyprlauncher
  wl-clipboard
  kdePackages.kio
  kdePackages.kio-extras
  kdePackages.kde-cli-tools
  kdePackages.kservice
  kdePackages.ark
  mission-center
  grim
  slurp
  hyprsysteminfo
  thunar
  thunar-volman
  thunar-archive-plugin

## Services



];
}
