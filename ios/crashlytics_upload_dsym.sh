#!/bin/sh

# Firebase Crashlytics dSYM Upload Script
# This script automatically uploads dSYM files to Firebase Crashlytics after each build

# Only upload for Release builds to avoid spam during development
if [ "${CONFIGURATION}" != "Release" ]; then
    echo "Skipping Crashlytics dSYM upload for non-Release build"
    exit 0
fi

# Path to the Crashlytics upload-symbols script
CRASHLYTICS_SCRIPT="${PODS_ROOT}/FirebaseCrashlytics/upload-symbols"

# Check if the script exists
if [ ! -f "$CRASHLYTICS_SCRIPT" ]; then
    echo "Warning: FirebaseCrashlytics upload-symbols script not found at ${CRASHLYTICS_SCRIPT}"
    echo "Make sure FirebaseCrashlytics pod is installed"
    exit 0
fi

# Path to dSYM files
DSYM_PATH="${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}"

# Upload dSYMs if they exist
if [ -d "$DSYM_PATH" ]; then
    echo "Uploading dSYM to Firebase Crashlytics: ${DSYM_PATH}"
    "${CRASHLYTICS_SCRIPT}" -gsp "${PROJECT_DIR}/Runner/GoogleService-Info.plist" -p ios "${DSYM_PATH}"
    echo "dSYM upload completed"
else
    echo "Warning: dSYM not found at ${DSYM_PATH}"
fi
