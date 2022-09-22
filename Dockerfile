########## STABLE VERSION ###########
FROM hanzhukruslan/openjdk16-vault:helper
WORKDIR /app
COPY ./setuper/application.properties.ctmpl /app/config/application.properties.ctmpl
COPY ./setuper/entrypoint.sh /app/entrypoint.sh
#RUN chmod +x /app/entrypoint.sh
COPY target/spring-flyway-outside-0.0.1-SNAPSHOT.jar /app/spring-flyway-outside-0.0.1-SNAPSHOT.jar
ENTRYPOINT ["/bin/sh", "-c" , "/app/entrypoint.sh"]
CMD ["java","-jar", "spring-flyway-outside-0.0.1-SNAPSHOT.jar","--spring.config.location=/app/config/application.properties"]