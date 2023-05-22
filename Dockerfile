FROM openjdk:17-jdk-alpine3.14 as build

WORKDIR /app

COPY . /app/

RUN ./gradlew build

FROM openjdk:11-ea-17-jre-slim

WORKDIR /app

RUN adduser -D user

COPY --from=build --chown=user:user /app/build/libs/dock-0.0.1-SNAPSHOT.jar ./

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/dock-0.0.1-SNAPSHOT.jar"]