#!/bin/sh
FN="$HOME"/.cache/lf-dir.log
$TERMINAL -e lf -last-dir-path "$FN" 
cat "$FN" 
