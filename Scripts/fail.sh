#!/bin/sh
echo $0 $*
set -e
echo "Going to kill the parent process now, then exit with code 1. 'Cuz that's all I do. "
kill $PPID
exit 1
