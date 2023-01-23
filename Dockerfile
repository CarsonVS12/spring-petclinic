#  Base image
FROM maven:3.8.7-amazoncorretto-19 AS build-env

#  Create app directory
WORKDIR /app

EXPOSE 8080

#  RUN mvn clean package
COPY pom.xml ./pom.xml
COPY .mvn/ ./
COPY src ./src
COPY mvnw ./mvnw
CMD mvn spring-boot:run 

# FROM eclipse-temurin:17-jdk-jammy

# WORKDIR /app
# EXPOSE 8080
# COPY .mvn/ .mvn
# COPY mvnw pom.xml ./
# RUN ./mvnw dependency:resolve

# COPY src ./src

# CMD ["./mvnw", "spring-boot:run"]