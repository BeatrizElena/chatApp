# Add bootstrapping docker files

# Add image of specific version of Node to avoid accidental upgrades on later builds
FROM node:4.3.2

# Chain 2 shell commands together in a single RUN command. This reduces the number of layers in the resulting images.
# 1st shell command: Create unprivileged user "app" to run the app inside the container. W/out this, process inside container runs
# as root, which is a security issue.
# 2nd shell command: Install npm. Again use a specific version.
RUN useradd --user-group --create-home --shell /bin/false app &&\
  npm install --global npm@3.7.5


ENV HOME=/home/app

# Copy packaging files to the host.
# RUN chown gets files to the app user after copying because files copied with COPY command are owned by root and
# our app user can't access them.
COPY package.json npm-shrinkwrap.json $HOME/chat/
RUN chown -R app:app $HOME/*

USER app
WORKDIR $HOME/chat

# npm install run as the app user and installs dependencies in $HOME/chat/node_modules inside the container.
# npm cache clean removes the tar files that npm fownloads durig the install.
RUN npm install
RUN npm cache clean
