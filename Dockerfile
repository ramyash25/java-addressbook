FROM tomcat:9.0.123-jre21-temurin

COPY target/addressbook.war /usr/local/tomcat/webapps/addressbook.war

EXPOSE 8080
