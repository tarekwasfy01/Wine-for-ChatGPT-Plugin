#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CACHE_BASE="${XDG_CACHE_HOME:-${HOME:-/tmp}/.cache}/portable-wine-runner"
RUNTIME="$CACHE_BASE/runtime-v2"
ARCHIVE="$ROOT/assets/runtime/wine-11-x64-runtime-v1.0.3.tar.xz"
FORCE_BUILD=0
[[ "${1:-}" == "--build" ]] && FORCE_BUILD=1
mkdir -p "$CACHE_BASE"

runtime_bin() {
  if [[ -x "$RUNTIME/bin/wine64" ]]; then
    printf '%s\n' "$RUNTIME/bin/wine64"
  elif [[ -x "$RUNTIME/bin/wine" ]]; then
    printf '%s\n' "$RUNTIME/bin/wine"
  else
    return 1
  fi
}

# Try the bundled runtime first. If the archive is damaged/incomplete, fall back to
# rebuilding Wine from the bundled source archives instead of aborting the plugin.
if [[ $FORCE_BUILD -eq 0 ]]; then
  if ! runtime_bin >/dev/null 2>&1; then
    rm -rf "$RUNTIME.tmp"
    mkdir -p "$RUNTIME.tmp"
    if tar -xJf "$ARCHIVE" -C "$RUNTIME.tmp" 2>/dev/null; then
      rm -rf "$RUNTIME"
      mv "$RUNTIME.tmp" "$RUNTIME"
    else
      rm -rf "$RUNTIME.tmp" "$RUNTIME"
    fi
  fi

  if WINE_BIN="$(runtime_bin 2>/dev/null)"; then
    export WINEDLLPATH="$RUNTIME/lib/wine/x86_64-unix:$RUNTIME/lib/wine/x86_64-windows${WINEDLLPATH:+:$WINEDLLPATH}"
    if "$WINE_BIN" --version >/dev/null 2>&1; then
      printf '%s\n' "$WINE_BIN"
      exit 0
    fi
  fi
fi

exec "$ROOT/scripts/build-wine.sh"
