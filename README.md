# Springboot GraalVM Example

## Install GraalVM
Install [sdkman](https://sdkman.io/install), then:
```shell
sdk install java 22.3.r17-grl
```
Make graalvm as default jdk:
```shell
sdk default java 22.3.r17-grl
```

## Build & Run
```shell
./mvnw package -Pnative
```
Run executable:
```shell
target/springboot-graalvm-example
```
Test it:
```shell
curl --request GET 'http://localhost:8080/hello'
```
