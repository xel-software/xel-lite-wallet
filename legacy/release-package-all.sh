#!/bin/bash

VERSION=$1
if [ -x ${VERSION} ];
then
	echo VERSION not defined
	exit 1
fi

PACKAGE=elastic-client-${VERSION}
echo PACKAGE="${PACKAGE}"

CHANGELOG=${PACKAGE}.changelog.txt

MACVERSION=$2
if [ -x ${MACVERSION} ];
then
  MACVERSION=${VERSION}
fi
echo MACVERSION="${MACVERSION}"

echo "########################"
echo "# CLEANUP"
echo "########################"
rm -rf html/doc/*
rm -rf build
rm -rf ${PACKAGE}*
mkdir -p build/
mkdir -p build/logs
mkdir -p build/addons/src

echo "########################"
echo "# COPY RESSOURCES"
echo "########################"
cp installer/lib/JavaExe.exe build/elastic.exe
cp installer/lib/JavaExe.exe build/elasticservice.exe
cp -a logs/placeholder.txt build/logs

FILES="changelogs conf html lib resource contrib"
FILES="${FILES} 3RD-PARTY-LICENSES.txt AUTHORS.txt LICENSE.txt"
FILES="${FILES} DEVELOPERS-GUIDE.md OPERATORS-GUIDE.md README.md README.txt USERS-GUIDE.md"
FILES="${FILES} run.bat run.sh run-desktop.sh start.sh stop.sh compact.sh compact.bat sign.sh"
FILES="${FILES} elastic.policy elasticdesktop.policy Elastic_Wallet.url Dockerfile"
FILES="${FILES} classes src COPYING.txt"
FILES="${FILES} compile.sh javadoc.sh jar.sh package.sh"
FILES="${FILES} win-compile.sh win-javadoc.sh win-package.sh"

cp -a ${FILES} build

echo "ressources copied"

cd build

echo "########################"
echo "# COMPILE CLASSES"
echo "########################"
./compile.sh

echo "########################"
echo "# GENERATE JAVADOC"
echo "########################"
./javadoc.sh

echo "########################"
echo "# GZIP RESSOURCES"
echo "########################"
for f in `find html -name *.gz`
do
	rm -f "$f"
done
for f in `find html -name *.html -o -name *.js -o -name *.css -o -name *.json  -o -name *.ttf -o -name *.svg -o -name *.otf`
do
	gzip -9c "$f" > "$f".gz
done

echo "gzip done"

echo "########################"
echo "# GENERATE JAR FILE"
echo "########################"
## will create elastic.jar and elasticservice.jar
./jar.sh

if [ ! -e elastic.jar ] || [ ! -e elasticservice.jar ]
then
  echo "jar files generation failed"
  exit 1
fi

echo "########################"
echo "# PACKAGE INSTALLER OSX"
echo "########################"
## will create ${PACKAGE}.jar
../installer/build-installer.sh ${PACKAGE} mac

if [ ! -e "${PACKAGE}-mac.jar" ]
then
  echo "installer package failed"
  exit 1
fi

echo "########################"
echo "# PACKAGE INSTALLER"
echo "########################"
## will create ${PACKAGE}.jar
../installer/build-installer.sh ${PACKAGE} win

if [ ! -e "${PACKAGE}-win.jar" ]
then
  exit 1
fi

echo "########################"
echo "# CREATE INSTALLER .exe"
echo "########################"
## will create ${PACKAGE}.exe
../installer/build-exe-osx.sh ${PACKAGE}

if [ ! -e "../bundles/${PACKAGE}.exe" ]
then
  exit 1
fi

# echo "########################"
# echo "# CREATE INSTALLER .zip"
# echo "########################"
# echo create installer zip
# zip -q -X -r ${PACKAGE}.zip build -x \*/.idea/\* \*/.gitignore \*/.git/\* \*.iml build/conf/build.properties build/conf/logging.properties build/conf/localstorage/\*

echo "########################"
echo "# CREATE INSTALLER .dmg"
echo "########################"
## will create bundles/${PACKAGE}.dmg
../installer/build-dmg.sh ${PACKAGE} ${MACVERSION}

if [ ! -e "../bundles/${PACKAGE}.dmg" ]
then
  exit 1
fi

cd - > /dev/null
rm -rf build

echo "########################"
echo "# CREATE CHANGELOG ${CHANGELOG}"
echo "########################"
echo -e "Release $1\n" > ${CHANGELOG}
echo -e "https://github.com/xel-software/Litewallet-Mainnet/raw/master/releases/${PACKAGE}.exe\n" >> ${CHANGELOG}
echo -e "sha256:\n" >> ${CHANGELOG}
sha256sum bundles/${PACKAGE}.exe >> ${CHANGELOG}

echo -e "https://github.com/xel-software/Litewallet-Mainnet/raw/master/releases/${PACKAGE}.dmg\n" >> ${CHANGELOG}
echo -e "sha256:\n" >> ${CHANGELOG}
sha256sum bundles/${PACKAGE}.dmg >> ${CHANGELOG}

echo -e "\n\nChange log:\n" >> ${CHANGELOG}

cat changelogs/${CHANGELOG} >> ${CHANGELOG}
echo >> ${CHANGELOG}
