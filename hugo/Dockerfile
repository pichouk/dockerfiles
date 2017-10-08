FROM alpine:3.6

# Hugo version
ARG HUGO_VERSION=0.29

### Install Hugo
RUN set -x \
  # Install dependencies
  && apk add --update wget ca-certificates \
  # Get Hugo binary
  && wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz -O hugo.tar.gz \
  && mkdir hugo_linux \
  && tar xzf hugo.tar.gz -C hugo_linux \
  && rm -r hugo.tar.gz \
  && mv hugo_linux/hugo /usr/bin/hugo \
  && rm -r hugo_linux \
  # Remove dependencies
  && apk del wget ca-certificates \
  && rm /var/cache/apk/* \
  # Create folder for the site content
  && mkdir /code

# Use website folder
WORKDIR /code

EXPOSE 1313

# Run Hugo
ENTRYPOINT ["/usr/bin/hugo"]
