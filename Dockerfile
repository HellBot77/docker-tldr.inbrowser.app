FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/InBrowserApp/tldr.inbrowser.app.git && \
    cd tldr.inbrowser.app && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:alpine AS build

WORKDIR /tldr.inbrowser.app
COPY --from=base /git/tldr.inbrowser.app .
RUN npm install --global pnpm && \
    pnpm install && \
    pnpm build

FROM lipanski/docker-static-website

COPY --from=build /tldr.inbrowser.app/dist .

