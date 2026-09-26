#!/usr/bin/env sh
set -eu
PROJECT_DIR=$(dirname "$0")
if [ -x "$PROJECT_DIR/.venv/bin/python" ]; then
    exec "$PROJECT_DIR/.venv/bin/python" "$PROJECT_DIR/app.py" "$@"
fi
exec python3 "$PROJECT_DIR/app.py" "$@"
