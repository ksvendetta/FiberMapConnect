#!/bin/bash

# Create a temporary package.json with the correct structure
echo "Creating temporary package.json for electron-builder..."

# Read current package.json and create a modified version
node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));

// Move electron and electron-builder to devDependencies
if (pkg.dependencies.electron) {
  pkg.devDependencies.electron = pkg.dependencies.electron;
  delete pkg.dependencies.electron;
}
if (pkg.dependencies['electron-builder']) {
  pkg.devDependencies['electron-builder'] = pkg.dependencies['electron-builder'];
  delete pkg.dependencies['electron-builder'];
}

// Add main entry point
pkg.main = 'electron-main.cjs';

// Add description and author
pkg.description = 'Fiber Optic Cable Splicing Management Application';
pkg.author = 'Fiber Splice Team';

// Backup original and write modified
fs.writeFileSync('package.json.backup', JSON.stringify(JSON.parse(fs.readFileSync('package.json', 'utf8')), null, 2));
fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
console.log('Modified package.json created');
"

# Run electron-builder
echo "Building Linux executable..."
npx electron-builder --linux --x64 --config electron-builder.yml

BUILD_RESULT=$?

# Restore original package.json
echo "Restoring original package.json..."
if [ -f "package.json.backup" ]; then
  mv package.json.backup package.json
  echo "Restored original package.json"
fi

if [ $BUILD_RESULT -eq 0 ]; then
  echo "Build completed successfully!"
  echo "Executable can be found in the 'release' directory"
else
  echo "Build failed with exit code $BUILD_RESULT"
fi

exit $BUILD_RESULT
