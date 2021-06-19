FROM amazonlinux
LABEL Server="Tomcat Server"
LABEL JDK="11"
LABEL TomcatVer="10.0.5"
USER root
RUN yum update -y
RUN yum install wget -y
RUN yum install unzip -y
RUN yum install java-11-amazon-corretto-headless -y
RUN yum install java-11-amazon-corretto -y
RUN yum install shadow-utils.x86_64 -y
RUN groupadd tomcat
WORKDIR /opt
RUN curl https://mirrors.estointernet.in/apache/tomcat/tomcat-10/v10.0.6/bin/apache-tomcat-10.0.6.zip -o tocmcat.zip
RUN unzip *.zip -d /opt
RUN ls -ls
RUN useradd -M -s /bin/nologin -g tomcat -d /opt/apache-tomcat-10.0.6 tomcat
RUN chgrp -R tomcat /opt/apache-tomcat-10.0.6
WORKDIR /opt/apache-tomcat-10.0.6
RUN chmod -R g+r conf
RUN chmod g+x conf
RUN chown -R tomcat webapps/ work/ temp/ logs/
RUN chmod -R +x bin
RUN usermod -aG tomcat root
COPY /target/*.war /opt/apache-tomcat-10.0.6/webapps/flipcart.war
EXPOSE 8080
HEALTHCHECK --interval=10s --timeout=5s CMD curl --fail http://localhost:8080 || exit 1
CMD ["/opt/apache-tomcat-10.0.6/bin/catalina.sh", "run"]