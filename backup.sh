#!/bin/bash
echo "\"$0\" is running:";
tar cfvj bak_files_$(date +"%Y%m%d%H%M%S").tar.bz2 $(find $1 -type f -mtime -1)
