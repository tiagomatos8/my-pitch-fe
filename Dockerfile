#Stage 1
FROM node:17-alpine as builder

# Add a work directory
WORKDIR /app

# Cache and Install dependencies
COPY package.json .
COPY package-lock.json .
RUN npm i

# Copy app files
COPY . .

# Build the web app
RUN npm run build

#Stage 2
FROM nginx:1.25 as prod
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=builder /app/dist .
WORKDIR /etc/nginx/conf.d
COPY --from=builder /app/nginx/default.conf .
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]