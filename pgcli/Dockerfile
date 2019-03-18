FROM python:3.6-alpine

ENV PAGER /pager/pgcli.sh
RUN apk update && apk add --no-cache vim \
        python3-dev \
        postgresql-dev \
        musl-dev \
        gcc
RUN pip install --upgrade pip pgcli

COPY . /pager

ENTRYPOINT ["pgcli"]
