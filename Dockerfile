FROM lambdaexpression/autocut:latest

MAINTAINER lambdaexpression <lambdaexpression@163.com>

WORKDIR /script
ADD script /script
RUN chmod +x *.sh

RUN apt -y install nginx spawn-fcgi

ENV auto_file_update_time_gt=600 file_extensions="mp4,mkv,mov"
VOLUME ["/autocut/video/auto", "/autocut/video/out", "/root/.cache"]
CMD /script/start.sh &;/bin/sh
