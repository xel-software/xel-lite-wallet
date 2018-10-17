#!/bin/bash

## FIRST PREPARATION (ONLY DONE ONCE)
## ==================================
##
## 1. Install Windows
## 2. Install JAva JDK 1.8 from Sun and make sure that JDK bin/ directory is in PATH (usually it is not)
## 3. Install Git for Windows
## 4. Install TortoiseGIT
## 5. Install Cygwin with at least "zip", "unzip", "dos2unix" and the "python2" and "python2-pip" packages. All selectable in the cygwin setup, if you cant find them make sure to set the View from "Pending" to "Not Installed"!
## 6. Get a cup of coffee and enjoy your 5 minute break
## 7. Checkout the Litewallet
## 8. Create a folder called "jre-win" in the Litewallet-Mainnet/ root folder. Also create a "jre-mac" folder which will remain empty.
## 9. Download 64bit JRE 1.8 from Sun in .tar.gz format (for Windows: jre-8u131-windows-x64.tar.gz) and unzip the content of jre1.8.0_181\ into the jre-win/ folder you just created. In a way that you
##
## DO NOT HAVE:
## jre-win\jre1.8.0_181\bin or jre-win\jre1.8.0_181\lib
## BUT INSTEAD YOU HAVE
## jre-win\bin\ or jre-win\lib\
##
## REPEATED STEP FOR EVERY NEW VERSION
## ===================================
## 1. In Cygwin, run "./win-release-package.sh 3.1.3" when 3.1.3 is the current version number


VERSION=$1
if [ -x ${VERSION} ];
then
	echo VERSION not defined
	exit 1
fi
PACKAGE=elastic-client-${VERSION}
echo PACKAGE="${PACKAGE}"
CHANGELOG=elastic-client-${VERSION}.changelog.txt
OBFUSCATE=$2

FILES="changelogs conf html lib resource contrib logs"
FILES="${FILES} elastic.exe elasticservice.exe"
FILES="${FILES} 3RD-PARTY-LICENSES.txt AUTHORS.txt LICENSE.txt"
FILES="${FILES} DEVELOPERS-GUIDE.md OPERATORS-GUIDE.md README.md README.txt USERS-GUIDE.md"
FILES="${FILES} run.bat run.sh run-desktop.sh start.sh stop.sh compact.sh compact.bat sign.sh"
FILES="${FILES} elastic.policy elasticdesktop.policy Elastic_Wallet.url Dockerfile"

# unix2dos *.bat
echo compile
./win-compile.sh
rm -rf html/doc/*
rm -rf build
rm -rf ${PACKAGE}.jar
rm -rf ${PACKAGE}.exe
rm -rf ${PACKAGE}.zip
mkdir -p build/
mkdir -p build/logs
mkdir -p build/addons/src

if [ "${OBFUSCATE}" == "obfuscate" ];
then
echo obfuscate
proguard.bat @build.pro
mv ../build.map ../build.map.${VERSION}
mkdir -p build/src/
else
FILES="${FILES} classes src COPYING.txt"
FILES="${FILES} compile.sh javadoc.sh jar.sh package.sh"
FILES="${FILES} win-compile.sh win-javadoc.sh win-package.sh"
echo javadoc
./win-javadoc.sh
fi
echo copy resources
cp installer/lib/JavaExe.exe elastic.exe
cp installer/lib/JavaExe.exe elasticservice.exe
cp -a ${FILES} build
cp -a logs/placeholder.txt build/logs
echo gzip
for f in `find build/html -name *.gz`
do
	rm -f "$f"
done
for f in `find build/html -name *.html -o -name *.js -o -name *.css -o -name *.json  -o -name *.ttf -o -name *.svg -o -name *.otf`
do
	gzip -9c "$f" > "$f".gz
done
cd build
echo generate jar files
../win-jar.sh
echo package installer Jar
../installer/build-installer.sh ../${PACKAGE}
echo create installer exe
../installer/build-exe.sh ${PACKAGE}
echo create installer zip
cd -
zip -q -X -r ${PACKAGE}.zip build -x \*/.idea/\* \*/.gitignore \*/.git/\* \*.iml build/conf/build.properties build/conf/logging.properties build/conf/localstorage/\*
rm -rf build

echo creating change log ${CHANGELOG}
echo -e "Release $1\n" > ${CHANGELOG}
echo -e "https://github.com/xel-software/Litewallet-Mainnet/raw/master/releases/${PACKAGE}.exe\n" >> ${CHANGELOG}
echo -e "sha256:\n" >> ${CHANGELOG}
sha256sum ${PACKAGE}.exe >> ${CHANGELOG}

echo -e "https://github.com/xel-software/Litewallet-Mainnet/raw/master/releases/${PACKAGE}.jar\n" >> ${CHANGELOG}
echo -e "sha256:\n" >> ${CHANGELOG}
sha256sum ${PACKAGE}.jar >> ${CHANGELOG}

if [ "${OBFUSCATE}" == "obfuscate" ];
then
echo -e "\n\nThis is an experimental release for testing only. Source code is not provided." >> ${CHANGELOG}
fi
echo -e "\n\nChange log:\n" >> ${CHANGELOG}

cat changelogs/${CHANGELOG} >> ${CHANGELOG}
echo >> ${CHANGELOG}
