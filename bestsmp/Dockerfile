FROM mc-base 

ENV MINECRAFT_PATH=/opt/minecraft/server
WORKDIR ${MINECRAFT_PATH}

ADD mods/floodgate-spigot.jar plugins/floodgate-spitfot.jar
ADD mods/Geyser-Spigot.jar plugins/Geyser-Spitgot.jar

# Run Command
CMD [ "serve" ]