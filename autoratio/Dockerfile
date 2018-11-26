FROM node:9-alpine

LABEL fr.kyane.image="registry.kyane.fr/autoratio"
LABEL maintainer="kyane@kyane.fr"

## Get the code and install dependencies
RUN apk add --no-cache --virtual .build-deps \
      git \ 
    && git clone https://github.com/pichouk/autoratio.git /autoratio \
    && cd /autoratio \
    && yarn install

WORKDIR /autoratio

ENTRYPOINT ["node", "index.js"]
