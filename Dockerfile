# Base image
FROM maven:3.6.3-openjdk-11-slim AS build-env

# Create app directory
WORKDIR /app

EXPOSE 8000

RUN .mvnw clean package
COPY pom.xml/ ./pom.xml
COPY .mvn/ ./.mvn
COPY src ./src
COPY mvnw ./mvnw


CMD .mvnw spring-boot:run 
