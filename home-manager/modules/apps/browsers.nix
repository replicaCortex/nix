{pkgs, ...}: {
  programs.firefox = {
    enable = true;
  };
  home.packages = with pkgs; [
    zotero
    qbittorrent-enhanced
  ];
}
