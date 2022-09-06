FROM adoptopenjdk/openjdk11:alpine-slim AS overlay

RUN apk --no-cache add curl
RUN mkdir -p ~/.gradle \
    && echo "org.gradle.daemon=false" >> ~/.gradle/gradle.properties \
    && echo "org.gradle.configureondemand=true" >> ~/.gradle/gradle.properties \
    && mkdir -p cas-overlay && cd cas-overlay \
    && curl https://casinit.herokuapp.com/starter.tgz -d "casVersion=6.3.4&bootVersion=2.3.7.RELEASE&dependencies=oauth,support-rest-authentication,support-qr-authentication,core,core-audit,core-audit-api,core-services,core-logout-api,core-web-api,core-services-registry,core-services-api,core-authentication-api,core-authentication-mfa,core-services-authentication,core-webflow,core-webflow-api,core-webflow-mfa,core-tickets-api,core-util-api,core-configuration-api,core-cookie-api,core-authentication,core-configuration-api,support-token-core-api,support-rest-tokens,support-otp-mfa-core,support-websockets,support-jdbc,support-pac4j,support-pac4j-api,support-pac4j-core,support-pac4j-core-clients,support-pac4j-authentication,support-pac4j-webflow,support-oauth-webflow,support-oauth,support-ldap-core,support-ldap,support-saml-idp,support-redis-core,support-jpa-service-registry,support-json-service-registry,support-rest,support-actions" | tar -xzvf - \
    && chmod 750 ./gradlew \
    && ./gradlew --version;

RUN cd cas-overlay \
    && ./gradlew createKeystore clean build --parallel --no-daemon
