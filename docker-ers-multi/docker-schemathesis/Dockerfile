FROM ubuntu:latest

COPY ./schemathesis.sh /home/run.sh
RUN chmod +x /home/run.sh

RUN apt update -y
RUN apt install python3 -y
RUN apt install python3-pip -y
RUN mkdir /home/schemathesis
RUN cd /home/schemathesis
RUN python3 -m pip install schemathesis

WORKDIR /home