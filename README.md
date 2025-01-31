# System Monitoring Script

## Overview

This is a Bash script designed to monitor key system metrics, including disk usage, CPU usage, and memory usage, providing warnings when any of these metrics exceed 80%. The script outputs a formatted system monitoring report, highlighting potential issues to help with system management.

## Features

- **Disk Usage Monitoring**: Checks disk usage for all mounted filesystems and warns if usage exceeds 80%.
- **CPU Usage Monitoring**: Displays current CPU usage and warns if usage exceeds 80%.
- **Memory Usage Monitoring**: Displays total, used, and free memory.
- **Top 5 Memory-Consuming Processes**: Lists the top 5 processes consuming the most memory.

## Requirements

- A Linux-based operating system.
- Basic utilities like `df`, `top`, `free`, `awk`, and `bc` (usually installed by default).

## Installation

To use the script, simply download it to your system and make it executable:

```bash
wget https://github.com/Marwan-alanani/Monitoring-cron-job.git
chmod +x monitor.sh
chmod +x monitoring.sh
