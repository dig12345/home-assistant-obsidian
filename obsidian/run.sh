#!/usr/bin/with-contenv bashio
# shellcheck shell=bash disable=SC2155
set -e

# Symlink /data to /config to match linuxserver.io's expected data path.
if [ ! -L /config ]; then
  bashio::log.info "/config is not a symlink. Checking for existing data..."
  if [ -d /config ] && [ "$(ls -A /config)" ]; then
    bashio::log.info "Moving existing data from /config to /data..."
    cp -a /config/. /data/
    rm -rf /config
  fi
  bashio::log.info "Re-linking /config to /data..."
  ln -s /data /config
fi

# Export user-provided options
export PUID="$(bashio::config 'puid')"
export PGID="$(bashio::config 'pgid')"
export TZ="$(bashio::config 'tz')"

# Pre-create X11 socket directory so the display server can start (avoids
# "_XSERVTransmkdir: Owner of /tmp/.X11-unix should be set to root").
mkdir -p /tmp/.X11-unix
chown 0:0 /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

exec /init
