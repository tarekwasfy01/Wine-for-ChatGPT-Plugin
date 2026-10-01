---
name: portable-wine
description: Use when a task needs Wine to execute or inspect a Windows x64 executable locally. Prefer the bundled prebuilt runtime; build Wine from bundled sources only if the prebuilt runtime cannot run on the host.
---

# Portable Wine

This is a pure skill plugin. It has no MCP server.

## Runtime policy

1. Prefer `scripts/ensure-wine.sh` and the bundled prebuilt Wine 10 x64 runtime.
2. Do not rebuild Wine merely because system Wine is missing.
3. Build from bundled sources only if the prebuilt runtime fails to start on the host.
4. Keep all extracted/build files outside the plugin directory in `${XDG_CACHE_HOME:-$HOME/.cache}/portable-wine-runner`.
5. Use a task-specific `WINEPREFIX` when practical. Do not modify a user's existing Wine prefix unless explicitly requested.
6. This packaged runtime is x86_64-focused. Do not claim 32-bit Windows support unless it has been separately verified on the host.

## Prepare Wine

Run:

```bash
bash "${PLUGIN_ROOT}/scripts/ensure-wine.sh"
```

The script prints the selected Wine executable as its final line. It first tests the prebuilt runtime and falls back to a source build if necessary.

## Run a Windows executable

Use:

```bash
bash "${PLUGIN_ROOT}/scripts/run-wine.sh" /absolute/path/to/program.exe [args...]
```

For console applications, capture stdout, stderr, and exit status. When Wine reports missing host libraries, explain the missing host dependency rather than pretending the Windows program failed.

## New clean prefix

For isolation:

```bash
export WINEPREFIX="${TMPDIR:-/tmp}/wine-prefix-$RANDOM"
bash "${PLUGIN_ROOT}/scripts/run-wine.sh" /absolute/path/to/program.exe
```

## Fallback build

If prebuilt Wine cannot execute on the host, `ensure-wine.sh --build` invokes `scripts/build-wine.sh`. The build uses bundled Wine 11.0, Bison 3.8.2 and Flex 2.6.4 sources. It needs a working C toolchain and `make` on the host.

See `references/BUILD.md` for details and licensing notes.
