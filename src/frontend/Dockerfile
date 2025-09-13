# ===== Build stage (Angular 12 friendly) =====
FROM node:14-bullseye AS builder
WORKDIR /app

# Copy only package manifest (avoid bringing a stale lockfile)
COPY package.json ./
# Install deps and tolerate legacy peer-dep trees typical for Angular 12
RUN npm install --no-audit --no-fund --legacy-peer-deps

# Bring in the rest of the sources
COPY . .

# Production build (Angular 12)
RUN npm run build -- --configuration production

# ===== Nginx stage =====
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist/frontend /usr/share/nginx/html
EXPOSE 80
CMD ["nginx","-g","daemon off;"]

