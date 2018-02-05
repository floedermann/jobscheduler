# SOS Jobscheduler

Dockerfile for Jobschedulerserver www.sos-berlin.com


# General

* Ports:
  * 4446 (Webinterface, username/password: root/root)
  * 40444 (Agents)
* you can either use mysql or mariadb
* mysql environment will be used in startup script

# Example

docker-compose.yml

```
jobscheduler:
  image: floedermann/jobscheduler
  links:
    - db:mysql
  volumes_from:
    - datastore
  ports:
    - "4446:4446"
    - "40444:40444"

db:
  image: mariadb
  environment:
    MYSQL_USER: jobscheduler
    MYSQL_PASSWORD: jobscheduler
    MYSQL_ROOT_PASSWORD: scheduler
    MYSQL_DATABASE: jobscheduler

datastore:
   image: busybox
   command: /bin/true
   volumes:
     - /opt/jobscheduler/data/scheduler/config/live

```
