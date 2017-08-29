#!/bin/sh

download_big_file() {
  FILEID=$1
  FILENAME=$2
  CONFIRM=$(curl -c c.f -fL "https://drive.google.com/uc?id=${FILEID}&export=download" | grep -o 'confirm=\(.\{4,4\}\)' | sed 's/confirm=\(\)/\1/')
  echo {$CONFIRM}
  curl -b c.f -fLo ${FILENAME} "https://drive.google.com/uc?id=${FILEID}&export=download&confirm=${CONFIRM}"
  # clear cookies 
  rm c.f
}

download_file() {
  FILEID=$1
  FILENAME=$2
  curl -fLo ${FILENAME} "https://drive.google.com/uc?id=${FILEID}&export=download"
}
