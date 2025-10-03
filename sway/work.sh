dir="$PWD/$1"

if [ -f "$1/CMakeLists.txt" ]; then
  rs_setup=$(find ~/nix/ -name "cc_setup*" -type f | tail -n 1)
  $rs_setup "$dir"
else
  if [ -f "$1/_quarto.yml" ]; then
    quarto_setup=$(find ~/nix/ -name "quarto_setup*" -type f | tail -n 1)
    $quarto_setup "$dir"
  else
    if [ -f "$1/Cargo.toml" ]; then
      rs_setup=$(find ~/nix/ -name "rs_setup*" -type f | tail -n 1)
      $rs_setup "$dir"
    else
      standart_setup=$(find ~/nix/ -name "standart_setup*" -type f | tail -n 1)
      $standart_setup "$dir"
    fi
  fi
fi
