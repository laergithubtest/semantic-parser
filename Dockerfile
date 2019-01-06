FROM openjdk:8-jdk
RUN apt-get update
RUN apt-get install -y maven
RUN apt-get install -y python3

RUN update-ca-certificates -f
RUN mkdir -p /etc/init
RUN wget -O - -o /dev/null http://get.takipi.com/takipi-t4c-installer | bash /dev/stdin -i --sk=S37421#92PtARsWflw9nOT4#7kMqw35uxBSgJqKAEQ7AKytbNXTkQDKDLEG9iauN8WY=#388f
RUN /opt/takipi/etc/takipi-setup-machine-name semantic-parser

ARG maven
RUN mkdir /root/.m2
RUN echo $maven > /root/.m2/settings.xml

# wait utility to hold script from starting until cleared by another service
WORKDIR /root
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.2.1/wait /wait
RUN chmod +x /wait

COPY . /root/semantic-parser
WORKDIR /root/semantic-parser

RUN mvn clean install -DskipTests
#CMD mvn clean install && /wait && python3 run.py server
