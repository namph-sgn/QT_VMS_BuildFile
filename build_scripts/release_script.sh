#!/bin/bash

set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

export WORK_DIR=/home/nx_open_mobile
export BUILD_DIR=/home/build-mobile-Release
export FASTLANE_CICD_DIR=/home/fastlane-cicd
cd $WORK_DIR/build_scripts && source .env

echo We are in $WORKDIR not $WORK_DIR
echo The system is $BUILD_SYSTEM

mkdir -p $BUILD_DIR
cd $BUILD_DIR

"$QTDIR/bin/qmake" $WORK_DIR/RTSP_Mobile.pro -spec android-clang CONFIG+=qtquickcompiler 'ANDROID_ABIS=armeabi-v7a arm64-v8a x86 x86_64' && "$ANDROID_NDK_ROOT/prebuilt/linux-x86_64/bin/make" -f $BUILD_DIR/Makefile qmake_all
"$ANDROID_NDK_ROOT/prebuilt/linux-x86_64/bin/make" -j $(nproc)
"$ANDROID_NDK_ROOT/prebuilt/linux-x86_64/bin/make" INSTALL_ROOT=$BUILD_DIR/android-build install && cd $BUILD_DIR && $ANDROID_NDK_ROOT/prebuilt/linux-x86_64/bin/make INSTALL_ROOT=$BUILD_DIR/android-build install
"$QTDIR/bin/androiddeployqt" --input $BUILD_DIR/android-RTSP_Mobile-deployment-settings.json --output $BUILD_DIR/android-build --android-platform android-31 --jdk /usr/lib/jvm/java-17-openjdk-amd64 --verbose --gradle --aab --jarsigner --release --sign $QT_ANDROID_KEYSTORE_PATH $QT_ANDROID_KEYSTORE_ALIAS --storepass $QT_ANDROID_KEYSTORE_STORE_PASS

eval "$(rbenv init -)"

cd $FASTLANE_CICD_DIR
bundle exec fastlane run update_fastlane
bundle exec fastlane run validate_play_store_json_key json_key:./example_json.json
cp $BUILD_DIR/android-build/build/outputs/bundle/release/android-build-release.aab ./
bundle exec fastlane supply --aab ./android-build-release.aab --track internal --skip_upload_apk true --skip_upload_metadata true --skip_upload_changelogs true --skip_upload_images true --skip_upload_screenshots true --timeout 1000 --json_key ./example_json.json --verbose