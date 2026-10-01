# Third-party software

This plugin redistributes or includes source archives for third-party open-source software.

## Wine

- Prebuilt runtime: Wine 10 x86_64 runtime files.
- Source fallback: Wine 11.0 source archive.
- License: GNU Lesser General Public License (LGPL), as distributed by the Wine project.
- Included license files: `licenses/WINE-LGPL-2.1.txt`, `licenses/WINE-LICENSE.txt`.
- The bundled Wine source archive contains upstream copyright, authorship and additional bundled-library notices/licenses.

## GNU Bison 3.8.2

Bundled only as a source-build dependency for the Wine fallback. Its upstream copying terms are preserved in `licenses/BISON-COPYING.txt` and inside the unchanged source archive.

## Flex 2.6.4

Bundled only as a source-build dependency for the Wine fallback. Its upstream copying terms are preserved in `licenses/FLEX-COPYING.txt` and inside the unchanged source archive.

No SWC executable or application-specific Windows executable is bundled in this plugin.
