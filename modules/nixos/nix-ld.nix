{ pkgs, ... }:

{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # C / C++ runtime essentials
      stdenv.cc.cc.lib
      glibc
      glib
      zlib
      zstd
      bzip2
      xz
      lz4

      # Security / crypto
      openssl
      nss
      nspr
      libgcrypt
      libgpg-error

      # Graphics & display
      libGL
      libGLU
      mesa
      vulkan-loader
      libdrm
      libva
      libvdpau
      wayland
      wayland-protocols
      libx11
      libxext
      libxfixes
      libxi
      libxrender
      libxrandr
      libxcursor
      libxinerama
      libxcomposite
      libxdamage
      libxtst
      libxcb
      libxau
      libxdmcp
      libxkbcommon

      # Fonts & text rendering
      freetype
      fontconfig
      harfbuzz
      cairo
      pango

      # GTK / GNOME stack
      gtk2
      gtk3
      gtk4
      gdk-pixbuf
      atk
      at-spi2-atk
      at-spi2-core
      dbus
      dbus-glib

      # Qt stack
      qt5.qtbase
      qt5.qtwayland
      libsForQt5.qt5ct

      # Audio
      alsa-lib
      pipewire
      pulseaudio
      libpulseaudio

      # Multimedia / codec
      ffmpeg
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      libvorbis
      libogg
      libopus
      flac

      # Image formats
      libjpeg
      libpng
      libtiff
      libwebp
      giflib
      librsvg

      # Networking
      curl
      nghttp2
      libsoup_3
      krb5

      # System / hardware
      udev
      libusb1
      eudev
      libinput
      libevdev
      pciutils
      systemd

      # Input method / accessibility
      ibus
      ibus-engines.m17n
      fribidi

      # Compression / archive
      p7zip

      # Threading / IPC
      libuv
      libffi
      expat
      libbsd
      util-linux

      # Node.js / Electron dependencies
      cups

      # Python runtime
      python3

      # Misc runtime libs commonly needed
      libnotify
      libsecret
      libappindicator-gtk3
      SDL2
      SDL2_image
      SDL2_mixer
      SDL2_ttf
    ];
  };
}
