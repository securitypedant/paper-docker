#!/bin/sh
set -e

if [[ "$1" = 'serve' ]];  then

  # Start server
  exec java -jar $JAVA_ARGS \
    -Xmx$JAVA_HEAP_SIZE -Xms$JAVA_HEAP_SIZE \
    $SERVER_PATH/paper.jar
fi

exec "$@"
