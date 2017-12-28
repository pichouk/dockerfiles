FROM python:alpine3.6

MAINTAINER kyane@kyane.fr

ENV PYTHONUNBUFFERED 1

# Install dependencies
RUN apk add --no-cache \
      gcc \
      gettext \
      openssl-dev \
      libsasl \
      git \
      musl-dev \
      libxslt-dev \
    && rm -rf /var/lib/apt/lists/*

# Install mytube
RUN git clone https://framagit.org/pichouk/mytube.git /code \
  && cd /code \
  && pip install --upgrade pip \
  && pip install -r requirements.txt

WORKDIR /code

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
