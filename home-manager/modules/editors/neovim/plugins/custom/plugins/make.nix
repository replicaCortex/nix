{
  programs.nixvim = {
    autoCmd = [
      {
        event = ["BufEnter"];
        pattern = ["*.py"];
        callback.__raw = ''
          set makeprg=python\ %
        '';
      }
    ];
  };
}
