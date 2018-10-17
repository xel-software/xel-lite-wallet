#!/bin/sh
OS_SPECIFIC=""
if [ ! -x ${2} ];
then
OS_SPECIFIC="-${2}"
fi

OUTPUT_FILE="$1${OS_SPECIFIC}.jar"

echo "generating $OUTPUT_FILE..."

java -Xmx512m -cp "../installer/lib/*" com.izforge.izpack.compiler.bootstrap.CompilerLauncher ../installer/setup${OS_SPECIFIC}.xml -o ${OUTPUT_FILE} > ../installer/build-installer.log 2>&1

if [ ! -e ${OUTPUT_FILE} ]
then
  echo "installer generation failed"
  exit 1
else
  echo "installer $OUTPUT_FILE generated"
fi
