FROM amazoncorretto:8-alpine3.17-jre

EXPOSE 3080

COPY ./target/java-maven-app-*.jar /usr/app/
WORKDIR /usr/app

CMD java -jar java-maven-app-*.jar
