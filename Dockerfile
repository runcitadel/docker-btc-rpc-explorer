ARG VERSION=master

FROM node:18-bullseye-slim AS builder

ARG VERSION

WORKDIR /build

RUN apt update

RUN apt install -y git python3 build-essential

RUN git clone --branch $VERSION https://github.com/janoside/btc-rpc-explorer .

# Make sure we can pull git npm dependencies
RUN git config --global url."https://github.com/".insteadOf git@github.com:
RUN git config --global url."https://".insteadOf ssh://

RUN npm ci --production

RUN rm -rf .git

FROM node:18-bullseye-slim

USER 1000

WORKDIR /data

COPY --from=builder /build .

EXPOSE 3002

CMD [ "npm", "start" ]
