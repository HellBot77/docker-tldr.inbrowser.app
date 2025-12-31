FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/InBrowserApp/tldr.inbrowser.app.git && \
    cd tldr.inbrowser.app && \
    # ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM --platform=$BUILDPLATFORM node:alpine AS build

WORKDIR /tldr.inbrowser.app
COPY --from=base /git/tldr.inbrowser.app .
RUN npm install --global pnpm@9 && \
    pnpm install --frozen-lockfile && \
    pnpm build

FROM joseluisq/static-web-server

COPY --from=build /tldr.inbrowser.app/dist ./public
