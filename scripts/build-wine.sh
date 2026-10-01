#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CACHE_BASE="${XDG_CACHE_HOME:-${HOME:-/tmp}/.cache}/portable-wine-runner"
SRC="$CACHE_BASE/src"
BUILD="$CACHE_BASE/build"
PREFIX="$CACHE_BASE/source-built"
mkdir -p "$SRC" "$BUILD"

need(){ command -v "$1" >/dev/null 2>&1 || { echo "missing required host tool: $1" >&2; exit 127; }; }
need tar; need make; need cc

build_flex(){
  if command -v flex >/dev/null 2>&1; then command -v flex; return; fi
  local s="$SRC/flex-2.6.4" b="$BUILD/flex" p="$CACHE_BASE/flex"
  if [[ ! -x "$p/bin/flex" ]]; then
    rm -rf "$s" "$b"; mkdir -p "$s" "$b" "$p"
    tar -xzf "$ROOT/assets/sources/flex-2.6.4.tar.gz" -C "$s" --strip-components=1
    (cd "$b" && "$s/configure" --prefix="$p" && make -j2 && make install)
  fi
  printf '%s\n' "$p/bin/flex"
}

build_bison(){
  if command -v bison >/dev/null 2>&1; then command -v bison; return; fi
  local s="$SRC/bison-3.8.2" b="$BUILD/bison" p="$CACHE_BASE/bison"
  if [[ ! -x "$p/bin/bison" ]]; then
    rm -rf "$s" "$b"; mkdir -p "$s" "$b" "$p"
    tar -xJf "$ROOT/assets/sources/bison-3.8.2.tar.xz" -C "$s" --strip-components=1
    (cd "$b" && "$s/configure" --prefix="$p" && make -j2 && make install)
  fi
  printf '%s\n' "$p/bin/bison"
}

FLEX_BIN="$(build_flex)"
BISON_BIN="$(build_bison)"
WINE_SRC="$SRC/wine-11.0"
WINE_BUILD="$BUILD/wine"
if [[ ! -x "$PREFIX/bin/wine" && ! -x "$PREFIX/bin/wine64" ]]; then
  rm -rf "$WINE_SRC" "$WINE_BUILD" "$PREFIX"
  mkdir -p "$WINE_SRC" "$WINE_BUILD" "$PREFIX"
  tar -xJf "$ROOT/assets/sources/wine-11.0.tar.xz" -C "$WINE_SRC" --strip-components=1
  # Prefer Wine's internal import-library writer when external dlltool is unavailable.
  python3 - "$WINE_SRC/tools/winebuild/main.c" <<'PY'
from pathlib import Path
import sys
p=Path(sys.argv[1]); s=p.read_text()
if 'int use_dlltool = 1;' in s:
    p.write_text(s.replace('int use_dlltool = 1;','int use_dlltool = 0;',1))
PY
  export PATH="$(dirname "$FLEX_BIN"):$(dirname "$BISON_BIN"):$PATH"
  export FLEX="$FLEX_BIN" BISON="$BISON_BIN"
  (cd "$WINE_BUILD" && "$WINE_SRC/configure" --enable-win64 --without-freetype --disable-tests --prefix="$PREFIX" && make -j2 && make install)
fi
if [[ -x "$PREFIX/bin/wine64" ]]; then printf '%s\n' "$PREFIX/bin/wine64"; else printf '%s\n' "$PREFIX/bin/wine"; fi
