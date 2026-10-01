# Runtime and build fallback

The plugin ships a compressed prebuilt Wine 10 x86_64 runtime to avoid compilation for normal use.

If the prebuilt runtime cannot start, the fallback build uses:

- Wine 11.0 source
- GNU Bison 3.8.2 source
- Flex 2.6.4 source

The fallback is intentionally best-effort because host build dependencies vary. It builds into the plugin cache, never into the plugin package itself and never installs globally.

Licenses are included under `licenses/`. The original source archives are retained unchanged under `assets/sources/` and include their own licensing and notice files.
