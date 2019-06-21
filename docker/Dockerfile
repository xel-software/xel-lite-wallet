FROM maven:3-jdk-13-alpine
ENV DEBIAN_FRONTEND noninteractive
ENV ELASTIC_DIR=/xel-lite-wallet

RUN apk add dos2unix git

RUN git clone --depth 1 https://github.com/xel-software/xel-lite-wallet ${ELASTIC_DIR}
RUN cd ${ELASTIC_DIR} && mvn package

COPY start-lite-wallet.sh ${ELASTIC_DIR}/start-lite-wallet.sh
RUN dos2unix ${ELASTIC_DIR}/start-lite-wallet.sh

WORKDIR ${ELASTIC_DIR}
ENTRYPOINT sh start-lite-wallet.sh
