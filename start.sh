#!/bin/sh
if [ ! -f xel-lite-wallet.jar ]; then
    echo "ERROR : you need to compile the project using 'mvn package'"
    exit 1
fi

if [ -e ~/.elastic/elastic.pid ]; then
    PID=`cat ~/.elastic/elastic.pid`
    ps -p $PID > /dev/null
    STATUS=$?
    if [ $STATUS -eq 0 ]; then
        echo "Elastic server already running"
        exit 1
    fi
fi
mkdir -p ~/.elastic/
DIR=`dirname "$0"`
cd "${DIR}"
if [ -x jre/bin/java ]; then
    JAVA=./jre/bin/java
else
    JAVA=java
fi
echo "About to start elastic in the background, call stop.sh to stop it again"
nohup ${JAVA} -cp xel-lite-wallet.jar:conf -Dnxt.runtime.mode=desktop org.xel.Nxt > /dev/null 2>&1 &

echo $! > ~/.elastic/elastic.pid
cd - > /dev/null
