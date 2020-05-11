# Docker for raspberry pi

FROM hypriot/rpi-alpine-scratch:v3.4
RUN echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && apk add --update \
              musl \
              build-base \
              bash \
              git \
              python \
              python-dev \
              py-pip \
  && pip install --upgrade pip \
  && rm /var/cache/apk/*

RUN cd /usr/bin \
  && ln -sf easy_install-2.7 easy_install \
  && ln -sf python2.7 python \
  && ln -sf python2.7-config python-config \
  && ln -sf pip2.7 pip


ENV MODEL=diematic3
ENV USER=mqtt-user
ENV PASS=password
ENV SERVER=mqtt.server
ENV DEVID=10
ENV INTERVAL=5
ENV LOG=DEBUG
ENV SERIAL=/dev/ttyUSB

WORKDIR /app
COPY requirements.txt ./
#ADD requirements.txt requirements.txt
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY . .

RUN python ./setup.py build
RUN python ./setup.py install
CMD [ "/bin/bash", "-c", "poll_isystem_mqtt.py --user ${USER} --password ${PASS} --interval ${INTERVAL} --model ${MODEL} --deviceid ${DEVID} --log ${LOG} --serial ${SERIAL} ${SERVER} " ]
