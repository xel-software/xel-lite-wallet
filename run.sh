#!/bin/sh
if [ ! -f xel-lite-wallet.jar ]; then
    echo "ERROR : you need to compile the project using 'mvn package'"
    exit 1
fi

cd "$(dirname "$0")"
if [ -x jre/bin/java ]; then
    JAVA=./jre/bin/java
else
    JAVA=java
fi
${JAVA} ${JAVA_OPTS} -cp xel-lite-wallet.jar:conf nxt.Nxt
