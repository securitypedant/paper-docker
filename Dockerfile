# Java Version
ARG JAVA_VERSION=17

################################
### We use a java base image ###
################################
FROM amazoncorretto:${JAVA_VERSION}-alpine AS runtime

#########################################
### Maintained by Simon Thorpe        ###
### Contact: simon@securitypedant.com ###
#########################################
LABEL maintainer="Simon Thorpe <simon@securitypedant.com>"

##########################
### Environment & ARGS ###
##########################
ENV MINECRAFT_PATH=/opt/minecraft
ENV SERVER_PATH=${MINECRAFT_PATH}/server
ENV WORLDS_PATH=${MINECRAFT_PATH}/worlds
ENV PLUGINS_PATH=${MINECRAFT_PATH}/plugins
ENV LOGS_PATH=${MINECRAFT_PATH}/logs
ENV CONFIG_PATH=${MINECRAFT_PATH}/config
ENV DATA_PATH=${MINECRAFT_PATH}/data
ENV PROPERTIES_LOCATION=${SERVER_PATH}/server.properties

ENV JAVA_HEAP_SIZE=3G

###########################
### Libraries and tools ###
###########################
RUN apk add sudo 
RUN apk add nano
RUN apk add py3-pip
RUN pip3 install mcstatus

###################
### Healthcheck ###
###################
HEALTHCHECK --interval=10s --timeout=5s --start-period=120s \
    CMD mcstatus localhost:$( cat $PROPERTIES_LOCATION | grep "server-port" | cut -d'=' -f2 ) ping

###########################
### Directory structure ###
###########################

RUN mkdir ${MINECRAFT_PATH}
RUN mkdir ${SERVER_PATH}
RUN mkdir ${MINECRAFT_PATH}/worlds
RUN mkdir ${MINECRAFT_PATH}/plugins
RUN mkdir ${MINECRAFT_PATH}/logs
RUN mkdir ${MINECRAFT_PATH}/config
RUN mkdir ${MINECRAFT_PATH}/data

WORKDIR ${SERVER_PATH}

##########################
### Download paperclip ###
##########################
# Use get-paper-version.py to get the right URL for the version you need.
ARG PAPER_DOWNLOAD_URL=https://api.papermc.io/v2/projects/paper/versions/1.20/builds/17/downloads/paper-1.20-17.jar
ADD ${PAPER_DOWNLOAD_URL} paper.jar

######################
### Obtain scripts ###
######################
ADD scripts/docker-entrypoint.sh docker-entrypoint.sh
RUN chmod +x docker-entrypoint.sh

ADD scripts/eula.txt eula.txt

############
### User ###
############
RUN addgroup minecraft && \
    adduser -s /bin/bash minecraft -G minecraft -h ${MINECRAFT_PATH} -D && \
    chown -R minecraft:minecraft ${MINECRAFT_PATH}

USER minecraft

#########################
### Setup environment ###
#########################
# Create symlink for plugin volume as hotfix for some plugins who hard code their directories
RUN ln -s $PLUGINS_PATH $SERVER_PATH/plugins && \
    # Create symlink for persistent data
    ln -s $DATA_PATH/banned-ips.json $SERVER_PATH/banned-ips.json && \
    ln -s $DATA_PATH/banned-players.json $SERVER_PATH/banned-players.json && \
    ln -s $DATA_PATH/help.yml $SERVER_PATH/help.yml && \
    ln -s $DATA_PATH/ops.json $SERVER_PATH/ops.json && \
    ln -s $DATA_PATH/permissions.yml $SERVER_PATH/permissions.yml && \
    ln -s $DATA_PATH/whitelist.json $SERVER_PATH/whitelist.json && \
    # Create symlink for logs
    ln -s $LOGS_PATH $SERVER_PATH/logs && \
    # Create symlink for config
    ln -s $CONFIG_PATH $SERVER_PATH/config && \
    # Move the server.properties to config folder
    ln -s $CONFIG_PATH/server.properties $SERVER_PATH/server.properties

###############
### Volumes ###
###############
VOLUME "${CONFIG_PATH}"
VOLUME "${WORLDS_PATH}"
VOLUME "${PLUGINS_PATH}"
VOLUME "${DATA_PATH}"
VOLUME "${LOGS_PATH}"

###############################
### Expose minecraft ports  ###
###############################
EXPOSE 25565
# Geyser port for bedrock devices      
EXPOSE 19132

######################################
### Entrypoint is the start script ###
######################################
ENTRYPOINT [ "./docker-entrypoint.sh" ]

# Run Command
CMD [ "serve" ]
