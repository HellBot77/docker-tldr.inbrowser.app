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
    pnpm run build

FROM pierrezemb/gostatic

COPY --from=build /tldr.inbrowser.app/dist /srv/http
EXPOSE 8043
