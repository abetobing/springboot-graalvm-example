# https://github.com/graalvm/container/pkgs/container/graalvm-ce image
# Builder
#FROM ghcr.io/graalvm/jdk:ol7-java17-22.3.1
FROM ghcr.io/graalvm/graalvm-ce:22.3.1

ADD . /build
WORKDIR /build

# For SDKMAN to work we need unzip & zip
RUN microdnf install -y unzip zip

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


# Runner
FROM alpine:3.17.1

MAINTAINER Abe Tobing

# Add Spring Boot Native app spring-boot-graal to Container
COPY --from=0 "/build/target/spring-boot-graal" spring-boot-graal

# Fire up our Spring Boot Native app by default
CMD [ "sh", "-c", "./spring-boot-graal -Dserver.port=8080" ]


