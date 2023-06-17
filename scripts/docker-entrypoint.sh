#!/bin/sh
set -e

if [[ "$1" = 'serve' ]];  then

  # Start server
  exec java -Xmx$JAVA_HEAP_SIZE -Xms$JAVA_HEAP_SIZE \
    -jar $SERVER_PATH/paper.jar --nogui \
    --bukkit-settings $CONFIG_PATH/bukkit.yml --plugins $PLUGINS_PATH --world-dir $WORLDS_PATH \
    --spigot-settings $CONFIG_PATH/spigot.yml --commands-settings $CONFIG_PATH/commands.yml
fi

exec "$@"
