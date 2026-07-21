{ config, pkgs, libs, ... }:


{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];


  environment.systemPackages = with pkgs; [
  
    libresprite 
    pince
    (unityhub.override {
      extraLibs = fhsPkgs: [
        fhsPkgs.openssl_1_1
      ];
    })
  ];



}
