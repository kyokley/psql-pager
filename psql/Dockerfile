FROM postgres:alpine

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ENV PAGER /pager/psql.sh
RUN apk update && apk add --no-cachce vim

COPY . /pager

ENTRYPOINT ["psql"]
