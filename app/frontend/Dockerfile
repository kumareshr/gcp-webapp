# Use a Node.js image for the build stage
FROM node:16 AS build

# Set working directory
WORKDIR /app

# Copy dependency files
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install

# Copy application files
COPY . .

# Build the application
RUN yarn build

# Use an Nginx image for serving the built application
FROM nginx:stable-alpine

# Copy the build output to Nginx's default HTML directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 dummy
EXPOSE 80

# Default command to start Nginx
CMD ["nginx", "-g", "daemon off;"]
