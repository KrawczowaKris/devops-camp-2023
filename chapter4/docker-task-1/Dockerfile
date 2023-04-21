FROM --platform=$BUILDPLATFORM node:19.9.0

RUN git clone git@github.com:KrawczowaKris/flatris.git && cd flatris

WORKDIR /build

COPY . ./
RUN yarn install && NODE_OPTIONS=--openssl-legacy-provider yarn build

EXPOSE 3000
ENTRYPOINT [ "yarn", "start" ]
