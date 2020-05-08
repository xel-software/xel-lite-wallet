#
# Source code
#
FROM alpine/git as sources

RUN git clone --depth 1 https://github.com/xel-software/xel-lite-wallet /code

#
# Maven build
#
FROM maven:3.6.3-openjdk-11 as build

COPY --from=sources /code/ /build/

RUN cd /build && mvn package

#
# Final image
#
FROM openjdk:11.0.7-jre-slim-buster

RUN mkdir /opt/app

COPY --from=build /build/xel-lite-wallet.jar /opt/app/xel-wallet.jar
COPY --from=sources /code/run.sh /opt/app/run.sh
COPY --from=sources /code/conf/ /opt/app/conf/
COPY --from=sources /code/html/ /opt/app/html/
COPY --from=sources /code/logs/ /opt/app/logs/

WORKDIR /opt/app

CMD java ${JAVA_OPTS} -cp xel-wallet.jar:conf nxt.Nxt
