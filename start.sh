#!/usr/bin/env bash
set -e
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
exec powershell.exe -NoProfile -ExecutionPolicy Bypass -File ./start-all.ps1 "$@"
