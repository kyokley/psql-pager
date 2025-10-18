FROM python:3.13-alpine AS pgcli

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

ENV PAGER=/pager/pgcli.sh
RUN apk update && apk add --no-cache vim \
        python3-dev \
        postgresql-dev \
        musl-dev \
        gcc

RUN pip install --upgrade pip uv

WORKDIR /workspace
COPY ./pyproject.toml ./uv.lock /workspace/
RUN uv sync --no-install-project

COPY ./common.vim /root/config/common.vim
COPY ./pgcli /pager

ENTRYPOINT ["uv", "run", "pgcli"]

FROM postgres:alpine AS psql

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

ENV PAGER=/pager/psql.sh
RUN apk update && apk add --no-cache vim

COPY ./common.vim /root/config/common.vim
COPY ./psql /pager

WORKDIR /workspace

ENTRYPOINT ["psql"]
