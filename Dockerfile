FROM python:slim

RUN pip3 install domain-connect-dyndns

COPY --chmod=0755 entrypoint.sh /run/entrypoint.sh

WORKDIR /config

ENTRYPOINT [ "/run/entrypoint.sh" ]