#!/bin/bash


HHROOT="https://github.com/holzschu"
IOS_SYSTEM_VER="2.2"

# Python-3.7.1
echo "Downloading Python 3.7.1"
curl -OL https://www.python.org/ftp/python/3.7.1/Python-3.7.1.tgz
tar -xvzf Python-3.7.1.tgz
rm Python-3.7.1.tgz
echo "Downloading ios_system.framework"
(cd Frameworks
curl -OL $HHROOT/ios_system/releases/download/v$IOS_SYSTEM_VER/smallRelease.tar.gz
( tar -xzf smallRelease.tar.gz --strip 1 && rm smallRelease.tar.gz ) || { echo "ios_system failed to download"; exit 1; }
)
echo "Downloading header file:"
curl -OL $HHROOT/ios_system/releases/download/v$IOS_SYSTEM_VER/ios_error.h
echo "Downloading libffi-3.2.1"
curl -OL https://www.mirrorservice.org/sites/sourceware.org/pub/libffi/libffi-3.2.1.tar.gz
tar -xvzf libffi-3.2.1.tar.gz
rm libffi-3.2.1.tar.gz
echo "Applying patch to libffi-3.2.1:"
(cd libffi-3.2.1 ; patch -p 1 < ../libffi-3.2.1_patch ; cd ..)
echo "Compiling libffi-3.2.1:"
(cd libffi-3.2.1 ;  xcodebuild -project libffi.xcodeproj -target libffi-iOS -sdk iphoneos -arch arm64 -configuration Debug -quiet; mv build/Debug-iphoneos/libffi.a .. ; cd ..)
echo "Applying patch to Python-3.7.1"
(cd Python-3.7.1 ; patch -p 1 < ../Python.patch ; cd ..)

echo "All done. Now open Python_ios.xcodeproj and compile."

