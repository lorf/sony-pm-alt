FROM python:2.7-alpine

LABEL org.opencontainers.image.source=https://github.com/lorf/sony-pm-alt

RUN apk add --no-cache gphoto2 exiftool
RUN pip install --no-cache requests

WORKDIR /root

EXPOSE 15740/tcp
EXPOSE 15740/udp
EXPOSE 1900/udp

ENV PTP_GUID="ff:ff:52:54:00:b6:fd:a9:ff:ff:52:3c:28:07:a9:3a"

ENV PUID=1000
ENV PGID=1000

ENV GPHOTO_ARGS=--get-all-files,--skip-existing
ENV SAVE_TO_DATE_FOLDERS=false

ENV DEBUG=false

ADD make_gphoto_settings.sh .
ADD gphoto_connect_test.sh .

RUN chmod +x make_gphoto_settings.sh
RUN chmod +x gphoto_connect_test.sh

ADD sony-pm-alt.py .

RUN chmod +x sony-pm-alt.py

VOLUME /var/lib/Sony

CMD /root/make_gphoto_settings.sh && exec python sony-pm-alt.py
