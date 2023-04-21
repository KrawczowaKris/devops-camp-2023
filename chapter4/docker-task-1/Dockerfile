ARG CODE_VERSION=19.9.0
FROM --platform=$BUILDPLATFORM node:${CODE_VERSION}

RUN git clone git@github.com:KrawczowaKris/flatris.git && cd flatris

WORKDIR /build

COPY . /build
RUN yarn install && NODE_OPTIONS=--openssl-legacy-provider yarn build

EXPOSE 3000
ENTRYPOINT [ "yarn", "start" ]
