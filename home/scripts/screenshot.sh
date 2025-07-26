#!/usr/bin/env bash

dir="$HOME/Pictures/Screenshots"
time=$(date +'%Y_%m_%d_at_%Hh%Mm%Ss')
file="${dir}/Screenshot_${time}.png"

copy() {
  grimblast --notify --freeze copy area
}

save() {
  grimblast --notify --freeze save area "$file"
}

swappy_() {
  grimblast --notify --freeze save area "$file"
  swappy -f "$file"
}

md() {
  grim -g "$(slurp)" - | tesseract - - | wl-copy
}

if [[ ! -d "$dir" ]]; then
  mkdir -p "$dir"
fi

if [[ "$1" == "--copy" ]]; then
  copy
elif [[ "$1" == "--save" ]]; then
  save
elif [[ "$1" == "--swappy" ]]; then
  swappy_
elif [[ "$1" == "--md-copy" ]]; then
  md
else
  echo -e "Available Options: --copy --save --swappy --md-copy"
fi

exit 0
