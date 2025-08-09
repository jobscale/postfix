FROM node:lts-bookworm-slim
SHELL ["bash", "-c"]
WORKDIR /home/node
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends locales curl git vim less unzip \
    iproute2 dnsutils netcat-openbsd python3-pip sudo postfix \
 && apt-get clean && rm -fr /var/lib/apt/lists/*
RUN mkfifo /var/spool/postfix/public/pickup
RUN usermod -aG sudo node && echo '%sudo ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/40-users
RUN sed -i -e 's/# ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/' /etc/locale.gen && locale-gen && update-locale LANG=ja_JP.UTF-8 \
 && echo -e "export LANG=ja_JP.UTF-8\nexport TZ=Asia/Tokyo\numask u=rwx,g=rx,o=rx" | tee -a /etc/bash.bashrc
RUN chown -R node. /usr/local/lib/node_modules \
 && chown -R :node /usr/local/bin && chmod -R g+w /usr/local/bin \
 && chown -R :node /usr/local/share && chmod -R g+w /usr/local/share

USER node
RUN npm version | xargs
COPY --chown=node:staff mail .
