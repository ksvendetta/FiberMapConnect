# Building Windows Executable for Fiber Splice Manager

## Prerequisites
- Windows computer
- Node.js installed (v18 or higher)
- Git installed

## Steps to Build

### 1. Download the Project
Download all project files to your Windows computer.

### 2. Install Dependencies
Open Command Prompt or PowerShell in the project folder and run:
```bash
npm install
```

### 3. Modify package.json
You need to make these changes to `package.json`:

**Add these fields after the "license" line:**
```json
"main": "electron-main.cjs",
"description": "Fiber Optic Cable Splicing Management Application",
"author": "Your Name",
```

**Move electron packages:**
In package.json, move `"electron"` and `"electron-builder"` from `"dependencies"` to `"devDependencies"`.

**Add scripts:** Add these to the "scripts" section:
```json
"electron": "electron .",
"electron:build": "npm run build && electron-builder --win --x64"
```

### 4. Build the Application
Run these commands:
```bash
npm run build
npm run electron:build
```

### 5. Find Your Executable
The Windows executable will be created in the `release` folder:
- **Installer**: `release/Fiber Splice Manager Setup x.x.x.exe`
- **Portable**: `release/win-unpacked/Fiber Splice Manager.exe`

## Alternative: Quick Portable Build

For a faster portable executable (no installer), update `electron-builder.yml`:

Change the `win.target` section to:
```yaml
win:
  target:
    - target: portable
      arch:
        - x64
```

Then run:
```bash
npm run build
npm run electron:build
```

The portable .exe will be in: `release/Fiber Splice Manager.exe`

## Troubleshooting

### Error: "electron is only allowed in devDependencies"
Make sure you moved electron and electron-builder to devDependencies as described in step 3.

### Build takes a long time
The first build downloads Electron (125 MB) and rebuilds native modules. Subsequent builds are faster.

### Missing icon error
Make sure the icon file exists at `attached_assets/image_1760814059676.png`
