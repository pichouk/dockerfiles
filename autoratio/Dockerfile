FROM node:14-alpine

LABEL fr.kyane.image="registry.kyane.fr/autoratio"
LABEL maintainer="kyane@kyane.fr"

## Get the code and install dependencies
RUN apk add --no-cache --virtual .build-deps \
      git \ 
    && git clone https://framagit.org/pichouk/autoratio.git /autoratio \
    && cd /autoratio \
    && yarn install

WORKDIR /autoratio

ENTRYPOINT ["node", "index.js"]
