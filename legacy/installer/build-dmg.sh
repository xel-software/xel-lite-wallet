#!/bin/bash

PACKAGE=$1
MACVERSION=$2

OUTPUT_FILE="../bundles/$1.dmg"
echo "generating '$OUTPUT_FILE' ..."

JRE_HOME=""
if [ ! -x ${JAVA_HOME} ];
then
JRE_HOME="-Bruntime=\"${JAVA_HOME}\""
fi

javapackager -deploy -outdir ".." -outfile elastic-client -name "elastic-client" -width 34 -height 43 -native dmg -srcdir . -srcfiles ${PACKAGE}-mac.jar \
  -appclass com.izforge.izpack.installer.bootstrap.Installer -v -Bmac.category=Business -Bmac.CFBundleIdentifier=org.xel.client.installer \
  -Bmac.CFBundleName=Elastic-Installer -Bmac.CFBundleVersion=${MACVERSION} -BappVersion=${MACVERSION} -Bicon=../installer/AppIcon.icns ${JRE_HOME} > ../installer/build-dmg.log 2>&1

if [ ! -e "$OUTPUT_FILE" ]
then
  echo "installer dmg failed"
else
  echo "installer dmg generated"
fi
