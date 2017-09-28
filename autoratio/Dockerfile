FROM node:8

LABEL fr.kyane.image="registry.kyane.fr:5000/autoratio"
MAINTAINER kyane@kyane.fr

## Get the code and install dependencies
RUN git clone https://github.com/pichouk/autoratio.git /autoratio \
    && cd /autoratio \
    && yarn install

WORKDIR /autoratio

ENTRYPOINT ["node", "index.js"]
