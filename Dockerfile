# Static digest dashboard served by nginx.
# Deploy target: Sliplane (builds this Dockerfile from your connected Git repo).
FROM nginx:1.27-alpine

# Sliplane lets you pick the container port in the service settings; default 80.
# The official nginx image substitutes ${PORT} into the config at startup and
# leaves nginx's own runtime vars ($uri etc.) untouched, so this is safe.
ENV PORT=80

# Rendered to /etc/nginx/conf.d/default.conf on container start.
COPY default.conf.template /etc/nginx/templates/default.conf.template

# The dashboard and its archive.
COPY dashboard.html archive.html archive.json /usr/share/nginx/html/

EXPOSE 80

# Lightweight liveness check (busybox wget ships in alpine).
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q --spider "http://127.0.0.1:${PORT}/" || exit 1
