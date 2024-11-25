FROM node:16 AS build

WORKDIR /app

# Install dependencies and build the app
COPY package.json yarn.lock ./
RUN yarn install
COPY . .
RUN yarn build

# Use Nginx to serve the frontend
FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
