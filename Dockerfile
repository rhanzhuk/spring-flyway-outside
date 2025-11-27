########## STABLE VERSION ###########
FROM eclipse-temurin:11-jdk
#FROM openjdk:11
#FROM gcr.io/distroless/java:11
WORKDIR /app
COPY target/spring-flyway-outside-0.0.1-SNAPSHOT.jar /app/spring-flyway-outside-0.0.1-SNAPSHOT.jar
CMD ["java","-jar", "spring-flyway-outside-0.0.1-SNAPSHOT.jar","--spring.config.location=/app/config/application.properties"]
#FROM hanzhukruslan/openjdk16-vault:helper
#WORKDIR /app
#COPY ./setuper/application.properties.ctmpl /app/config/application.properties.ctmpl
#COPY ./setuper/entrypoint.sh /app/entrypoint.sh
#RUN chmod +x /app/entrypoint.sh
#COPY target/spring-flyway-outside-0.0.1-SNAPSHOT.jar /app/spring-flyway-outside-0.0.1-SNAPSHOT.jar
#ENTRYPOINT ["/app/entrypoint.sh"]
#CMD ["java","-jar", "spring-flyway-outside-0.0.1-SNAPSHOT.jar","--spring.config.location=/app/config/application.properties"]