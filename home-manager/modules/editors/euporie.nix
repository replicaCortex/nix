{
  pkgs,
  euporiePkg,
  ...
}: let
in let
  pythonEuporie = pkgs.python312.withPackages (ps: [
    ps.aiohttp
    euporiePkg
  ]);
in {
  home.packages = [
    pythonEuporie
  ];

  home.file."/.config/euporie/config.json".text = ''
    {
      "notebook": {
        "graphics": "kitty",
        "color_scheme": "default",
        "edit_mode": "vi",
        "enable_language_servers": true,
        "autoformat": true,
        "autocomplete": true,
        "line_numbers": true
      },
      "notebook": {
        "graphics": "kitty",
        "color_scheme": "default",
        "edit_mode": "vi",
        "enable_language_servers": true,
        "autoformat": true,
        "autocomplete": true,
        "line_numbers": true
      }
    }
  '';
}
