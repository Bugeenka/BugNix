  {config, pkgs, lib, inputs, ...}:
  {
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
];

#USER CONFIG
  home = {
  username = "DeitaBug"; 
  homeDirectory = "/home/deitabug";
  stateVersion  = "26.05";
 	 };

#BASH CONFIG
  programs.bash = {
  enable = true;
  shellAliases = {
    nrs = "sudo nixos-rebuild switch";
    nrsf = "sudo nixos-rebuild switch --flake /etc/nixos/#NIXBUG";
    hyprbackup = "sudo cp ~/.config/hypr/hyprland.lua ~/.config/hypr/hyprlandBACKUP.lua";
    };
  initExtra = ''
    fastfetch
    export PS1='\[\e[38;5;129m\]\@\[\e[0m\] \[\e[38;5;46m\]\u\[\e[0m\] in \[\e[38;5;129m\]\w\[\e[0m\] \[\e[38;5;118m\]\\$\[\e[0m\]'
  '';
  };






  programs.vicinae = {
    enable = true;
    systemd.enable = true;

  };

#HYPR CONFIG
wayland.windowManager.hyprland = {
  systemd.enable = false;
  settings = {
    decoration = {
      shadow_offset = "0 5";
      "col.shadow" = "rgba(00000099)";
    };

    "$mod" = "SUPER";

    bind = [
      "$mod, SHIFT, W, exec, pkill waybar && waybar"

      "$mod, Spacebar, exec, hyprlauncher"

      "$mod, Return, exec, kitty"
    ];

    # Startup Apps
    exec-once = [
     
    ];

    bindm = [
      # mouse movements
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
      "$mod ALT, mouse:272, resizewindow"
    ];
  };
};



#SPICETIFY CONFIG
  programs.spicetify = 
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in {
      enable = true;
      enabledCustomApps = with spicePkgs.apps; [
	marketplace
      ];
      enabledExtensions = with spicePkgs.extensions; [
        adblock
        shuffle
      ];
      theme = {
        name = "marketplace";
	src = pkgs.writeTextDir "marketplace/user.css" "";
        injectCss = false;
        injectThemeJs = false;
        replaceColors = false;
        sidebarConfig = false;
        homeConfig = false;
        overwriteAssets = false;
  };
};


#FASTFETCH CONFIG
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "/home/deitabug/Images/shon.png";
	type = "kitty";
        width = 25;
	color = {
	  "1" = "#c6ff1c";
	  "2" = "#731cff";
        };
	padding = {
	  right = 1;
      };
    };

	display = {
	  size = {
	    binaryPrefix = "si";
      };
	  color = "green";
	  separator = "  ";
    };
	modules = [
	  "title"
	  "separator"
	  "os"
	  "host"
	  "kernel"
	  "uptime"
	  "packages"
	  "cpu"
	  "gpu"
	  "memory"
	  "break"
	
    ];
  };

};

# WAYBAR CONFIG
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
	position = "top";
	height = 30;
#	output = ;
        modules-right = [ "pulseaudio" "clock" "network" "power-profiles-daemon" "cpu" "memory" "tray" ];
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];

	"hyprland/workspaces" = {
	  format = "{icon}";
	  on-scroll-up = "hyprctl dispatch workspace e+1";
	  on-scroll-down = "hyprctl dispatch workspace e-1";
      };

	"clock" = {
	  format = "{:%H:%M}";
	  tooltip-format = "{:%A, %B %d, %Y}";
      }; 

	"network" = {
	  format-ethernet = "{ipaddr}";
	  format-disconnected = "DISCONNECTED";
      };

	"pulseaudio" = {
	  format = "{volume}% {icon}";
	  format-muted = "MUTED";
	  format-icons = { default = [ "" "" "" ]; };
	  on-click = "pavucontrol";
      };
    };
  };

      style = ''
    * {
      font-family: "JetBrains Mono", FontAwesome, sans-serif;
      font-size: 13px;
    }

    window#waybar {
      background-color: rgba(85, 0, 125, 0.9);
      color: #b6ff47;
      border-bottom: 1px solid #b6ff47;
    }

    #workspaces button {
      padding: 0 5px;
      color: #87b543;
    }

    #workspaces button.active {
      color: #b6ff47;
      font-weight: bold;
    }

    #clock, #battery, #network, #pulseaudio {
      padding: 0 10px;
      color: #cbff7d;
    }
    #network {
      color: #cbff7d;
    }

    #pulseaudio {
      color: #cbff7d;
    }
  '';

};

