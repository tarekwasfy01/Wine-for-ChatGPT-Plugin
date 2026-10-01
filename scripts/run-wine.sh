#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
[[ $# -ge 1 ]] || { echo "usage: run-wine.sh program.exe [args...]" >&2; exit 64; }
WINE="$($ROOT/scripts/ensure-wine.sh)"
RUNTIME_ROOT="$(cd "$(dirname "$WINE")/.." && pwd)"
if [[ -d "$RUNTIME_ROOT/lib/wine" ]]; then
  export WINEDLLPATH="$RUNTIME_ROOT/lib/wine/x86_64-unix:$RUNTIME_ROOT/lib/wine/x86_64-windows${WINEDLLPATH:+:$WINEDLLPATH}"
fi
export WINEPREFIX="${WINEPREFIX:-${XDG_CACHE_HOME:-${HOME:-/tmp}/.cache}/portable-wine-runner/prefix}"
export WINEDEBUG="${WINEDEBUG:--all}"
mkdir -p "$WINEPREFIX"
exec "$WINE" "$@"
