#!/bin/bash

#
# Copyright (c) 2017 Arrow Electronics, Inc.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License 2.0
# which accompanies this distribution, and is available at
# http://apache.org/licenses/LICENSE-2.0
# Contributors: Arrow Electronics, Inc.
#

CHECK_CRT="-k"

download_big_file() {
  FILEID=$1
  FILENAME=$2
  CONFIRM=$(curl ${CHECK_CRT} -c c.f -fL "https://drive.google.com/uc?id=${FILEID}&export=download" | grep -o 'confirm=\(.\{4,4\}\)' | sed 's/confirm=\(\)/\1/')
  echo {$CONFIRM} || return 1
  curl ${CHECK_CRT} -b c.f -fLo ${FILENAME} "https://drive.google.com/uc?id=${FILEID}&export=download&confirm=${CONFIRM}" || return 1
  # clear cookies 
  rm c.f
}

download_file() {
  FILEID=$1
  FILENAME=$2
  curl ${CHECK_CRT} -fLo ${FILENAME} "https://drive.google.com/uc?id=${FILEID}&export=download" || return 1
}
