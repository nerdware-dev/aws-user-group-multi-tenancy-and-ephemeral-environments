#  Use an official Node.js runtime image as a base
FROM --platform=linux/amd64 node:18-alpine as build
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY ./src ./src
COPY tsconfig.json ./
RUN npm run build
FROM --platform=linux/amd64 node:18-alpine
WORKDIR /usr/src/app
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/dist ./dist
CMD ["node", "dist/main"]
