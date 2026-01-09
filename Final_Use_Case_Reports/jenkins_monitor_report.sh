#!/usr/bin/env bash
LOG="/var/log/jenkins_monitor.log"
echo "Jenkins Monitor Report"
echo "Generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
echo
echo "Total DOWN occurrences: $(grep -c "DOWN state" "$LOG" 2>/dev/null || echo 0)"
echo "Total START occurrences: $(grep -c "START detected" "$LOG" 2>/dev/null || echo 0)"
echo "Total RESTART occurrences: $(grep -c "RESTART detected" "$LOG" 2>/dev/null || echo 0)"
echo
echo "Last 10 events:"
tail -n 10 "$LOG"