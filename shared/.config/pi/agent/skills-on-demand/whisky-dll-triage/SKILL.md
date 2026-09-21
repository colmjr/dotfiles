---
name: whisky-dll-triage
description: Diagnose and fix DLL-layer failures for Windows games running in Whisky (Wine) bottles on macOS. Covers Unity 0xc06d007e delay-load crashes (d3d12 disabled by DXMT backend) and "DX11 could not switch resolution" caused by mismatched DXMT/DXVK d3d11/dxgi pairs. Use when a game in a Whisky bottle crashes at launch, Wine shows a Program Error dialog, or a Unity game fails to switch resolution.
---

# Whisky DLL triage

Fixes for games in Whisky bottles (fork `com.franke.Whisky`, app version 3.7.x, WhiskyWine based on wine-11). Both known issues are DLL-layer problems, not game bugs and not display problems.

## Where things live

- Bottles: `~/Library/Containers/com.franke.Whisky/Bottles/<UUID>/` (the `WhiskyCmd list` output may print `~/Library/Containers/Whisky/...`, the real path has `com.franke.` in it)
- Bottle config: `<bottle>/Metadata.plist`, per-program settings: `<bottle>/Program Settings/<name>-<hash>.plist`
- Wine runtime: `~/Library/Application Support/com.franke.Whisky/Libraries/Wine/bin/wine64`
- DX libraries: `~/Library/Application Support/com.franke.Whisky/Libraries/{DXMT,DXVK}/{x64,x32}/`
- Whisky CLI: `/Applications/Whisky.app/Contents/Resources/WhiskyCmd` (subcommands: `list`, `run <bottle> <path> [--command] [--follow]`, `launch <appid> [--bottle <name>]`, `shellenv`)
- Whisky logs: `~/Library/Logs/com.franke.Whisky/<timestamp>.log` (one per spawned process; game stdout is only captured when the game is spawned by Whisky directly, not when Steam spawns it)
- Unity games: player log at `<bottle>/drive_c/users/<user>/AppData/LocalLow/<Publisher>/<Game>/Player.log`, crash minidumps at `.../AppData/Local/Temp/<Publisher>/<Game>/Crashes/Crash_*/`

## WARNING: Metadata.plist is fragile

If Whisky (or WhiskyCmd) fails to decode `Metadata.plist`, it silently rewrites it with defaults, wiping bottle name, backend, windows version, etc. Always `cp Metadata.plist /tmp/backup` before editing it. Known-good restore values for a DXMT bottle: `graphicsConfig.backend = "dxmt"`, `wineConfig.windowsVersion = "win11"`, `launcherConfig.compatibilityMode = true`.

## Issue 1: Unity game crashes at launch, exception 0xc06d007e

`0xc06d007e` = Windows DLL_NOT_FOUND, raised by the MSVC delay-load helper. The backtrace shows `kernelbase` called from `unityplayer`. It means Unity delay-loaded a DLL that Wine refused to load.

The known instance: `UnityPlayer.dll` delay-imports exactly one DLL, `d3d12.dll`, at engine startup, even if the game will render with D3D11. Bottles with the DXMT backend get `d3d12=` (disabled) in their managed DLL overrides because DXMT only handles D3D9-11. The delay-load of a disabled DLL throws, unhandled, before any window appears.

Confirm which DLL is delay-loaded (read the PE delay-import table off disk, no debugger needed):

```bash
uv run --with pefile python -c "
import pefile
pe = pefile.PE('<path to>/UnityPlayer.dll')
for e in getattr(pe, 'DIRECTORY_ENTRY_DELAY_IMPORT', []): print(e.dll.decode())
"
```

### The fix (two layers, both needed)

This Wine build strips `WINEDLLOVERRIDES` from the Windows environment block, so Steam-spawned games do NOT inherit the env var. They fall back to registry overrides. Therefore:

1. Bottle config, so Whisky generates the right override from now on. In `Metadata.plist`:
   ```bash
   plutil -replace customDLLOverrides -json '[{"dllName":"d3d12","mode":"b"}]' <bottle>/Metadata.plist
   ```
   The `mode` values are Wine short codes: `"b"`, `"n"`, `"n,b"`, `"b,n"`, `""` (disabled). Any other string breaks decoding and triggers the defaults rewrite, see warning above. Custom overrides take precedence over the managed DXMT ones. Verify with `WhiskyCmd run <bottle> <path> --command | tr ' ' '\n' | grep WINEDLLOVERRIDES`.

