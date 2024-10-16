# Stage 1: Create build the project to create .jar file

FROM maven:3.8.3-openjdk-11 AS build
# Create and set the working directory
RUN mkdir /app
WORKDIR /app
# Copy the pom.xml and download dependencies (use caching)
COPY pom.xml .
RUN mvn dependency:resolve
COPY src .

# Build the project (compile and package)
RUN mvn clean package

# Stage 2: Use a lighter OpenJDK image just to run the built .jar file
#Use a lightweight JRE image to run the application
FROM openjdk:11-jre-slim
WORKDIR /app
# Copy the built JAR from the build stage
COPY --from=build /app/target/*.jar app.jar
# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
