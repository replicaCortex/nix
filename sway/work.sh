dir="$PWD/$1"

if [ -f "$1/CMakeLists.txt" ]; then
  cc_setup=$(find ~/nix/ -name "cc_setup*" -type f | tail -n 1)

  $cc_setup "$dir"
else
  if [ -f "$1/_quarto.yml" ]; then
    quarto_setup=$(find ~/nix/ -name "quarto_setup*" -type f | tail -n 1)

    $quarto_setup "$dir"
  else
    quarto_setup=$(find ~/nix/ -name "standart_setup*" -type f | tail -n 1)
    $quarto_setup "$dir"
  fi
fi
