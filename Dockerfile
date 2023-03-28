FROM openjdk:8

ADD target/docker-springboot-hello-0.0.1-SNAPSHOT.jar docker-springboot-hello-0.0.1-SNAPSHOT.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","docker-springboot-hello-0.0.1-SNAPSHOT.jar"]
