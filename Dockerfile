FROM hanzhukruslan/vault-helper:local as vault-helper
FROM openjdk:16-jdk-alpine
RUN apk add --no-cache jq
WORKDIR /app
COPY --from=vault-helper /app/vault /app/vault
COPY ./setuper/application.properties.ctmpl /app/config/application.properties.ctmpl
COPY ./setuper/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
COPY target/spring-flyway-outside-0.0.1-SNAPSHOT.jar /app/spring-flyway-outside-0.0.1-SNAPSHOT.jar
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["java","-jar", "spring-flyway-outside-0.0.1-SNAPSHOT.jar","--spring.config.location=/app/config/application.properties"]