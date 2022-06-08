FROM openjdk:11
WORKDIR /app
#COPY flywayDB/ /app/flywayDB/
COPY target/spring-flyway-outside-0.0.1-SNAPSHOT.jar /app/spring-flyway-outside-0.0.1-SNAPSHOT.jar
ENTRYPOINT ["java","-jar", "spring-flyway-outside-0.0.1-SNAPSHOT.jar"]