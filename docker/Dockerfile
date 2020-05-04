#
# Source code
#
FROM alpine/git as sources

RUN git clone --depth 1 https://github.com/xel-software/xel-lite-wallet /code

#
# Maven build
#
FROM maven:3.6.3-adoptopenjdk-11 as build

COPY --from=sources /code/ /build/

RUN cd /build && mvn package

#
# Final image
#
FROM adoptopenjdk:11-jre-openj9-bionic
RUN mkdir /opt/app

COPY --from=build /build/xel-lite-wallet.jar /opt/app/xel-lite-wallet.jar
COPY --from=sources /code/docker/start-lite-wallet.sh /opt/app/start-lite-wallet.sh
COPY --from=sources /code/run.sh /opt/app/run.sh
COPY --from=sources /code/conf/ /opt/app/conf/
COPY --from=sources /code/html/ /opt/app/html/
COPY --from=sources /code/logs/ /opt/app/logs/

WORKDIR /opt/app
ENTRYPOINT bash start-lite-wallet.sh
