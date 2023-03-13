FROM ubuntu:latest

COPY ./restler.sh /home/run.sh
RUN chmod +x /home/run.sh

# COPY Restler binary file
RUN mkdir /home/Restler
RUN mkdir /home/Restler/restler_bin
RUN mkdir /home/Restler/demo_server
COPY ./restler_bin /home/Restler/restler_bin
COPY ./demo_server /home/Restler/demo_server

RUN apt update -y
RUN apt install wget -y
RUN apt install python3 -y
RUN apt install python3.10-venv -y
RUN apt-get install dotnet-sdk-6.0 -y
RUN apt-get install aspnetcore-runtime-6.0 -y

RUN echo "alias restler='/home/Restler/restler_bin/restler/Restler'" >> ~/.bashrc
RUN . ~/.bashrc

WORKDIR /home