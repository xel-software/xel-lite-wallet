#!/bin/bash

OUTPUT_FILE="../bundles/$1.exe"
echo "generating '$OUTPUT_FILE' ..."

/usr/bin/python ../installer/lib/izpack2exe/izpack2exe.py --file $1-win.jar --output ../bundles/$1.exe --with-7z=../installer/lib/izpack2exe/7za-osx --no-upx --with-jdk=../jre-win --name xel > ../installer/build-exe.log 2>&1
#chmod +x ../bundles/$1.exe #fix for windows

if [ ! -e ${OUTPUT_FILE} ]
then
  echo "installer generation failed"
  exit 1
else
  echo "installer $OUTPUT_FILE generated"
fi
