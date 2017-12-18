FROM node:9-alpine

MAINTAINER kyane@kyane.fr

# Get code
RUN git clone https://framagit.org/pichouk/kaamelottapi.git /code
WORKDIR /code

# Install dependencies
RUN yarn install --production

EXPOSE 3000

ENTRYPOINT ["node", "server.js"]
