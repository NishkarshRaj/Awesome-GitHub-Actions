FROM openjdk:11
EXPOSE 8080
ADD target/*.jar test.jar
ENTRYPOINT ["java","-jar","/test.jar"]
