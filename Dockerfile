FROM ubuntu:latest
MAINTAINER Florian Loedermann <floedermann@gmail.com>

#SOS Jobscheduler download URL
ENV SOS_JS_URL https://download.sos-berlin.com/JobScheduler.1.10/jobscheduler_linux-x64.1.10.1.tar.gz

#prepare apt environment
RUN apt-get update && apt-get upgrade && apt-get install -y \
    wget \
    software-properties-common

#install jdk8
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    apt-get install -y \
     oracle-java8-installer \
     libmysql-java

#cleanup apt stuff
RUN rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/*

#download and install scheduler
RUN wget $SOS_JS_URL -O /root/jobscheduler.tar.gz
RUN mkdir /root/install && tar xzvf /root/jobscheduler.tar.gz -C /root/install --strip-components=1
COPY scheduler_install.xml /root/install/scheduler_install.xml

#prepare jdk environment
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

COPY startup_scheduler.sh /opt/startup_scheduler.sh

#expose scheduler ports
EXPOSE 40444 48444 4444

#start wrapper script
CMD chmod +x /opt/startup_scheduler.sh
CMD ["bash","/opt/startup_scheduler.sh"]
