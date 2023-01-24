#  Base image
FROM maven:3.8.7-amazoncorretto-19 AS build-env

WORKDIR /app

EXPOSE 8080

COPY pom.xml ./pom.xml
COPY .mvn/ ./
COPY src ./src
COPY mvnw ./mvnw
CMD mvn spring-boot:run 
