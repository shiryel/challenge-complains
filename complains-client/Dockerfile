###############
# Build Stage #
###############
FROM alpine as build

RUN apk update --no-cache
RUN apk add yarn

COPY . .

RUN yarn install
RUN yarn export \
    && cp -rp __sapper__/export /export

####################
# Deployment Stage #
####################
FROM nginx

COPY --from=build /export /usr/share/nginx/html

EXPOSE 80
