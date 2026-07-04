# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
#     <home-manager/nixos>
      ./modules/gaming.nix
      ./modules/streaming.nix
      ./modules/desktop.nix
      ./modules/gamedev.nix
    ];

## Home Manager
#  home-manager.useUserPackages = true;
#  home-manager.useGlobalPkgs = true;
#  home-manager.backupFileExtension = "backup";
#  home-manager.users.DeitaBug = import ./home.nix;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.checkPhase = "";
  
  boot.loader.systemd-boot.enable = true;
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
  boot.loader.efi.canTouchEfiVariables = true;



  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

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

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

environment.systemPackages = with pkgs; [
 #home-manager
  foot
  git
  kitty
  os-prober
  hyprlock
  waybar
  dunst
  hyprpaper
  vim
  hyprlauncher
  wl-clipboard
  blueman
#  kdePackages.dolphin
  kdePackages.kio
  kdePackages.kio-extras
  kdePackages.kde-cli-tools
  kdePackages.kservice
  kdePackages.ark
  obs-studio
  obs-cmd
  steam
  mission-center
  scarlett2
  grim
  slurp
  wofi
  vesktop
  networkmanagerapplet
  hyprsysteminfo
#  swayimg
  flatpak
  unzip
  zip
  wine
  bottles
  xfce.thunar
  thunar-volman
  thunar-archive-plugin
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
];
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
    
#    hyprpaper = {
#      enable = true;
#      settings = {
#        preload = [
#          "~/Wallpapers/Neo-Purple-Dark.png"
#		  ];
#
#	wallpaper = {
#	  monitor = "";
#	  path = "~/Wallpapers/Neo-Purple-Dark.png";
#};
#};
#};
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






  security.rtkit.enable = true;
  security.polkit.enable = true;
  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

      users.users.DeitaBug = {
      isNormalUser = true;
      home = "/home/deitabug";
      extraGroups = [ "wheel" "video" "audio" "networkmanager" "input" "plugdev" ];
      initialPassword = "isopod";
      packages = with pkgs; [
        tree
      ];
   };

  programs.firefox.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
 };
  programs.xfconf.enable = true;

#  programs = {
#    firefox = {
#      enable = true;
#              };
#    hyprland = {
#      enable = true;
  #    xwayland.enable = true;
  #             };
 #          };
#
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
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
  services.displayManager.sddm.enable = false;

  environment.pathsToLink = [ "/share/wayland-sessions" ];
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}

