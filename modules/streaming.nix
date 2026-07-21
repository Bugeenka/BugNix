{ config, lib, pkgs, ... }:


{
  nixpkgs.config.allowUnfree = true;

environment.systemPackages = with pkgs; [
  (pkgs.wrapOBS {
    plugins = with pkgs.obs-studio-plugins; [
      obs-aitum-multistream
      obs-vertical-canvas
      obs-pipewire-audio-capture
      waveform
      obs-scale-to-sound
      obs-vaapi
    ];
  })
  obs-cmd
];
}
