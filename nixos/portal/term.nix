self: super: {
  xdg-desktop-portal-termfilechooser = super.stdenv.mkDerivation {
    pname = "xdg-desktop-portal-termfilechooser";
    version = "2021-07-14";

    src = super.fetchFromGitHub {
      owner = "GermainZ";
      repo = "xdg-desktop-portal-termfilechooser";
      rev = "71dc7ab06751e51de392b9a7af2b50018e40e062";
      sha256 = "645hoLhQNncqfLKcYCgWLbSrTRUNELh6EAdgUVq3ypM=";
    };

    nativeBuildInputs = with super; [meson ninja pkg-config cmake scdoc inih];
    buildInputs = with super; [glib systemd];

    mesonFlags = ["-Dsd-bus-provider=libsystemd"];
  };
}
