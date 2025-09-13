# ===== Build stage =====
FROM maven:3.9-eclipse-temurin-11 AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn -B -q -DskipTests dependency:go-offline
COPY src ./src
RUN mvn -B -q -DskipTests clean package

# ===== Runtime stage =====
FROM eclipse-temurin:11-jre
WORKDIR /app
ARG JAR_FILE=target/*.jar
COPY --from=builder /app/${JAR_FILE} /app/app.jar
EXPOSE 8080
ENV JAVA_OPTS=""
# Use env MYSQL_HOST to override datasource host (application.properties supports it)
ENTRYPOINT ["sh","-c","java $JAVA_OPTS -jar /app/app.jar"]