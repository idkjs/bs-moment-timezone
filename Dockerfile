FROM node:lts-jessie-slim@sha256:9ab1a79977fcd20a8d94e019bb416b8d9e49022a9386b93eec37ce11a6d0c411 AS base

RUN apt-get update -qq && apt-get install -y --no-install-recommends build-essential

RUN curl -o- -L https://yarnpkg.com/install.sh | bash 2>&1 > /dev/null

FROM base

RUN mkdir -p /app/src /app/__tests__
WORKDIR /app

COPY package.json bsconfig.json yarn.lock ./
RUN yarn install

COPY auto ./auto
COPY src ./src
COPY __tests__ ./__tests__

# This is actually UTC+11
# https://en.wikipedia.org/wiki/Tz_database#Area
ENV TZ=":/usr/share/zoneinfo/Etc/GMT-11"

ENTRYPOINT ["yarn"]
CMD ["test"]
