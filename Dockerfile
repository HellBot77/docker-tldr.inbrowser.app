FROM node:alpine AS build

ARG TAG=latest
RUN apk add --no-cache git && \
    git clone https://github.com/InBrowserApp/tldr.inbrowser.app.git && \
    cd tldr.inbrowser.app && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    npm install --global pnpm && \
    pnpm install && \
    pnpm run build

FROM pierrezemb/gostatic

COPY --from=build /tldr.inbrowser.app/dist /srv/http
EXPOSE 8043
