# Portable Wine Runner

Pure skills plugin: no MCP server, no remote service and no bundled application-specific executable.

It provides a prebuilt Wine 10 x86_64 runtime for directly running Windows x64 executables from ChatGPT/Codex-capable local environments. If that runtime is incompatible with the host, the skill can build Wine 11.0 locally from bundled source archives.

## Privacy

The plugin itself has no network server and does not collect or transmit user data. Wine or a Windows program run through Wine may independently access files or networks according to that program's behavior and the host environment.

## Public submission note

The package contains the technical plugin metadata and icon. Public submission still requires the publisher to provide and verify its real developer identity plus public HTTPS URLs for website, support, privacy policy, and terms of service. Those values are intentionally not fabricated in this archive.


## Website

- Project: https://tarekwasfy01.github.io/Wine-for-ChatGPT-Plugin/
- Privacy / Support / Terms: https://tarekwasfy01.github.io/Wine-for-ChatGPT-Plugin/privacy.html


## Marketplace installation

1. Add this repository as a custom plugin marketplace.
2. The marketplace manifest is located at `.agents/plugins/marketplace.json`.
3. Install **Portable Wine Runner** from the marketplace.
4. The marketplace entry points to the stable **v1.0.4** release of this repository.
5. After installation, the bundled Wine runtime can be used to run supported Windows x64 executables in compatible local ChatGPT/Codex environments.

Repository: https://github.com/tarekwasfy01/Wine-for-ChatGPT-Plugin

Current marketplace plugin version: **v1.0.4**
