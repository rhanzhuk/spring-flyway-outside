FROM openjdk:11
WORKDIR /app
#COPY flywayDB/ /app/flywayDB/
COPY target/spring-flyway-outside-0.0.1-SNAPSHOT.jar /app/spring-flyway-outside-0.0.1-SNAPSHOT.jar
ENTRYPOINT ["java","-jar", "spring-flyway-outside-0.0.1-SNAPSHOT.jar","--spring.config.location=/app/config/application.properties"]
#FROM registry.access.redhat.com/ubi8/openjdk-11:1.11
#ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en'
# We make four distinct layers so if there are application changes the library layers can be re-used
#COPY --chown=185 target/spring-flyway-outside-0.0.1-SNAPSHOT.jar /app/spring-flyway-outside-0.0.1-SNAPSHOT.jar
#EXPOSE 8080
#USER 185
#ENV AB_JOLOKIA_OFF=""
#ENV JAVA_OPTS="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager"
#ENV JAVA_APP_JAR="/app/spring-flyway-outside-0.0.1-SNAPSHOT.jar"