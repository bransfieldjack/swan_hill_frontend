# Dockerfile
FROM node:16.0.0-alpine

# create destination directory
RUN mkdir -p /usr/src/nuxt-app
WORKDIR /usr/src/nuxt-app

# update and install dependency
RUN apk update && apk upgrade
RUN apk add git

# copy the app, note .dockerignore
COPY . /usr/src/nuxt-app/
RUN npm install
RUN npm run build
RUN npm run generate

EXPOSE 3000

ENV HOST 0.0.0.0

CMD [ "npm", "start" ]