# Dockerfile for EventStore
# http://geteventstore.com/

FROM phusion/baseimage:0.9.15

MAINTAINER Wadim Kruse <wadim.kruse@gmail.com>

# Disable SSH
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Install curl
RUN apt-get update && apt-get install -y curl

# Create user
RUN addgroup eventstore \
		&& adduser --ingroup eventstore --disabled-password --gecos "Database" eventstore \
		&& usermod -L eventstore

# Set environment variables
USER eventstore
ENV ES_VERSION 3.0.0
ENV ES_HOME /opt/EventStore-OSS-Linux-v$ES_VERSION
ENV LD_LIBRARY_PATH $ES_HOME
ENV MONO_GC_DEBUG clear-at-gc
ENV EVENTSTORE_DB /data/db
ENV EVENTSTORE_LOG /data/logs
ENV EVENTSTORE_EXT_IP 0.0.0.0
ENV EVENTSTORE_RUN_PROJECTIONS ALL

# Download and extract EventStore
USER root
RUN curl http://download.geteventstore.com/binaries/EventStore-OSS-Linux-v$ES_VERSION.tar.gz | tar xz --directory /opt \
		&& chown -R eventstore:eventstore $ES_HOME

# Add volumes
RUN mkdir -p $EVENTSTORE_DB && mkdir -p $EVENTSTORE_LOG \
		&& chown -R eventstore:eventstore $EVENTSTORE_DB $EVENTSTORE_LOG
VOLUME $EVENTSTORE_DB 
VOLUME $EVENTSTORE_LOG

# Add EventStore daemon
RUN mkdir /etc/service/eventstored
ADD files/eventstored.sh /etc/service/eventstored/run

# Expose the HTTP and TCP ports
EXPOSE 2113 1113

# Clean up.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*