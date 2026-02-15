{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      bash-language-server
      fish-lsp
      inotify-tools
      just-lsp
      lua-language-server
      nil
      rust-analyzer
      ty
    ];
  };
}
