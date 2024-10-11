#!/usr/bin/env bash

set -o pipefail
set -o errexit
set -o nounset

if ! type fzf &> /dev/null; then
    echo "fzf is not installed" >&2
    exit 1
fi

keep_open=false
baseDir="$(dirname "$0")"
curDir=$(pwd)

usage () {
    echo "Usage: $(basename "$0") [OPTIONS...]"
    echo "  -k        --keep-open     Keep lnks open after selecting a bookmark"
    echo "  -d <dir>  --dir <dir>     Specify a directory where bookmarks files are stored"
    echo "  -e        --edit          Edit the bookmark file"
    echo "  -c        --create        Create the bookmark file if it does not exist"
    exit 0
}

edit () {
  vim "$curDir"/.bookmarks.txt
  exit 0
}

create(){
  if [[ ! -e "$curDir"/.bookmarks.txt ]]; then
    touch "$curDir"/.bookmarks.txt
  fi
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -k|--keep-open) keep_open=true ;;
        -d|--dir) dir="$2"; shift ;;
        -h|--help) usage ;;
        -e|--edit) edit ;;
        -c|--create) create ;;
        *) echo "Unknown parameter passed: $1" >&2; exit 1 ;;
    esac
    shift
done

if [[ -e "$curDir"/.bookmarks.txt ]]; then
  dir=$curDir
else
  dir=$baseDir
fi
if type explorer.exe &> /dev/null; then
  open_command="explorer.exe"
elif type open &> /dev/null; then
  open_command="open"
elif type xdg-open &> /dev/null; then
  open_command="xdg-open"
fi

enter_command="enter:execute-silent(${open_command} {-1})"

if [ "$keep_open" = true ]; then
  enter_command="${enter_command}+clear-query"
else
  enter_command="${enter_command}+abort"
fi

cat "$dir"/.bookmarks.txt | fzf \
  --border=rounded \
  --prompt="Search Bookmarks > " \
  --with-nth='1..-2' \
  --bind="${enter_command}" \
  --preview='echo {-1}' \
  --preview-window='up,1'
