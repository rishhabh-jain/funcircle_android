#!/bin/bash

echo "========================================="
echo "Getting SHA-1 Fingerprints for Android"
echo "========================================="
echo ""

echo "📱 DEBUG SHA-1 (for development):"
echo "-----------------------------------"
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android 2>/dev/null | grep "SHA1:"
echo ""

echo "📦 RELEASE SHA-1 (for production):"
echo "-----------------------------------"
if [ -f "/Users/sanchitjain/upload-keystore.jks" ]; then
    keytool -list -v -keystore /Users/sanchitjain/upload-keystore.jks -alias upload -storepass Rishabh@123 2>/dev/null | grep "SHA1:"
else
    echo "Release keystore not found at expected location"
fi
echo ""

echo "========================================="
echo "⚠️  IMPORTANT: Copy BOTH SHA-1 values above"
echo "and add them to Firebase Console"
echo "========================================="
