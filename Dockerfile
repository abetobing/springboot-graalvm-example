# https://github.com/graalvm/container/pkgs/container/graalvm-ce image
# Builder
#FROM ghcr.io/graalvm/jdk:ol7-java17-22.3.1
FROM ghcr.io/graalvm/graalvm-ce:22.3.1

ADD . /build
WORKDIR /build

RUN \
    # Install SDKMAN
    curl -s "https://get.sdkman.io" | bash; \
    source "$HOME/.sdkman/bin/sdkman-init.sh"; \
    sdk install maven; \
    # Install GraalVM Native Image
    gu install -y native-image;

RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && \
    cd /build && \
    mvn -B clean package -Pnative -DskipTests --no-transfer-progress

#RUN ls -al /build/target/
#RUN ./mvnw -B clean package -Pnative -DskipTests --no-transfer-progress


# Runner
FROM alpine:3.17.1

MAINTAINER Abe Tobing

# Add Spring Boot Native app springboot-graalvm-example to Container
COPY --from=0 "/build/target/springboot-graalvm-example" spring-boot-graal

# Fire up our Spring Boot Native app by default
CMD [ "sh", "-c", "./springboot-graalvm-example -Dserver.port=8080" ]


