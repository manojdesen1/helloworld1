FROM tomcat:8.0-alpine
LABEL maintainer="manojelavur@gmail.com"

ADD target/hello-world-war-1.0.0.war /usr/local/tomcat/webapps/

EXPOSE 8080
CMD ["catalina.sh", "run"]
