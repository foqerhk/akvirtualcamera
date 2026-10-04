# akvirtualcamera (foqerhk / RunEverything fork)

This repository is a **modified fork** of:

**[webcamoid/akvirtualcamera](https://github.com/webcamoid/akvirtualcamera)**  
Upstream tag / base: **`9.4.0`**  
Upstream license: **GPL-3.0** (see `COPYING`)

It is used by RunEverything / KoKo as the macOS **Camera Extension** backend for the virtual webcam named **「KoKo Phone Camera」**.

> This is **not** the official Webcamoid project. Please report upstream bugs to [webcamoid/akvirtualcamera](https://github.com/webcamoid/akvirtualcamera/issues). Report fork-specific issues here.

## Why this fork exists

On modern macOS, browsers / Zoom / Meet discover cameras via **CMIO Camera Extension**. Upstream `9.4.0` CMIO Extension init order left the `CMIOExtensionProvider` empty, so clients often only saw the built-in FaceTime camera even when devices existed in prefs. Sandboxed extensions also need an explicit prefs exception to read the assistant preferences domain, and install failures for missing System Extension capability benefit from a clearer alert.

## Changes vs upstream `9.4.0`

### 1. Camera Extension: create provider before `addDevice`

**Files:**
- `cmio/Extension/src/extensionprovidersource.mm`
- `cmio/Extension/src/main.mm`

**Upstream behavior:** devices were created first while `provider == nil`, then `main.mm` created the `CMIOExtensionProvider` and assigned it afterward. Devices registered too early were never attached to a live provider.

**This fork:** create `CMIOExtensionProvider` inside `ExtensionProviderSource` `init` **before** `addDevice`, then call `startServiceWithProvider:` with `providerSource.provider` (same order as Apple sample / VCamCX).

### 2. Default device + RGB32 formats when prefs are empty

**File:** `cmio/Extension/src/extensionprovidersource.mm`

- If `IpcBridge` returns no devices (prefs missing / sandbox cannot read them), register a fallback device:
  - id: `KoKoPhoneCam0`
  - description: `KoKo Phone Camera`
  - format: **ARGB / RGB32** `1280×720@30`
- If a device exists but has an empty format list, push the same RGB32 default (RGB24 often yields empty streams in CMIO clients).

### 3. Clearer System Extension install error UI

**File:** `cmio/ExtensionDelegate/src/appdelegate.mm`

When install fails with a missing `system-extension.install` entitlement (or `OSSystemExtensionErrorCodeMissingEntitlement`), show a clearer alert that the host App ID needs the System Extension capability and a matching provisioning profile, instead of only the raw `NSAlert alertWithError:`.

### 4. Extension sandbox prefs access (signing entitlements)

Upstream does not ship the host/extension entitlement plists used for distribution. When packaging a sandboxed Camera Extension, grant a temporary shared-preference exception for the assistant domain `io.github.webcamoid.AkVirtualCamera.AkVCamAssistant` (and the usual System Extension install entitlement on the host). Keep the organization / prefs domain aligned with that assistant id so `AkVCamManager`-created devices remain visible to the extension.

## Upstream features / build

Unchanged relative to Webcamoid unless listed above. For general build/install docs, see the [upstream wiki](https://github.com/webcamoid/akvirtualcamera/wiki).

## License

GPL-3.0, same as upstream (`COPYING`).
