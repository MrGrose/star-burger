FROM node:16-alpine AS build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm install

COPY . .

FROM node:16-alpine

WORKDIR /app

COPY --from=build /app .

CMD ["npx", "parcel", "watch", "bundles-src/index.js", "--dist-dir", "bundles", "--public-url", "./"]