FROM teenak/centos-cdh-hadoop-namenode
MAINTAINER Taishun Nakatani <teenak77@gmail.com>

RUN mkdir -p /opt/apache
RUN curl -s http://ftp.yz.yamagata-u.ac.jp/pub/network/apache/spark/spark-1.6.2/spark-1.6.2-bin-hadoop2.6.tgz  | tar -xz -C /opt/apache
RUN cd /opt/apache && ln -s spark-1.6.2-bin-hadoop2.6 spark

ENV HADOOP_CONF_DIR /etc/hadoop/conf
ENV YARN_CONF_DIR /etc/hadoop/conf
ENV SPARK_HOME /opt/apache/spark
RUN echo "HADOOP_CONF_DIR=/etc/hadoop/conf" >> /etc/environment
RUN echo "YARN_CONF_DIR=/etc/hadoop/conf" >> /etc/environment
RUN echo "SPARK_HOME=/opt/apache/spark" >> /etc/environment

ADD conf/core-site.xml /etc/hadoop/conf/core-site.xml
ADD conf/hdfs-site.xml /etc/hadoop/conf/hdfs-site.xml
ADD conf/yarn-site.xml /etc/hadoop/conf/yarn-site.xml

# update boot script
COPY bootstrap.sh /etc/bootstrap.sh
RUN chown root.root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh


EXPOSE 8020 50070 8088 8030 8031 8032 8033

#define HDFS volume to enable to persist namenode fsimage between restart
VOLUME /hadoop

ENTRYPOINT ["/etc/bootstrap.sh"]

