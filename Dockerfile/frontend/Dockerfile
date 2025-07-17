FROM node:16

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm install

COPY . .

EXPOSE 1234

CMD ["npx", "parcel", "watch", "bundles-src/index.js", "--dist-dir", "bundles", "--public-url", "./"]

