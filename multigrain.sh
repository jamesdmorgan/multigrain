#!/usr/bin/env bash
set -euo pipefail

lowpass=${LOWPASS:-16000}
hipass=${HIPASS:-30}
norm=${NORM:-"f=100:g=15"}
noise=${NOISE:-"nf=-25"}

filter="highpass=f=${hipass},dynaudnorm=${norm},afftdn=${noise},lowpass=f=${lowpass}"

function log() {
    local msg=$1
    case $2 in
        yellow) code=226;;
        red)    code=196;;
        green)  code=118;;
        orange) code=214;;
        blue)   code=39;;
        *)      code=231;;  # white
    esac
    echo -ne "\033[38;5;${code}m$msg\033[0m\n"
}

function y_n_prompt() {
    local msg=$1
    read -r -p "$msg (y)es (n)o (e)xit > " answer
    case ${answer:0:1} in
        y|Y) return 0 ;;
        e|E) log "Exiting... goodbye" red; exit 0 ;;
        *)   return 1 ;;
    esac
}

function ensure_ffmpeg_installed() {
    if ! command -v ffmpeg >/dev/null 2>&1; then
        log "ffmpeg not found. Attempting to install..." orange
        if [[ "$OSTYPE" == "darwin"* ]]; then
            if command -v brew >/dev/null 2>&1; then
                y_n_prompt "Install ffmpeg using Homebrew?" && brew install ffmpeg
            else
                log "Homebrew not found. Please install ffmpeg manually." red
                exit 1
            fi
        elif [[ -f /etc/debian_version ]]; then
            y_n_prompt "Install ffmpeg using apt?" && sudo apt update && sudo apt install -y ffmpeg
        elif [[ -f /etc/redhat-release ]]; then
            y_n_prompt "Install ffmpeg using yum?" && sudo yum install -y epel-release && sudo yum install -y ffmpeg
        else
            log "Unsupported system. Please install ffmpeg manually." red
            exit 1
        fi
    fi
}

ensure_ffmpeg_installed

mkdir -p source

log "Processing WAV files in: $(pwd)" yellow
log "Filter: ${filter}" yellow

shopt -s nocaseglob
for file in *.wav; do
    [[ -e "$file" ]] || continue

    cp "$file" source/

    # Clean and sanitize file name
    clean_name=$(echo "$file" \
        | sed -E 's/ *\([Bb]ounce[^)]*\)//g' \
        | sed -E 's/ *\[[^]]*\]//g' \
        | sed -E 's/ +/ /g' \
        | sed -E 's/^ +| +$//g' \
        | sed -E 's/ /-/g' \
        | sed -E 's/\.wav$/.wav/I')

    log "Cleaning ${file} -> $clean_name" white

    # If input and output names are the same, use a temp then move
    out_file="$clean_name"
    if [[ "$file" == "$clean_name" ]]; then
        out_file="${file%.wav}_processed.wav"
    fi

    log "Processing $clean_name and trimming to 32s" white
    ffmpeg -hide_banner -loglevel error -y \
        -i "$file" \
        -filter:a "$filter" \
        -c:a pcm_s16le \
        -t 32 \
        "$out_file"

    [[ "$out_file" != "$clean_name" ]] && mv "$out_file" "$clean_name"
    rm "$file"
done

log "Complete - originals in ./source, processed files renamed and cleaned" green
