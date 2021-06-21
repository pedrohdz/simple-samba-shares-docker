FROM alpine:3.14.0

ARG SMBD_DEBUG_LEVEL=0

# For the LABEL schema: http://label-schema.org/rc1/
LABEL \
    org.label-schema.description="Very simple Samba file sharing" \
    org.label-schema.name="simple-samba-shares" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://pedrohdz.com/"

COPY ./files/bootstrap/ /opt/bootstrap/
RUN \
      apk add --no-cache \
        make=4.3-r0 \
        samba-common-tools=4.12.9-r0 \
        samba-server=4.12.9-r0 \
        shadow=4.8.1-r0 \
      && chmod -v 0700 /opt/bootstrap/secrets \
      && chmod -v 0600 /opt/bootstrap/secrets/users.conf \
      && make -C /opt/bootstrap/

EXPOSE 8139/tcp 8445/tcp
VOLUME \
    "/opt/bootstrap/build" \
    "/opt/bootstrap/secrets" \
    "/opt/samba/conf/include" \
    "/opt/samba/runtime"

CMD [ \
    "smbd", \
    "--debuglevel=${SMBD_DEBUG_LEVEL}", \
    "--configfile=/opt/samba/conf/smb.conf", \
    "--foreground", \
    "--log-stdout", \
    "--no-process-group" \
]
