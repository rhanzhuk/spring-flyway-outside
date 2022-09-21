#FROM openjdk:11
#WORKDIR /app
#COPY flywayDB/ /app/flywayDB/
#COPY target/spring-flyway-outside-0.0.1-SNAPSHOT.jar /app/spring-flyway-outside-0.0.1-SNAPSHOT.jar
#ENTRYPOINT ["java","-jar", "spring-flyway-outside-0.0.1-SNAPSHOT.jar","--spring.config.location=/app/config/application.properties"]
FROM hanzhukruslan/vault-helper:local as vault-helper
#FROM openjdk:11
FROM openjdk:16-jdk-alpine
# TEST jq and later install from vault-helper
RUN apk add --no-cache jq
WORKDIR /app
COPY --from=vault-helper /app/vault /app/vault
COPY --from=vault-helper /app/envconsul /app/envconsul
COPY ./setuper/application.properties.ctmpl /app/config/application.properties.ctmpl
COPY ./setuper/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
COPY target/spring-flyway-outside-0.0.1-SNAPSHOT.jar /app/spring-flyway-outside-0.0.1-SNAPSHOT.jar
ENTRYPOINT ["/app/entrypoint.sh"]
#CMD ["sleep", "10m"]
CMD ["java","-jar", "spring-flyway-outside-0.0.1-SNAPSHOT.jar","--spring.config.location=/app/config/application.properties"]