# https://github.com/graalvm/container/pkgs/container/graalvm-ce image
# Builder
#FROM ghcr.io/graalvm/jdk:ol7-java17-22.3.1
FROM ghcr.io/graalvm/graalvm-ce:22.3.1 as packager

ADD . /build
WORKDIR /build

#RUN ls -al /build/target/
RUN --mount=type=cache,target=/root/.m2 ./mvnw -B clean package -DskipTests \
#RUN --mount=type=cache,target=/root/.m2 ./mvnw -B clean package -Pnative -DskipTests \
    #--no-transfer-progress \
    ;


FROM ghcr.io/graalvm/native-image:22.3.1 as builder

WORKDIR /build
COPY --from=packager /build/target/springboot-graalvm-example.jar springboot-graalvm-example.jar
RUN jar -xvf springboot-graalvm-example.jar; \
    native-image -H:Name=springboot  -cp .:BOOT-INF/classes:`find BOOT-INF/lib | tr '\n' ':'` io.github.abetobing.graalvm.SpringbootGraalvmExampleApplication
#RUN native-image -jar springboot-graalvm-example.jar -o app

# Runner
FROM alpine:3.17.1

MAINTAINER Abe Tobing

RUN set -ex && \
    apk add gcompat

WORKDIR /app
# Add Spring Boot Native app springboot-graalvm-example to Container
COPY --from=builder "/build/springboot" springboot
RUN chmod +x springboot


# Fire up our Spring Boot Native app by default
CMD ["/app/springboot -Dserver.port=8080"]

