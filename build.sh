#! /usr/bin/env bash

if [[ $# -ne 2 ]]
then
  echo "Incorrect number of arguments"
  echo ""
  echo "Usage: ./build.sh <resolution> <scaling>"
  echo "Example: ./build.sh 1920x1080 1.1"
  echo ""
  echo "<scaling> values recommended:"
  echo "  <1   - for older low-dpi displays"
  echo "   1   - for standard definition display"
  echo "   1.5 - for something in between like 2k laptop monitor"
  echo "   2   - for hidpi displays"
  exit 1
fi

resolution_w=$(echo $1 | cut -f1 -dx)
resolution_h=$(echo $1 | cut -f2 -dx)
scaling=$2

THEME_NAME="WinLin Dualboot Grub Menu"
THEME_COMPLIANT_NAME="win-lin-dualboot-grub-menu"
TEMPLATE_W=2350
TEMPLATE_H=1020
TEMPLATE_STD_DPI_INITIAL_SCALING=0.25
MARGIN_BETWEEN_TEMPLATE_AND_LABEL_INITIAL=40

FONT_SIZE=16
TERMINAL_FONT_SIZE=14
if [[ $(echo "$scaling >= 1.25" | bc) -eq 1 ]]
then
  FONT_SIZE=20
  TERMINAL_FONT_SIZE=18
fi
if [[ $(echo "$scaling >= 2" | bc) -eq 1 ]]
then
  FONT_SIZE=36
  TERMINAL_FONT_SIZE=30
fi

theme_dir_name="$THEME_NAME"\ "$resolution_w"x"$resolution_h"-"$scaling"x
build_dir=./build/"$theme_dir_name"
theme_dir=$build_dir/$THEME_COMPLIANT_NAME
icons_dir=$theme_dir/icons

mkdir -p "$build_dir"
mkdir -p "$theme_dir"
mkdir -p "$icons_dir"

template_recommended_size_w=$(echo "$TEMPLATE_W * $scaling * $TEMPLATE_STD_DPI_INITIAL_SCALING" | bc)
template_recommended_size_h=$(echo "$TEMPLATE_H * $scaling * $TEMPLATE_STD_DPI_INITIAL_SCALING" | bc)
template_final_size_w=$template_recommended_size_w
template_final_size_h=$template_recommended_size_h

template_max_size_w=$(echo "$resolution_w * 0.8" | bc)
template_max_size_h=$(echo "$resolution_h * 0.8" | bc)
if [[ $(echo "$template_final_size_w > $template_max_size_w" | bc) -eq 1 ]]
then
  template_final_size_w=$template_max_size_w
  template_final_size_h=$(echo "$template_max_size_w * $TEMPLATE_H / $TEMPLATE_W" | bc)
fi
if [[ $(echo "$template_final_size_h > $template_max_size_h" | bc) -eq 1 ]]
then
  template_final_size_w=$(echo "$template_max_size_h * $TEMPLATE_W / $TEMPLATE_H" | bc)
  template_final_size_h=$template_max_size_h
fi

template_final_size_w=${template_final_size_w%.*}
template_final_size_h=${template_final_size_h%.*}

font_offset=$(echo "(($resolution_h / 2) - 10) / 1" | bc)

label_offset=$(echo "-($resolution_w - 10) / 1" | bc)

grub-mkfont -s "$FONT_SIZE" -c "$font_offset" -d "-$font_offset" -n "Label" -o "$theme_dir/label-$FONT_SIZE.pf2" "./src/fonts/cousine/Cousine Regular.ttf"
grub-mkfont -s "$FONT_SIZE" -o "$theme_dir/cousine-$FONT_SIZE.pf2" "./src/fonts/cousine/Cousine Regular.ttf"
grub-mkfont -s "$TERMINAL_FONT_SIZE" -o "$theme_dir/terminus-$TERMINAL_FONT_SIZE.pf2" "./src/fonts/terminus/TerminusTTF.ttf"

CONVERT_PARAMS="-resize "$template_final_size_w"x"$template_final_size_h" -background black -gravity center -extent "$resolution_w"x"$resolution_h""

convert "./src/image_templates/background.png" $CONVERT_PARAMS "$theme_dir/background.png"
convert "./src/image_templates/linux.png" $CONVERT_PARAMS "$icons_dir/gnu-linux.png"
convert "./src/image_templates/linux advanced.png" $CONVERT_PARAMS "$icons_dir/gnu-linux-adv.png"
convert "./src/image_templates/windows.png" $CONVERT_PARAMS "$icons_dir/windows.png"
convert "./src/image_templates/efi.png" $CONVERT_PARAMS "$icons_dir/efi.png"
convert "./src/image_templates/power.png" $CONVERT_PARAMS "$icons_dir/shutdown.png"
convert "./src/image_templates/power.png" $CONVERT_PARAMS "$icons_dir/restart.png"

TMPL_WIDTH=$resolution_w
TMPL_HEIGHT=$resolution_h
TMPL_FONT_SIZE=$FONT_SIZE
TMPL_TERMINAL_FONT_SIZE=$TERMINAL_FONT_SIZE
TMPL_LABEL_OFFSET=$label_offset
export TMPL_WIDTH TMPL_HEIGHT TMPL_FONT_SIZE TMPL_LABEL_OFFSET TMPL_TERMINAL_FONT_SIZE
cat ./src/theme.txt.tmpl | envsubst > "$theme_dir/theme.txt"

TMPL_THEME_DIR_NAME=$THEME_COMPLIANT_NAME
TMPL_RESOLUTION="$resolution_w"x"$resolution_h"
export TMPL_THEME_DIR_NAME TMPL_RESOLUTION
cat ./src/install.sh.tmpl | envsubst '$TMPL_THEME_DIR_NAME,$TMPL_RESOLUTION' > "$build_dir/install.sh"
chmod +x "$build_dir/install.sh"

cp "./COPYRIGHT" "$build_dir"/COPYRIGHT
cp "./LICENSE" "$build_dir"/LICENSE

cd build
if [[ -f "$theme_dir_name".zip ]]
then
  rm "$theme_dir_name".zip
fi
zip -rq "$theme_dir_name".zip "$theme_dir_name"
