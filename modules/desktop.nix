{ inputs, config, pkgs, lib, ... }:

{
  
  nixpkgs.config.allowUnfree = true;

## Packages
environment.systemPackages = with pkgs; [

  alacritty 
  hyprlock
  dunst
  waybar
  vicinae
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
  nautilus
  thunar
  thunar-volman
  thunar-archive-plugin
  pdfstudioviewer
  xwayland-satellite
  inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  tailscale 
  qbittorrent
 ## davinci-resolve //BROKEN ON WAYLAND
 ## Services
 ]; 


 # NIRI 
  programs.niri = {
    enable = true;
#    settings = {
#      binds = {
#        "Mod+Return".action.spawn = "kitty";
#	"Mod+Space".action.spawn = "hyprlauncher";
#	
#      };      
#
#    };
  };




  services.tailscale = {
    enable = true;
  };

}
# TEST MARKER Sun Jul 19 01:53:52 PM PDT 2026
