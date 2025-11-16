# Stage 1: Build the app
FROM eclipse-temurin:21-jdk AS builder

WORKDIR /app

# Copy Maven wrapper files
COPY mvnw .
COPY .mvn/ .mvn/

# Fix permissions + convert CRLF → LF
RUN chmod +x mvnw && chmod -R +x .mvn/wrapper
RUN apt-get update && apt-get install -y dos2unix && dos2unix mvnw && dos2unix .mvn/wrapper/*

# Copy project files
COPY pom.xml .
COPY src ./src

# Build the application
RUN ./mvnw clean package -DskipTests

# Stage 2: Run the app
FROM eclipse-temurin:21-jdk

WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 2000

ENTRYPOINT ["java", "-jar", "app.jar"]
