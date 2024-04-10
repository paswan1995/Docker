## Multi Stage Docker build
* multi staged is used to build the code and copy necessary files into the final stage which will be your image.
* hefer: https://docs.docker.com/build/building/multi-stage/
![preview](images/200.png)

## Scenario – 1: Java Spring petclinic

* To build this application we need
       * jdk17
       * maven
       * git 
* Manual steps:

```
git clone https://github.com/spring-projects/spring-petclinic.git
cd spring-petclinic 
mvn package
# a file gets created in target/spring-petclinic-*.jar
```
* To run this application we need jdk 17
* Refer Here for the changes done to create spring petclinic as multistage build
* __(1)__
![preview](images/201.png)
* above image show us `git` is not already not is not present and where is spc file present. So we have to check by using these commands `docker container run --entrypoint /bin/sh -it alpine/git`
* `pwd , ls `
![preview](images/202.png)
![preview](images/203.png)

```
FROM alpine/git AS vcs
RUN cd / && git clone https://github.com/spring-projects/spring-petclinic.git && \
    pwd && ls /spring-petclinic

FROM maven:3-amazoncorretto-17 AS builder
COPY --from=vcs /spring-petclinic /spring-petclinic
RUN ls /spring-petclinic 
RUN cd /spring-petclinic && mvn package



FROM amazoncorretto:17-alpine-jdk
LABEL author="anil"
EXPOSE 8080
ARG HOME_DIR=/spc
WORKDIR ${HOME_DIR}
COPY --from=builder /spring-petclinic/target/spring-*.jar ${HOME_DIR}/spring-petclinic.jar
EXPOSE 8080
CMD ["java", "-jar", "spring-petclinic.jar"]
```
* __(2)__ Nopcommerce app
  
```
FROM ubuntu:22.04 AS extractor
RUN apt update && apt install unzip
ARG DOWNLOAD_URL=https://github.com/nopSolutions/nopCommerce/releases/download/release-4.60.2/nopCommerce_4.60.2_NoSource_linux_x64.zip
ADD ${DOWNLOAD_URL} /nopCommerce/nopCommerce_4.60.2_NoSource_linux_x64.zip
RUN cd /nopCommerce && unzip nopCommerce_4.60.2_NoSource_linux_x64.zip && mkdir bin logs && rm nopCommerce_4.60.2_NoSource_linux_x64.zip


FROM mcr.microsoft.com/dotnet/sdk:7.0
LABEL author="khaja" organization="qt" project="learning"
ARG user=nopcommerce
ARG group=nopcommerce
ARG uid=1000
ARG gid=1000
ARG DOWNLOAD_URL=https://github.com/nopSolutions/nopCommerce/releases/download/release-4.60.2/nopCommerce_4.60.2_NoSource_linux_x64.zip
ARG HOME_DIR=/nop
RUN apt update && apt install unzip -y
# Create user nopcommerce
RUN groupadd -g ${gid} ${group} \
    && useradd -d "$HOME_DIR" -u ${uid} -g ${gid} -m -s /bin/bash ${user}
USER ${user}
WORKDIR ${HOME_DIR}
COPY --from=extractor  /nopCommerce ${HOME_DIR}
EXPOSE 5000
ENV ASPNETCORE_URLS="http://0.0.0.0:5000"
CMD [ "dotnet", "Nop.Web.dll"]
```
* ## Linux commands : https://www.sanfoundry.com/1000-linux-command-tutorials/ or 
* permission on linux : https://www.geeksforgeeks.org/permissions-in-linux/

* ## Scenario -2 Game of life
* code: https://github.com/wakaleo/game-of-life
* tools:
* jdk8
* git 
* maven 

