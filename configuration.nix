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


  #NIX SETTINGS
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.checkPhase = "";
  nixpkgs.config.allowUnsupportedSystem = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # KERNEL   
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "uinput" ];
  boot.initrd.kernelModules = [ "amdgpu" ];

  # STORAGE DRIVES
  fileSystems."/mnt/thiccy" = {
    device = "/dev/disk/by-uuid/427E40AB527973B5";
    fsType = "ntfs";
    options = [ "uid=1000" "gid=1000" "rw" "users" "exec" "umask=003" "nofail" ];
};

  ## HOSTNAME
  networking.hostName = "NIXBUG";

  ## Networks
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  networking.firewall.allowedTCPPorts = [ 16262 ];
  networking.firewall.allowedUDPPorts = [ 49983 39539
   ];
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];
  hardware = {

    bluetooth = {
      enable = true;
      powerOnBoot = true;
  };
};

# GPU STUFF
  hardware = { 
    graphics.enable = true;
    graphics.enable32Bit = true;
    amdgpu = {
      overdrive.enable = false;

  };
};

  ## PERIPHERALS
  hardware.openrazer.enable = true;
  hardware.openrazer.users = [ "DeitaBug" ];
 
  
  ## Time Zone.
  time.timeZone = "US/Pacific";

  ## VM STUFF
  virtualisation.libvirtd = {
    enable =true;
    qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
  };
  
  programs.virt-manager.enable = true;
  networking.firewall.trustedInterfaces = [ "virbr0" ];  

  
environment.systemPackages = with pkgs; [
  git
  os-prober
  vim
  wget
  blueman
  steam
  scarlett2
  pavucontrol
  dnsmasq
  alsa-scarlett-gui
  vesktop
  networkmanagerapplet
  # flatpak
  unzip
  zip
  wine
  bottles
  wine
  winetricks
  bottles
  qemu
  virt-manager
  pulse-visualizer
  gvfs
  cifs-utils
  neovim
  deckmaster
  wev
  vscodium
  github-desktop
  remmina
  jq
  openrazer-daemon
  razergenie
];


# SERVICES
  services = {
    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      alsa.support32Bit = true;
      wireplumber.enable = true;
      
    };
    power-profiles-daemon.enable = true;
    upower.enable = true;
    # flatpak.enable = true;
  
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
  security.pam.loginLimits = [
  
   {
      domain = "DeitaBug";
      type = "-";
      item = "nice";
      value = "-10";

   }
];

# USERS

      users.users.DeitaBug = {
      isNormalUser = true;
      home = "/home/deitabug";
      extraGroups = [ "tty" "wheel" "video" "audio" "networkmanager" "input" "plugdev" "render" "libvirtd" ];
      packages = with pkgs; [
        tree
      ];
   };

#  programs.niri.settings.binds = {
#    "Mod+Return".action.spawn = "kitty";
#    "Mod+Space".action.spawn = "hyprlauncher";
#  };




# FIREFOX CONFIG
  programs.firefox.enable = true;
  

  programs.xfconf.enable = true;

 # SSH DAEMON
  services.openssh.enable = true;

 # GREETD
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "niri-session";
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

