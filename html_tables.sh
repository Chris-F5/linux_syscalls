#!/bin/bash

awk '
  BEGIN {
    FS = ":"
    print "<table>"
    print "<table>"
    print "  <tr>"
    print "    <th>syscall</th>"
    print "    <th>rax</th>"
    print "    <th>rdi</th>"
    print "    <th>rsi</th>"
    print "    <th>rdx</th>"
    print "    <th>r10</th>"
    print "    <th>r8</th>"
    print "    <th>r9</th>"
    print "  </tr>"
  }
  {
    print "  <tr>"
    printf "    <td>%s</td>\n", $1
    printf "    <td>%s</td>\n", $2
    printf "    <td>%s</td>\n", $3
    printf "    <td>%s</td>\n", $4
    printf "    <td>%s</td>\n", $5
    printf "    <td>%s</td>\n", $6
    printf "    <td>%s</td>\n", $7
    printf "    <td>%s</td>\n", $8
  }
  END {
    print "</table>"
  }
' table > table_x86-64.html
