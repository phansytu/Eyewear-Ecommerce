FROM tomcat:10.1.54-jdk21

RUN rm -rf /usr/local/tomcat/webapps/*

COPY dist/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]