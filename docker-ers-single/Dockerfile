FROM ubuntu:latest

#INTRO
COPY ./intro.txt /home/intro.txt
COPY ./run.sh /home/run.sh
RUN chmod +x /home/run.sh

# COPY evomaster.jar
RUN mkdir /home/Evomaster
RUN mkdir /home/Evomaster/result
COPY ./evomaster.jar /home/Evomaster

# COPY Restler binary file
RUN mkdir /home/Restler
RUN mkdir /home/Restler/restler_bin
RUN mkdir /home/Restler/demo_server
COPY ./restler_bin /home/Restler/restler_bin
COPY ./demo_server /home/Restler/demo_server
# COPY ./yourApiSpec.json /home/Restler

RUN apt update -y
RUN apt install vim -y
RUN apt install wget -y
RUN apt install openjdk-11-jdk -y
RUN apt install python3 -y
RUN apt install python3-pip -y
RUN apt install python3.10-venv -y
RUN apt-get install dotnet-sdk-6.0 -y
RUN apt-get install aspnetcore-runtime-6.0 -y

# Install schemathesis
RUN mkdir /home/schemathesis
RUN cd /home/schemathesis
RUN python3 -m pip install schemathesis
### Set alias
RUN echo "alias evomaster='java -jar /home/Evomaster/evomaster.jar'" >> ~/.bashrc
RUN echo "alias restler='/home/Restler/restler_bin/restler/Restler'" >> ~/.bashrc
RUN echo "alias intro='cat /home/intro.txt'" >> ~/.bashrc
RUN . ~/.bashrc

WORKDIR /home