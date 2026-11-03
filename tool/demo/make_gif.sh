#!/usr/bin/env bash
# Encode rendered frames into the README GIF (+ an MP4 alongside).
#   tool/demo/make_gif.sh <frames_dir> <out.gif> [width]
set -euo pipefail
frames=$1; out=$2; width=${3:-720}; fps=15
filters="fps=$fps,scale=$width:-1:flags=lanczos"
ffmpeg -loglevel error -y -framerate 20 -i "$frames/f_%04d.png" \
  -vf "$filters,split[a][b];[a]palettegen=max_colors=160:stats_mode=diff[p];[b][p]paletteuse=dither=bayer:bayer_scale=4:diff_mode=rectangle" \
  -loop 0 "$out"
ffmpeg -loglevel error -y -framerate 20 -i "$frames/f_%04d.png" \
  -vf "scale=1280:-2:flags=lanczos" -c:v libx264 -pix_fmt yuv420p -crf 20 \
  -movflags +faststart "${out%.gif}.mp4"
ls -lh "$out" "${out%.gif}.mp4"
