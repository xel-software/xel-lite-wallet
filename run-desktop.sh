#!/bin/sh
if [ ! -f xel-lite-wallet.jar ]; then
    echo "ERROR : you need to compile the project using 'mvn package'"
    exit 1
fi

if [ -x jre/bin/java ]; then
    JAVA=./jre/bin/java
else
    JAVA=java
fi
${JAVA} -cp xel-lite-wallet.jar:conf -Dnxt.runtime.mode=desktop -Dnxt.runtime.dirProvider=nxt.env.DefaultDirProvider nxt.Nxt
