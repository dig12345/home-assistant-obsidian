# Home Assistant add-on: build from source (no pre-published image).
# build.yaml supplies BUILD_FROM (e.g. docker.io/library/ubuntu:22.04) so Supervisor uses Ubuntu, not Alpine.
ARG BUILD_FROM=docker.io/library/ubuntu:22.04
FROM ${BUILD_FROM}

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Install runtime and add-on entrypoint deps (ca-certificates for HTTPS downloads in build)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    unzip \
    xvfb \
    x11vnc \
    openbox \
    nginx \
    fuse \
    libfuse2 \
    jq \
    gosu \
    x11-utils \
    libgtk-3-0 \
    libx11-6 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxi6 \
    libxtst6 \
    libnss3 \
    libxss1 \
    libgconf-2-4 \
    libxrandr2 \
    libasound2 \
    libpangocairo-1.0-0 \
    libatk1.0-0 \
    libcairo-gobject2 \
    libgdk-pixbuf2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Add obsidian user (match options default 1000)
RUN groupadd -g 1000 obsidian && useradd -u 1000 -g obsidian -m -s /bin/bash obsidian

# App dirs
RUN mkdir -p /opt/obsidian/app /opt/obsidian/scripts /opt/obsidian/config

# noVNC for web UI (curl with retries; wget often fails with SSL/exit 5 in HA build env)
WORKDIR /opt/obsidian
RUN curl -fSL --retry 3 --retry-delay 5 --connect-timeout 30 \
    -o noVNC.zip "https://github.com/novnc/noVNC/archive/refs/tags/v1.4.0.zip" \
    && unzip -q noVNC.zip && mv noVNC-1.4.0 noVNC && rm noVNC.zip

# Obsidian AppImage
WORKDIR /opt/obsidian/app
ARG OBSIDIAN_VERSION=1.8.10
RUN curl -fSL --retry 3 --retry-delay 5 --connect-timeout 60 \
    -o Obsidian.AppImage "https://github.com/obsidianmd/obsidian-releases/releases/download/v${OBSIDIAN_VERSION}/Obsidian-${OBSIDIAN_VERSION}.AppImage" \
    && chmod +x Obsidian.AppImage

# Rootfs: entrypoint, scripts, nginx, openbox
COPY rootfs/run.sh /run.sh
COPY rootfs/opt/obsidian/scripts/ /opt/obsidian/scripts/
COPY rootfs/etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY rootfs/home/obsidian/.config/openbox/rc.xml /home/obsidian/.config/openbox/rc.xml

RUN chmod +x /run.sh /opt/obsidian/scripts/start.sh /opt/obsidian/scripts/health-check.sh \
    && chown -R obsidian:obsidian /home/obsidian /opt/obsidian

# Obsidian stack expects /config (add-on will symlink /data -> /config)
ENV DISPLAY=:1
ENV XVFB_WHD=1920x1080x24
ENV OBSIDIAN_DATA_DIR=/config

WORKDIR /config
EXPOSE 3000

# HA add-on labels (required for Supervisor)
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION}

CMD ["/run.sh"]
