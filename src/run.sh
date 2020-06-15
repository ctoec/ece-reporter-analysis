#!/usr/bin/env bash
# This script should run on the cron schedule 5 6 * * * if the cron is UTC, 5 1 * * * if it is ET,
# crons are with a format M H DOM M DOW
# Set current directory as part of the pythonpath to ensure all packages are loaded correctly
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export PYTHONPATH="${PYTHONPATH}:${DIR}"
python3 main.py