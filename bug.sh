#!/usr/bin/env bash

function echoBold () { echo -e "\033[1m$1\033[0m"; }

echoBold "Current Timestamps of a file in the local OS Tree"

stat os-tree/somefile

echoBold "Executing systemd-repart with hooked mkfs.ext4"

SOURCE_DATE_EPOCH=0 PATH=$(realpath hook):$PATH systemd-repart \
    --dry-run no \
    --size auto \
    --seed 0867da16-f251-457d-a9e8-c31f9a3c220b \
    --definitions repart.d \
    --json pretty \
    --empty create \
    --sector-size 512 \
    --copy-source os-tree \
    image.raw

echoBold "Removing the raw disk image"

rm image.raw
