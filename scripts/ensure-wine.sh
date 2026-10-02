#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CACHE_BASE="${XDG_CACHE_HOME:-${HOME:-/tmp}/.cache}/portable-wine-runner"
RUNTIME="$CACHE_BASE/runtime-v1"
ARCHIVE="$ROOT/assets/runtime/wine-10-x64-runtime.tar.xz"
FORCE_BUILD=0
[[ "${1:-}" == "--build" ]] && FORCE_BUILD=1
mkdir -p "$CACHE_BASE"

pick_wine() {
  if [[ -x "$1/bin/wine64" ]]; then printf '%s\n' "$1/bin/wine64"; return 0; fi
  if [[ -x "$1/bin/wine" ]]; then printf '%s\n' "$1/bin/wine"; return 0; fi
  return 1
}

if [[ $FORCE_BUILD -eq 0 && -f "$ARCHIVE" ]]; then
  WINE_BIN="$(pick_wine "$RUNTIME" 2>/dev/null || true)"
  if [[ -z "$WINE_BIN" ]]; then
    rm -rf "$RUNTIME.tmp"
    mkdir -p "$RUNTIME.tmp"
    if tar -xJf "$ARCHIVE" -C "$RUNTIME.tmp" >/dev/null 2>&1; then
      rm -rf "$RUNTIME"
      mv "$RUNTIME.tmp" "$RUNTIME"
      WINE_BIN="$(pick_wine "$RUNTIME" 2>/dev/null || true)"
    else
      rm -rf "$RUNTIME.tmp"
    fi
  fi
  if [[ -n "${WINE_BIN:-}" ]]; then
    export WINEDLLPATH="$RUNTIME/lib/wine/x86_64-unix:$RUNTIME/lib/wine/x86_64-windows${WINEDLLPATH:+:$WINEDLLPATH}"
    if "$WINE_BIN" --version >/dev/null 2>&1; then
      printf '%s\n' "$WINE_BIN"
      exit 0
    fi
  fi
fi

exec "$ROOT/scripts/build-wine.sh"
