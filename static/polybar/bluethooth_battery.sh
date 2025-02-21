#!/usr/bin/env bash

found=0 

while IFS=' ' read -r _ address alias; do
  connected_status=$(bluetoothctl info "$address" | grep "Connected:" | awk '{print $2}')

  if [ "$connected_status" == "yes" ]; then
    found=1

    battery_percentage=$(bluetoothctl info "$address" | grep "Battery Percentage:" | grep -oP '\(\K[0-9]+')

    if [ "$battery_percentage" -le 0 ]; then
      echo "[     ] $battery_percentage"
    elif [ "$battery_percentage" -le 20 ]; then
      echo "[█    ] $battery_percentage"
    elif [ "$battery_percentage" -le 40 ]; then
      echo "[██   ] $battery_percentage"
    elif [ "$battery_percentage" -le 60 ]; then
      echo "[███  ] $battery_percentage"
    elif [ "$battery_percentage" -le 80 ]; then
      echo "[████ ] $battery_percentage"
    elif [ "$battery_percentage" -le 90 ]; then
      echo "[█████] $battery_percentage"
    fi

    exit 0 
  fi
done < <(bluetoothctl devices)

# TODO: не работает 
if [ "$found" -eq 0 ]; then
  echo "No devices"
  exit 1
fi
