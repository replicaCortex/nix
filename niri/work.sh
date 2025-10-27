dir="$PWD/$1"

if [ -f "$1/CMakeLists.txt" ]; then
  cpp_setup=$(find ~/nix/ -name "cpp_setup*" -type f | tail -n 1)
  $cpp_setup "$dir"
else
  if [ -f "$1/_quarto.yml" ]; then
    quarto_setup=$(find ~/nix/ -name "quarto_setup*" -type f | tail -n 1)
    $quarto_setup "$dir"
  else
    if [ -f "$1/Cargo.toml" ]; then
      rust_setup=$(find ~/nix/ -name "niri_rust_setup*" -type f | tail -n 1)
      $rust_setup "$dir"
    else
      standart_setup=$(find ~/nix/ -name "standart_setup*" -type f | tail -n 1)
      $standart_setup "$dir"
    fi
  fi
fi
