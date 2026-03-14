{ pkgs, ... }:
{

  environment = {
    systemPackages = with pkgs; [
      any-nix-shell
      aria2
      bat
      batsignal
      broot
      btop
      cliphist
      ddgr
      direnv
      fd
      feh
      file
      fzf
      gallery-dl
      gammastep
      gitMinimal
      imagemagick
      jq
      just
      lsd
      moreutils
      neovim
      nh
      pandoc
      qwen-code
      rip2
      ripgrep
      sqlite
      taskwarrior-tui
      taskwarrior3
      typst
      wl-clipboard
      xcp
      yt-dlp
      zk
    ];
  };
}
