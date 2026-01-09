#!/usr/bin/env bash

export TZ="Asia/Kolkata"

LOG="/var/log/jenkins_monitor.log"
STATE="/var/run/jenkins_monitor.state"

# Local IST timestamp
timestamp() { date +"%Y-%m-%dT%H:%M:%S%z"; }

mkdir -p "$(dirname "$LOG")"
touch "$LOG"
chmod 644 "$LOG"

active=$(systemctl is-active jenkins 2>/dev/null || echo "unknown")
pid=$(pgrep -f "jenkins.war" | head -n1 || true)

prev_active=""
prev_pid=""
if [ -f "$STATE" ]; then
  read -r prev_active prev_pid < "$STATE" || true
fi

if [ "$active" != "$prev_active" ]; then
  echo "$(timestamp) STATUS_CHANGE $active prev=$prev_active" >> "$LOG"
fi

if [ -n "$prev_pid" ] && [ -n "$pid" ] && [ "$pid" != "$prev_pid" ]; then
  echo "$(timestamp) RESTART detected new_pid=$pid old_pid=$prev_pid" >> "$LOG"
fi

if [ -z "$prev_pid" ] && [ -n "$pid" ] && [ "$active" = "active" ]; then
  echo "$(timestamp) START detected pid=$pid" >> "$LOG"
fi

if [ "$active" != "active" ]; then
  echo "$(timestamp) DOWN state=$active" >> "$LOG"
fi

echo "$active $pid" > "$STATE"