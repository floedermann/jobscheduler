FROM java:8
MAINTAINER Florian Loedermann <floedermann@gmail.com>

#SOS Jobscheduler download URL
ENV SOS_JS_URL https://download.sos-berlin.com/JobScheduler.1.10/jobscheduler_linux-x64.1.10.5.tar.gz

#download and install scheduler
RUN curl -o /root/jobscheduler.tar.gz $SOS_JS_URL
RUN mkdir /root/install && tar xzvf /root/jobscheduler.tar.gz -C /root/install --strip-components=1
COPY scheduler_install.xml /root/install/scheduler_install.xml

COPY startup_scheduler.sh /opt/startup_scheduler.sh

#expose scheduler ports
EXPOSE 40444 48444 4444

#start wrapper script
CMD chmod +x /opt/startup_scheduler.sh
CMD ["bash","/opt/startup_scheduler.sh"]
