FROM openjdk:8

ADD target/javaexpress-springboot-docker.jar javaexpress-springboot-docker.jar

ADD src/main/resources/application.properties application.properties

EXPOSE 8080

ENTRYPOINT ["java","-jar","javaexpress-springboot-docker.jar"]
