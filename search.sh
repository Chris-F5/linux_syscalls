#!/bin/bash

linux=./linux
syscall_table=$linux/arch/x86/entry/syscalls/syscall_64.tbl

git clone $linux_repo $linux

find $linux -type f -name "*.c" \
  | xargs awk '
    /^SYSCALL_DEFINE/ { i = 1 }
    i { printf "%s", $0 }
    i == 1 && /)/ {i = 0 ; printf "\n" }' \
  | sed -e "s/SYSCALL_DEFINE.(//g" -e "s/)$//g" \
  | awk '
    BEGIN {FS = ""}
    {
      x = 0
      for (i = 1; i < NF; i = i + 1)
        if ($i == "," && x == 0) {
          x = 1
          printf ":"
        } else if ($i == "," && x == 1) {
          x = 0
          printf " "
        } else {
          printf $i
        }
      printf "\n"
    }' \
  | sed -r "s/\s+/ /g" \
  | sed "s/: /:/g" \
  | sort -t: -k1b,1 > syscall_definitions

awk '/^#/ || /^$/ { next } { printf "%s %s\n", $1, $3 }' $syscall_table \
  | sed -r "s/\s+/:/g" \
  | sort -t: -k2b,2 > syscall_table

join -t : -1 2 -2 1 syscall_table syscall_definitions \
  | sort -n -t: -k2,2 \
  | uniq > table
