FROM postgres:alpine

ENV PAGER /pager/psql.sh
RUN apk update && apk add vim

COPY . /pager

ENTRYPOINT ["psql"]
