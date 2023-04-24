ARG NODE_VERSION
FROM --platform=$BUILDPLATFORM node:${NODE_VERSION}

WORKDIR /build
RUN curl -o flatris -L \
  https://github.com/KrawczowaKris/flatris/archive/refs/heads/main.zip \
  && unzip flatris \
  && cd flatris-main \
  && yarn install \
  && NODE_OPTIONS=--openssl-legacy-provider yarn build

EXPOSE 3000
ENTRYPOINT [ "yarn", "start" ]
