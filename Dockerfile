FROM openjdk:17-alpine
EXPOSE 8080
RUN mkdir -p /app/
ADD build/libs/dock-0.0.1-SNAPSHOT.jar /app/dock-0.0.1-SNAPSHOT.jar
ENTRYPOINT ["java", "-jar", "/app/dock-0.0.1-SNAPSHOT.jar"]