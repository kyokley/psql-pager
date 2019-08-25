FROM python:3.7-alpine

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ENV PAGER /pager/pgcli.sh
RUN apk update && apk add --no-cache vim \
        python3-dev \
        postgresql-dev \
        musl-dev \
        gcc

RUN pip install --upgrade pip pgcli

COPY . /pager

ENTRYPOINT ["pgcli"]
