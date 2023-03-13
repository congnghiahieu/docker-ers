FROM ubuntu:latest

COPY ./evomaster.sh /home/run.sh
RUN chmod +x /home/run.sh

RUN mkdir /home/Evomaster
COPY ./evomaster.jar /home/Evomaster

RUN apt update -y
RUN apt install openjdk-11-jdk -y

RUN echo "alias evomaster='java -jar /home/Evomaster/evomaster.jar'" >> ~/.bashrc
RUN . ~/.bashrc

WORKDIR /home