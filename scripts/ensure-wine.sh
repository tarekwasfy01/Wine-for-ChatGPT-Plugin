#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CACHE_BASE="${XDG_CACHE_HOME:-${HOME:-/tmp}/.cache}/portable-wine-runner"
RUNTIME="$CACHE_BASE/runtime-v1"
ARCHIVE="$ROOT/assets/runtime/wine-10-x64-runtime.tar.xz"
FORCE_BUILD=0
[[ "${1:-}" == "--build" ]] && FORCE_BUILD=1
mkdir -p "$CACHE_BASE"

# Prefer an already-working unpacked prebuilt runtime. Do not prefer random system Wine;
# this keeps behavior reproducible across plugin runs.
if [[ $FORCE_BUILD -eq 0 ]]; then
  if [[ ! -x "$RUNTIME/bin/wine64" ]]; then
    rm -rf "$RUNTIME.tmp"
    mkdir -p "$RUNTIME.tmp"
    tar -xJf "$ARCHIVE" -C "$RUNTIME.tmp"
    rm -rf "$RUNTIME"
    mv "$RUNTIME.tmp" "$RUNTIME"
  fi
  export WINEDLLPATH="$RUNTIME/lib/wine/x86_64-unix:$RUNTIME/lib/wine/x86_64-windows${WINEDLLPATH:+:$WINEDLLPATH}"
  if "$RUNTIME/bin/wine64" --version >/dev/null 2>&1; then
    printf '%s\n' "$RUNTIME/bin/wine64"
    exit 0
  fi
fi

exec "$ROOT/scripts/build-wine.sh"
