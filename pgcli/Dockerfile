FROM postgres:alpine

ENV PAGER /pager/pgcli.sh
RUN apk update && apk add vim

COPY . /pager

ENTRYPOINT ["psql"]
