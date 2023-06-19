# Updated version of paperspigot-docker
Forked from...

https://github.com/felixklauke/paper-docker

# To build
- docker build -t paperserver --no-cache=true .

and to build with multiplatform...

- docker buildx build --platform linux/amd64,linux/arm64 --push -t simonsecuritypedant/paperserver:1.20 .

# paperspigot-docker
Easy to use and clean Docker image for running Paper Spigot servers in Docker containers using the Amazon supported OpenJDK (https://hub.docker.com/_/amazoncorretto/)

Note in some places you will see reference to the UDP port 19132, this is for when i've built the server with Geyser and floodgate.

You may also be interested in [waterfall-docker](https://github.com/FelixKlauke/waterfall-docker) and [velocity-docker](https://github.com/FelixKlauke/velocity-docker) if you want to build a whole server network.

# Getting started
The easiest way for a quick start would be:
```bash
docker run -it \
    -p 25565:25565 \
    -v ~/minecraft/config:/opt/minecraft/config \
    -v ~/minecraft/worlds:/opt/minecraft/worlds \
    -v ~/minecraft/plugins:/opt/minecraft/plugins \
    -v ~/minecraft/data:/opt/minecraft/data \
    -v ~/minecraft/logs:/opt/minecraft/logs \
    simonsecuritypedant/paperserver:1.20
```

# Tags and Versions
The Docker images are tagged for their Minecraft versions. These versions are currently available:
- `simonsecuritypedant/paperserver:1.20`

The specific images are updated by hand. 

# Volumes
There are five volumes which are used for:
- Worlds
- Plugins
- Config files (paper.yml, bukkit.yml, spigot.yml, server.properties, commands.yml)
- Data (banned-ips.json, banned-players.json, help.yml, ops.json, permissions.yml, whitelist.json)
- Logs

You can find the mount locations in `docker-compose.yml`.

# docker-compose.yml
## Bind Mounts
This method is recommended if you have an already existing server which you wish to run inside a container [due to
the way bind mounts behave.](https://docs.docker.com/storage/bind-mounts/#mount-into-a-non-empty-directory-on-the-container)
You can add this simple entry to your docker-compose.yml when using bind mounts:
```yaml

services:
  minecraft:
    image: simonsecuritypedant/paperserver:1.20
    container_name: minecraft
    stdin_open: true
    tty: true
    restart: always
    networks:
      - minecraft
    ports:
      - 25565:25565
    volumes:
      - ./config:/opt/minecraft/config
      - ./worlds:/opt/minecraft/worlds
      - ./plugins:/opt/minecraft/plugins
      - ./data:/opt/minecraft/data
      - ./logs:/opt/minecraft/logs

networks:
  minecraft: {}

```

## Volumes
If you want to use explicit volumes, you can use this:
```yaml 

services:
  minecraft:
    image: simonsecuritypedant/paperserver:1.20
    container_name: minecraft
    stdin_open: true
    tty: true
    restart: always
    networks:
      - minecraft
    ports:
      - 25565:25565
    volumes:
      - minecraft-config:/opt/minecraft/config
      - minecraft-worlds:/opt/minecraft/worlds
      - minecraft-plugins:/opt/minecraft/plugins
      - minecraft-data:/opt/minecraft/data
      - minecraft-logs:/opt/minecraft/logs

volumes:
  minecraft-config: {}
  minecraft-worlds: {}
  minecraft-plugins: {}
  minecraft-data: {}
  minecraft-logs: {}

networks:
  minecraft: {}

```

# See Also
- [Docker CLI Reference: docker cp](https://docs.docker.com/engine/reference/commandline/cp/) - Copy files/folders between 
a container and the local filesystem. Useful if you want to add new plugins, change settings, etc.
- [Docker CLI Reference: docker attach](https://docs.docker.com/engine/reference/commandline/attach/) - Attach to a
running container. Will attach to the server's console directly, allowing you to issue commands. 
