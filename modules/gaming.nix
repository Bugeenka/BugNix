{ config, libs, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;



  environment.systemPackages = with pkgs; [


    lutris
    osu-lazer
    gamescope

  ];


  
  services.xserver.videoDrivers = [ "amdgpu" ];
#  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

}
