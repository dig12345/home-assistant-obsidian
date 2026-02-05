#!/bin/bash
# Add-on entrypoint: link add-on data to /config and start Obsidian stack as obsidian user.
set -e

# Symlink add-on persistent storage to /config (what the Obsidian stack expects)
if [ ! -L /config ]; then
  if [ -d /config ] && [ "$(ls -A /config 2>/dev/null)" ]; then
    cp -a /config/. /data/ 2>/dev/null || true
    rm -rf /config
  fi
  ln -sf /data /config
fi

# Read options from Home Assistant add-on options.json
if [ -f /data/options.json ]; then
  export PUID="$(jq -r '.puid // 1000' /data/options.json)"
  export PGID="$(jq -r '.pgid // 1000' /data/options.json)"
  export TZ="$(jq -r '.tz // "UTC"' /data/options.json)"
else
  export PUID="${PUID:-1000}"
  export PGID="${PGID:-1000}"
  export TZ="${TZ:-UTC}"
fi

exec gosu obsidian /opt/obsidian/scripts/start.sh
