{
  programs.nixvim = {
    plugins.orgmode = {
      enable = true;
      settings = {
        org_agenda_files = "~/notes/**/*";
        org_default_notes_file = "~/notes/index.norg";
      };
    };
  };
}
