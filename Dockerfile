# syntax=docker/dockerfile:1

# ---- Stage 1: install production dependencies only ----
FROM node:20-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev && npm cache clean --force

# ---- Stage 2: minimal runtime image ----
FROM gcr.io/distroless/nodejs20-debian12:nonroot AS runtime

ARG VERSION=1.0.0
ARG REVISION=unknown
ARG CREATED=unknown

LABEL org.opencontainers.image.title="devops-lab-3" \
      org.opencontainers.image.description="Lab 3 - optimized OCI image for a small Express API" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.revision="${REVISION}" \
      org.opencontainers.image.created="${CREATED}" \
      org.opencontainers.image.authors="Samuel Shine" \
      org.opencontainers.image.source="https://github.com/samuelshine/devops-lab-3" \
      org.opencontainers.image.licenses="MIT"

ENV NODE_ENV=production \
    APP_VERSION=${VERSION} \
    PORT=3000

WORKDIR /app
COPY --from=deps --chown=nonroot:nonroot /app/node_modules ./node_modules
COPY --chown=nonroot:nonroot package.json ./
COPY --chown=nonroot:nonroot src ./src

USER nonroot
EXPOSE 3000
CMD ["src/server.js"]