2. Stale per-app registry entry. Whisky writes `HKCU\Software\Wine\AppDefaults\<Program>.exe\DllOverrides` the first time a program is launched. If that was written while d3d12 was disabled, it stays stale (Steam launches never regenerate it). Check and fix:
   ```bash
   WINEPREFIX=<bottle> wine64 reg query "HKCU\Software\Wine\AppDefaults\How to Fish.exe\DllOverrides"
   WINEPREFIX=<bottle> wine64 reg add "HKCU\Software\Wine\AppDefaults\How to Fish.exe\DllOverrides" /v d3d12 /d "b" /f
   ```
   Precedence is: `WINEDLLOVERRIDES` env > AppDefaults > global `HKCU\Software\Wine\DllOverrides`.

After the fix, `Player.log` shows `d3d12: failed to create D3D12 device (0x80004002)` followed by a D3D11 fallback. That line means success: the DLL loaded, device creation failed as expected under DXMT, and Unity moved on.

Note: if Steam was already running when the fix was applied, restart it (its children inherit its process environment). When in doubt, `wineserver -k` the bottle and relaunch Steam through Whisky.

## Issue 2: "DX11 could not switch resolution (1920x1080 fs=1 hz=0/1)"

Misleading error: the real cause is mismatched DirectX translation DLLs, any resolution fails, windowed or fullscreen. The Whisky fork's DXVK package ships only `d3d11.dll` and `d3d10core.dll`, no `dxgi.dll`. A DXVK sync overwrites d3d11/d3d10core but leaves a stale DXMT `dxgi.dll` behind. The mismatched pair breaks swapchain creation and every resolution switch.

Diagnose (two minutes):

```bash
B=<bottle path>; L=~/Library/Application\ Support/com.franke.Whisky/Libraries
md5 -q "$B/drive_c/windows/system32/d3d11.dll" "$B/drive_c/windows/system32/dxgi.dll" "$B/drive_c/windows/system32/d3d10core.dll"
md5 -q "$L/DXMT/x64/d3d11.dll" "$L/DXMT/x64/dxgi.dll" "$L/DXMT/x64/d3d10core.dll"
md5 -q "$L/DXVK/x64/d3d11.dll" "$L/DXVK/x64/d3d10core.dll"   # DXVK has no dxgi.dll
```

If the bottle's DLLs don't all come from the same library folder, that's the bug. Check `syswow64` against the `x32` folders the same way.

Fix (backend stays on whatever the bottle is configured for, sync the matching set):

```bash
cp "$L/DXMT/x64/"{d3d10core,d3d11,dxgi}.dll "$B/drive_c/windows/system32/"
cp "$L/DXMT/x32/"{d3d10core,d3d11,dxgi}.dll "$B/drive_c/windows/syswow64/"
```

Make sure `graphicsConfig.backend` in Metadata.plist matches the DLL set you copied, otherwise the app re-breaks the bottle on next launch.

## Useful manual run recipe (bypasses Steam)

Running a Steam game exe directly with wine needs `SteamAppId`/`SteamGameId` or SteamAPI_Init fails and the game exits (code 53, silently spawning a new steam.exe). Working invocation:

```bash
cd "<game dir>" && WINEDEBUG=-all SteamAppId=<id> SteamGameId=<id> \
WINEDLLOVERRIDES="d3d10core=n,b;d3d11=n,b;d3d12=b;dxgi=n,b;winemetal=b" \
WINEMSYNC=1 WINEESYNC=1 WINEFSYNC=0 WINE_CPU_TOPOLOGY=8:8 LC_ALL=en_US.UTF-8 \
WINEPREFIX=<bottle> <wine64> "Game.exe"   # append -force-d3d11 etc for Unity tests
```

Use `WINEDEBUG=+loaddll,+seh` to capture module loads and exception parameters. Note `wine start /unix` detaches and loses stdout; run the exe directly to capture output.

## Red herrings to skip

- Monitor/mode switching on the macOS side: healthy, the failure is in the D3D translation layer.
- Game resolution prefs, Unity registry keys, virtual desktop: dead ends for issue 2.
- Whisky app version: the bundled Wine runtime did not change between 3.6.x and 3.7.x.
- `dstorage.dll`/`dstoragecore.dll` being present in the game folder: red herring for issue 1, the delay-load failure is d3d12.
