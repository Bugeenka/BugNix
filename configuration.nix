{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/gaming.nix
      ./modules/streaming.nix
      ./modules/desktop.nix
      ./modules/gamedev.nix
    ];



  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.checkPhase = "";
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


#  GRUB DISABLED
#  boot.loader.grub.device = "nodev";
#  boot.loader.grub.efiSupport = true;
#  boot.loader.grub.useOSProber = true;
#  boot.loader.grub.extraEntries = ''
#    menuentry "Windows" {
#      insmod part_gpt
#      insmod fat
#      insmod chain
#      search --no-floppy --fs-uuid --set=root 1234-5678
#      chainloader /EFI/Microsoft/Boot/bootmgfw.efi
#}
#'';
#  boot.loader.grub.extraGrubInstallArgs = [ "--no-floppy" ];
 
 
  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Mount drives
  fileSystems."/mnt/thiccy" = {
    device = "/dev/disk/by-uuid/427E40AB527973B5";
    fsType = "ntfs";
    options = [ "uid=1000" "gid=1000" "rw" "users" "exec" "umask=003" "nofail" ];
};

  # KERNEL MODULES
  boot.kernelModules = [ "uinput" ];

  ## HOSTNAME
  networking.hostName = "NIXBUG";

  ## Networks
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  hardware = {

    bluetooth = {
      enable = true;
      powerOnBoot = true;
  };
};


  hardware = { 
    graphics.enable = true;
    graphics.enable32Bit = true;
    
};

  ## Time Zone.
  time.timeZone = "US/Pacific";



environment.systemPackages = with pkgs; [
  git
  os-prober
  vim
  blueman
  obs-studio
  obs-cmd
  steam
  scarlett2
  vesktop
  networkmanagerapplet
  flatpak
  unzip
  zip
  wine
  bottles
  wine
  winetricks
  bottles
  pulse-visualizer
  gvfs
  cifs-utils
  neovim
  deckmaster
  wev
  vscodium
  github-desktop
];


# SERVICES
  services = {
    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      alsa.support32Bit = true;
      
    };
    power-profiles-daemon.enable = true;
    upower.enable = true;
    flatpak.enable = true;
  
    gvfs.enable = true;
    tumbler.enable = true;    
    udisks2.enable = true;
    # UDEV PERMISSION RULES
    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0060", MODE:="666", GROUP="plugdev", SYMLINK+="streamdeck"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="006d", MODE:="666", GROUP="plugdev", SYMLINK+="streamdeck"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0080", MODE:="666", GROUP="plugdev", SYMLINK+="streamdeck"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0063", MODE:="666", GROUP="plugdev", SYMLINK+="streamdeck-mini"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="006c", MODE:="666", GROUP="plugdev", SYMLINK+="streamdeck-xl"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", MODE="0666", GROUP="plugdev", TAG+="uaccess"
      KERNEL=="hidraw*", ATTRS{idVendor}=="0fd9", MODE="0666", GROUP="plugdev", TAG+="uaccess"
      KERNEL=="uinput", MODE="0660", GROUP="input", TAG+="uaccess"

    '';
    

  };

# SYSTEMD STUFF
  systemd = {
    user.services = {
      deckmaster = {

        description = "Deckmaster Service";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.deckmaster}/bin/deckmaster --deck /home/deitabug/main.deck";
          Restart = "on-failure";
  };
	path = [ pkgs.obs-cmd ];
        environment = {
        DISPLAY = ":0";

    };


      };

    };

  };

# SECURITY
  security.rtkit.enable = true;
  security.polkit.enable = true;


# USERS

      users.users.DeitaBug = {
      isNormalUser = true;
      home = "/home/deitabug";
      extraGroups = [ "wheel" "video" "audio" "networkmanager" "input" "plugdev" ];
      packages = with pkgs; [
        tree
      ];
   };
# FIREFOX CONFIG
  programs.firefox.enable = true;
  
# HYPRLAND CONFIG  
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
 };
  programs.xfconf.enable = true;

 # SSH DAEMON
  services.openssh.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "start-hyprland";
          user = "DeitaBug";
                        };
               };
  };

  # DISABLES SDDM
  services.displayManager.sddm.enable = false;

  environment.pathsToLink = [ "/share/wayland-sessions" ];


# VERSION
  system.stateVersion = "26.05"; 
}

