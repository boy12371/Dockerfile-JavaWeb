FROM ubuntu:trusty

MAINTAINER zlong <zlong@cnksi.com>

ENV JAVA_VERSION 7u79
RUN apt-get update && apt-get install -y openjdk-7-jdk && \
    apt-get install -yq --no-install-recommends wget pwgen ca-certificates && \
    apt-get clean
    
#Install Tomcat
ENV TOMCAT_MAJOR_VERSION 7
ENV TOMCAT_MINOR_VERSION 7.0.55
ENV CATALINA_HOME /tomcat
ENV TOMCAT_PASS admin
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz && \
    wget -qO- https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 | md5sum -c - && \
    tar zxf apache-tomcat-*.tar.gz && \
    rm apache-tomcat-*.tar.gz && \
    mv apache-tomcat* tomcat

#Install SVN and Ant
ENV ANT_HOME=/opt/ant
RUN apt-get install -y subversion && \
    apt-get install -y ant && \
    rm -rf /var/lib/apt/lists/*

# Update and Deploy code
ENV SVN_URL svn://git.oschina.net/javawebdocker/javaweb
ENV SVN_USERNAME javawebdocker@126.com
ENV SVN_PASSWORD javawebdocker
ENV SVN_WORKSPACE /workspace
RUN svn co ${SVN_URL}/ ${SVN_WORKSPACE} --username=${SVN_USERNAME} --password=${SVN_PASSWORD} --non-interactive
RUN ant ${SVN_WORKSPACE}

#Start Tomcat
ADD create_tomcat_admin_user.sh /create_tomcat_admin_user.sh
ADD run.sh /run.sh
ADD redeploy.sh /redeploy.sh
RUN chmod +x /*.sh
EXPOSE 8080
CMD ["/run.sh"]

