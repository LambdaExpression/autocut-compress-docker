FROM lambdaexpression/autocut:latest

MAINTAINER lambdaexpression <lambdaexpression@163.com>

WORKDIR /script
ADD script /script
RUN chmod +x *.sh

RUN apt -y install spawn-fcgi

RUN mkdir -p /autocut/video/auto
RUN mkdir -p /autocut/video/out
RUN mkdir -p /autocut/log

ENV auto_file_update_time_gt=60 file_extensions="mp4,mkv,mov" whisper_model="small"
VOLUME ["/autocut/video/auto", "/autocut/video/out", "/autocut/log", "/root/.cache"]

CMD /script/start.sh;/bin/sh
