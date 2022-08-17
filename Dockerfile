FROM adoptopenjdk/openjdk11:alpine-slim AS overlay

RUN apk --no-cache add curl
RUN mkdir -p ~/.gradle \
    && echo "org.gradle.daemon=false" >> ~/.gradle/gradle.properties \
    && echo "org.gradle.configureondemand=true" >> ~/.gradle/gradle.properties \
    && mkdir -p cas-overlay && cd cas-overlay \
    && curl https://casinit.herokuapp.com/starter.tgz -d "casVersion=6.3.4&bootVersion=2.6.3&dependencies=core,oauth,core-authentication-api,support-ldap-core,support-rest-authentication,support-qr-authentication" | tar -xzvf - \
    && chmod 750 ./gradlew \
    && ./gradlew --version;

RUN cd cas-overlay \
    && ./gradlew createKeystore clean build --parallel --no-daemon