#BROKEN HYPRPAPER CONFIG. HYPRPAPER IS ASS
#  home.file.".config/hypr/hyprpaper.conf".text = ''
#  preload = /home/deitabug/Wallpapers/Neo-Purple-Dark.png
#  wallpaper = /home/deitabug/Wallpapers/Neo-Purple-Dark.png

#'';

#  programs.hyprpaper = {
#    enable = true;
#    settings = {
#      preload = [
#      "/home/deitabug/Wallpapers/Neo-Purple-Dark.png"
#    ];
#    wallpaper = {
#      monitor = "";
#      path = "/home/deitabug/Wallpaper/Neo-Purple-Dark.png";

#  };

#  };
    
#};

#HYPRLOCK CONFIG
  programs.hyprlock = {
    enable = true;
    settings = {
      general.hide_cursor = true;
      general.ignore_empty_input = true;
      general.fail_timeout = 200;
      animations = {
	enabled = true;
	fade_in = {
	  duration = 300;
	  bezier = "easeOutQuint";
    };
  };
      background = [
	{
	  path = "screenshot";
	  blur_passes = 3;
	  blur_size = 8;
    }
  ];
      input-field = [
        {
        size = "200, 50";
	position = "0, 20";
	monitor = "";
	dots_center = true;
	fade_on_empty = true;
	font_color = "rgb(216, 255, 74)";
	inner_color = "rgb(63, 0, 145)";
	outer_color = "rgb(216, 255, 74)";
	outline_thickness = 6;
	placeholder_text = ":3";
	shadow_passes = 1;
	rounding = 0;
      }
    ];
  };
};

#SWAYING WRAPPER CONFIG
  home.file.".local/share/applications/swayimg.desktop".text = ''
  [Desktop Entry]
  Type=Application
  Name=Swayimg
  GenericName=Image viewer
  Comment=Image viewer for Wayland
  Icon=swayimg
  Exec=swayimg %F
  Terminal=false
  Categories=Graphics;Viewer
  StartupNotify=false
  MimeType=image/avif;image/bmp;image/gif;image/heif;image/jpeg;image/jpg;image/jxl;image/pbm;image/pjpeg;image/png;image/svg+xml;image/tiff;image/webp;image/x-bmp;image/x-exr;image/x-png;image/x-portable-anymap;image/x-portable-bitmap;image/x-portable-graymap;image/x-portable-pixmap;image/x-targa;image/x-tga
'';

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/avif"                 = [ "swayimg.desktop" ];
      "image/bmp"                  = [ "swayimg.desktop" ];
      "image/gif"                  = [ "swayimg.desktop" ];
      "image/heif"                 = [ "swayimg.desktop" ];
      "image/jpeg"                 = [ "swayimg.desktop" ];
      "image/jpg"                  = [ "swayimg.desktop" ];
      "image/jxl"                  = [ "swayimg.desktop" ];
      "image/png"                  = [ "swayimg.desktop" ];
      "image/svg+xml"              = [ "swayimg.desktop" ];
      "image/tiff"                 = [ "swayimg.desktop" ];
      "image/webp"                 = [ "swayimg.desktop" ];
      "image/x-bmp"                = [ "swayimg.desktop" ];
      "image/x-png"                = [ "swayimg.desktop" ];
      "image/x-portable-pixmap"    = [ "swayimg.desktop" ];
      "image/x-tga"                = [ "swayimg.desktop" ];
      "inode/directory"            = [ "org.gnome.Nautilus.desktop" ];
  };
};
# USER LEVEL PACKAGES
  home.packages = with pkgs; [
    bat
    desktop-file-utils
    swayimg
    nerd-fonts.mononoki
    fastfetch
    awww
    wl-clipboard
    steam
    thunderbird
    vaultwarden
    godot
    vlc
    blender
    gimp
    audacity
    chatterino2
    hyprlock

];

}


