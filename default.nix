{ pkgs ? import <nixpkgs> {} }:
 
let 
  jdk = pkgs.jdk8;
  androidsdk = pkgs.androidenv.androidsdk_6_0_extras;
  fhs = pkgs.buildFHSUserEnv {
    name = "android-env";
    targetPkgs = pkgs: with pkgs; [ 
      androidsdk
      bash
      ncurses
      nodejs
      git
      which
      jdk
      xterm
      watchman
    ];
    multiPkgs = pkgs: with pkgs; [
      gst_all_1.gst-plugins-ugly
      gst_all_1.gstreamer
      xlibs.libX11
      xlibs.libXcomposite
      xlibs.libXext
      xlibs.libXfixes
      xlibs.libXrandr
      xlibs.libXtst
      zlib 
    ];
    runScript = "bash";
    profile = ''
      export ANDROID_HOME="${androidsdk}/libexec/android-sdk-linux"
      export ANDROID_EMULATOR_FORCE_32BIT=true
      # Hack. To be removed when we get react-native-cli in
      # nodePackages
      export PATH="$PATH:${./node_modules}/.bin"
      export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ANDROID_HOME/tools/lib64
    '';
  };
in 
pkgs.stdenv.mkDerivation {
  name = "android-sdk-fhs-shell";
  nativeBuildInputs = [ fhs ];
  shellHook = "exec android-env";
}


