# https://github.com/graalvm/container/pkgs/container/graalvm-ce image
# Builder
FROM ghcr.io/graalvm/graalvm-ce:22.3.1 as builder

ADD . /build
WORKDIR /build

RUN --mount=type=cache,target=/root/.m2 ./mvnw -B clean package -Pnative -DskipTests;

# Runner
FROM alpine:3.17.1

MAINTAINER Abe Tobing

RUN set -ex && \
    apk add gcompat

WORKDIR /app
# Add Spring Boot Native app springboot-graalvm-example to Container
COPY --from=builder "/build/target/springboot-graalvm-example" springboot
RUN chmod +x springboot

# Fire up our Spring Boot Native app by default
CMD ["/app/springboot"]