* Refer Here for the solution ----given below Dockerfile
```
FROM alpine/git AS vcs
RUN cd / && git clone https://github.com/wakaleo/game-of-life.git

FROM maven:3-amazoncorretto-8 AS builder
COPY --from=vcs /game-of-life /game-of-life
RUN cd /game-of-life && mvn package

FROM tomcat:9-jdk8
LABEL author="khaja" organization="qt"
COPY --from=builder /game-of-life/gameoflife-web/target/*.war /usr/local/tomcat/webapps/gameoflife.war
EXPOSE 8080
```
![preview](images/204.png)

* __Pushing images to Registries__

* ## Docker Hub
* Public Registry: Docker Hub Refer Here: https://hub.docker.com/
* Create a public Repository
![preview](images)
* Repository will be in the form of <username>/<repo-name>:<tag>
![preview](images/205.png)
![preview](images/206.png)
* After building the image tag the image to new naming format
`docker image tag spc:1.0 redfiree/spcbuildmvn:1.0`
![preview](images/208.png)
* if this image has to be default also tag with latest (optional)
* `docker image tag spc:1.0 redfiree/spcbuildmvn:latest`
* ![preview](images)
* login into docker hub from cli
* `docker login`
* ![preview](images/210.png)
* lets push the images
  ![preview](images/216.png)
  ![preview](images/217.png)
* latest or specific tag 
  ![preview](images/211.png)
  ![preview](images/212.png)

* ## to pull the repository 
* `docker container run -d -P redfiree/spcbuildmvn`
![preview](images/215.png)

 ## deleting containers,images,volume and files
* vi alias.sh
```
#!/bin/bash
alias delcontainer=`docker container rm -f $(docker container ls -a -q)'
## use command `delcontainer` 
alias prunvol='docker volume prune'
## use command `prunvol`
alias delimages='docker image rm -f $(docker image ls -a -q)'
## use command `delimages`
```

* or use 
  
* vi deletecommands.sh
  
```
#!/bin/bash
docker container rm -f $(docker container ls -a -q)
docker image rm -f $(docker image ls -a -q)
docker volume prune
```
## Private Registries
* There are many applciations for hosting private registries
      * AWS: ECR (Elastic container registry)
      * Azure: ACR (Azure Container Registry)
      * Jfrog
  
* ## AWS ECR

* Create an ECR (Amazon Elastic Container Registry) Repository
![preview](images/213.png)
![preview](images/214.png)
* view push commands now
![preview](images/219.png)
![preview](images/220.png)
* now create aws (amazon linux 2 instance) and connect with your terminal and install `docker` for Amazon Linux 2
![preview](images/221.png)

```
sudo yum update -y
sudo amazon-linux-extras install docker
sudo service docker start
## Add the ec2-user to the docker group so that you can run Docker commands without using sudo
sudo usermod -a -G docker ec2-user
## after giving the permission of user you have logout once and relogin
docker info
docker ps

```
refer here for link : https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-docker.html
![preview](images/222.png) 

* install and configure aws cli
* before to configure aws cli we have to create `IAM ` user  
* refer: https://sst.dev/chapters/create-an-iam-user.html 
* to set or configure aws configure/set =  `cvi ~/.aws/credentails`
* to view your aws cerdentials type on terminal= notepad "C:\Users\Red Fire\Downloads\dockerhub-user_accessKeys.csv" 
  
![preview](images/223.png)
![preview](images/224.png)
![preview](images/225.png)
![preview](images/226.png)
![preview](images/227.png)
![preview](images/228.png)
![preview](images/229.png)
![preview](images/230.png)
![preview](images/231.png)
![preview](images/232.png)
![preview](images/233.png)
![preview](images/234.png)
![preview](images/235.png)
![preview](images/236.png)
* Last image of  prictical on terminal
![preview](images/223.png)
* finally we are able to push docker image from docker hub to ECR(Amazon Elastic Container Registry)
![preview](images/237.png)

* ## Azure ACR 
* Refer Here for detailed information: https://learn.microsoft.com/en-us/azure/container-instances/container-instances-tutorial-prepare-acr  
