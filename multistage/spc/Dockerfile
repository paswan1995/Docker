FROM alpine/git AS vcs 
RUN git clone https://github.com/spring-projects/spring-petclinic.git


FROM maven:3-amazoncorretto-17 AS builder 
COPY --from=vcs /git/spring-petclinic /spring-petclinic 
RUN cd spring-petclinic && mvn package 

FROM amazoncorretto:17-alpine-jdk       
LABEL author="anil"
ARG HOME_DIR=/spc
WORKDIR ${HOME_DIR}
COPY --from=builder spring-petclinic/target/spring-*.jar ${HOME_DIR}/spring-petclinic.jar
EXPOSE 8080
CMD [ "java", "-jar", "spring-petclinic.jar" ]


## or

FROM alpine/git AS vcs
RUN cd / && git clone https://github.com/spring-projects/spring-petclinic.git && \
    pwd && ls spring-petclinic

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
CMD ["java", "-jar", "spring-petclinic.jar"]


# or 

#Spring Petclinic

FROM maven:3.9.9-sapmachine-23 AS build
RUN git clone https://github.com/spring-projects/spring-petclinic.git
RUN cd spring-petclinic && mvn clean package 

# running the application
#FROM amazoncorretto:17-alpine-jdk
FROM amazoncorretto:17-alpine3.17-jdk

# add metadata for the information
LABEL author="anil"
LABEL project="spring-prtclinic"
RUN mkdir /spc && chown nobody /spc
USER nobody
COPY --from=build /spring-petclinic/target/spring-petclinic-3.3.0-SNAPSHOT.jar .
EXPOSE 8080
CMD [ "java", "-jar", "spring-petclinic-3.3.0-SNAPSHOT.jar" ]