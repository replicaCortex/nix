{pkgs, ...}: {
  # programs.firefox = {
  #   enable = true;
  # };
  home.packages = with pkgs; [
    zotero
    qbittorrent-enhanced
    (callPackage ./zen.nix {})
  ];
}
