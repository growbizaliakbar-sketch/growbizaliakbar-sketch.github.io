# RUNBOOK — Sabzi Fresh AAB via GitHub Actions
Prepared 22 Oct ~20:25 PKT by subagent. Everything is staged; only approval-gated steps remain.

## Why this runbook exists
All cloud routes are blocked from the subagent sandbox:
1. **MCP `create_repository` / `push_files`**: every write needs an approval card; in subagent context approvals time out (`approval_expired`, tried 2x). In main chat the USER can approve them.
2. **git SSH**: egress proxy denies it — `muse: Outbound SSH is turned off for this assistant` (verified).
3. **`gh`**: not authenticated. **PAT**: none in workspace; vault retrieval not authorized by task.

## Root cause of the local-build failure (for the record)
- Java's `user.home` comes from passwd (`/root`), NOT `$HOME` (`/home/hatch`). Gradle therefore used `/root/.gradle`, silently ignoring all of `/home/hatch/.gradle` (proxy `gradle.properties`, `init.d` scripts, caches). Fixed with symlink `/root/.gradle -> /home/hatch/.gradle`.
- **Deeper, fatal**: the sandbox intercepts ALL TCP from Java processes — even localhost. The Gradle daemon listens on 127.0.0.1 and the client gets `muse: Other TCP connections is turned off for this assistant`. Daemon communication can NEVER work here. Local AAB build is fundamentally impossible in this sandbox. (Also explains the 21–22 Oct failures.)

## Staged payload (all in ~/workspace/sabzi-app/)
- `cloud-build-repo/` — 33 text files: Flutter source (lib/, android/ text files, pubspec), `.github/workflows/build-aab.yml`, `.github/android-icons.b64.json` (5 launcher icons as base64), `.gitignore`, `README.md`.
  - `android/settings.gradle.kts` already patched (sandbox `file:///.../maven-repo` lines removed).
  - `android/local.properties` deliberately excluded (workflow generates it on the runner).
- `cloud-build-push-payload.json` — ready-made `push_files` arguments (owner/repo/branch/message/files), 198 KB.

## The workflow (what it does on ubuntu-latest)
1. Checkout, setup Java 17 (Temurin), Flutter 3.47.7.
2. Downloads 25 binary assets (17 product JPGs, 4 shop JPGs, logo.webp, 3 Sora TTFs) from the live web preview `https://growbizaliakbar-sketch.github.io/sabzi-app/assets/assets/...` (all URLs verified 200).
3. Decodes the 5 launcher icons from `.github/android-icons.b64.json` into `android/app/src/main/res/mipmap-*/ic_launcher.png`.
4. Writes `android/local.properties` (flutter.sdk + sdk.dir from the runner).
5. `flutter pub get` → `flutter build appbundle --release` (debug signing; user re-signs at Play upload).
6. Uploads `app-release.aab` as workflow artifact AND creates a public GitHub Release `aab-v2-run-<N>` with the AAB attached (`permissions: contents: write`, `gh` pre-authed on runners).

## Steps for the parent agent (main chat)
1. **Create repo** (user approves the card):
   `/opt/hatch/bin/github call-tool --name create_repository --arguments-json '{"name":"sabzi-fresh-app","description":"Sabzi Fresh - Sadam Hussain Sabzi Farosh customer app (Flutter). Release AABs built via GitHub Actions.","private":false,"autoInit":false}'`
2. **Push source** (user approves the card):
   `/opt/hatch/bin/github call-tool --name push_files --arguments-json "$(cat ~/workspace/sabzi-app/cloud-build-push-payload.json)"`
   (Push triggers the workflow automatically via `on: push`.)
3. **Monitor**: https://github.com/growbizaliakbar-sketch/sabzi-fresh-app/actions (typical run 10–25 min).
4. **On green**: download the AAB from the release page
   `https://github.com/growbizaliakbar-sketch/sabzi-fresh-app/releases` (public asset, no auth needed),
   verify it's a valid zip ~50MB, copy to `~/workspace/sabzi-app/sabzi-fresh-v2.aab`.
5. **Deliver**: `/opt/hatch/bin/remote-storage upload-file --path ~/workspace/sabzi-app/sabzi-fresh-v2.aab` → give user the URL + expires_at.
6. **On workflow failure**: read the failed step's logs in the Actions UI, fix, push fix (one retry).

## Cleanup notes
- The `/root/.gradle -> /home/hatch/.gradle` symlink and `~/workspace/sabzi-app/fwdproxy-8888.js` are sandbox-local helpers; harmless to keep.
- `gradle-wrapper.properties` in the source was reverted to the original https URL (no local hacks left in the staged tree).
