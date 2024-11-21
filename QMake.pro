QT += core gui qml quick quickwidgets multimedia network sql websockets

CONFIG += c++11
CONFIG += link_pkgconfig

# Required for QAppFramework.
include(QAppFramework/QAppFramework.pri)
include(QAppFramework/QDeployment.pri)
include(Views/Views.pri)
include(Camera/Camera.pri)

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on you compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# To used the 3rd debuger such as dlt
DEFINES += USE_3RD_DEBUG

# Add more folders to ship with the application, here


# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# RESOURCES += DataHMI/DataHMI.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    src/controller/cameraController.h \
    src/controller/controller.h \
    src/controller/layoutController.h \
    src/controller/lookupObjTracksController.h \
    src/controller/playbackController.h \
    src/controller/ptzController.h \
    src/model/mainmodelcamera.h \
    src/model/mainmodellayout.h \
    src/model/mainmodellookupobject.h \
    src/model/mainmodelplayback.h \
    src/model/mainmodelserver.h \
    src/model/ptzPresets.h

SOURCES += main.cpp \
    src/controller/camereController.cpp \
    src/controller/controller.cpp \
    src/controller/layoutController.cpp \
    src/controller/lookupObjTracksController.cpp \
    src/controller/playbackController.cpp \
    src/controller/ptzController.cpp \
    src/model/mainmodelcamera.cpp \
    src/model/mainmodellayout.cpp \
    src/model/mainmodellookupobject.cpp \
    src/model/mainmodelplayback.cpp \
    src/model/mainmodelserver.cpp \
    src/model/ptzPresets.cpp

#QMAKE_POST_LINK += $$quote(cp $$_PRO_FILE_PWD_/RTSP_Oryza.txt $$OUT_PWD)

ios {
    message(Building for IOS)

    # Add version and build info
    QMAKE_TARGET_BUNDLE_PREFIX = com.oryza.vn
    QMAKE_BUNDLE = vms
    DISTFILES +=    ios/pushnotifications.entitlements
    OTHER_FILES += ios/*.storyboard

    CONFIG+=sdk_no_version_check
    CONFIG+=objectivec++
    VERSION = 1.9.1
    QMAKE_LFLAGS += -ld_classic
    QMAKE_INFO_PLIST = $$PWD/ios/Info.plist
    app_launch_screen.files = $$files($$PWD/ios/MyLaunchScreen.storyboard)
    QMAKE_BUNDLE_DATA += app_launch_screen

    RESOURCES += DataHMI/DataHMI.qrc

    # Add privacy file to build
    QMAKE_POST_LINK += $$quote(cp $$_PRO_FILE_PWD_/ios/PrivacyInfo.xcprivacy $$OUT_PWD)
    privacy.files = $$PWD/ios/PrivacyInfo.xcprivacy
    privacy.path =
    QMAKE_BUNDLE_DATA += privacy

    # Add icon
    QMAKE_ASSET_CATALOGS = $$PWD/ios/Assets.xcassets
    QMAKE_ASSET_CATALOGS_APP_ICON = "AppIcon"


    # Add Push notification functionRESOURCES += DataHMI/DataHMI.qrc
    NOTI_ENTITLEMENTS.name = CODE_SIGN_ENTITLEMENTS
    NOTI_ENTITLEMENTS.value = $$PWD/ios/pushnotifications.entitlements
    QMAKE_MAC_XCODE_SETTINGS += NOTI_ENTITLEMENTS
    CONFIG -= bitcode

    # Where the dependencies is located
    MOBILE_DEPENDENCIES = /Users/oryza/Develop/VMS-Mobile-Build/MobileDependencies
    IOS_FRAMEWORK_PATH = /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS17.0.sdk/System/Library/Frameworks
    QMAKE_LFLAGS += -rpath @executable_path/Frameworks

    # Add FFMPEG Static libs: https://github.com/tanersener/mobile-ffmpeg/releases/tag/v4.4.LTS
    # Download file with this name: ffmpeg-kit-full-gpl-4.4.LTS-ios-static-universal
    LIBS *= -L$$MOBILE_DEPENDENCIES/ffmpeg-kit-ios-full-gpl-universal/lib
    STATIC_LIB_FILES = $$files($$MOBILE_DEPENDENCIES/ffmpeg-kit-ios-full-gpl-universal/lib/*.a)
    for(FILE, STATIC_LIB_FILES) {
        BASENAME = $$basename(FILE)
        BASENAME = $$replace(BASENAME,\.a,)
        BASENAME = $$replace(BASENAME,lib,)
        LIBS += -l$$BASENAME
    }

    INCLUDEPATH += \
        $$MOBILE_DEPENDENCIES/BoostInclude \
        $$MOBILE_DEPENDENCIES/opencv2.framework \
        $$MOBILE_DEPENDENCIES/OpenSSL/include \
        $$MOBILE_DEPENDENCIES/ffmpeg-kit-ios-full-gpl-universal/include

    # Add openCV2 Framework
    LIBS += -F$$MOBILE_DEPENDENCIES -framework opencv2
    QMAKE_LFLAGS += -F$$MOBILE_DEPENDENCIES/opencv2.framework

    LIBS += -lz -lbz2.1.0 -liconv -lc++
    LIBS += -framework VideoToolbox -framework CoreMotion -framework Accelerate
    LIBS += -framework UserNotifications

# Thay đổi option để build cho ios hoặc SimiOS
    # LIBS += -L$$MOBILE_DEPENDENCIES/OpenSSL/lib/iOS -lssl -lcrypto
    LIBS += -L$$MOBILE_DEPENDENCIES/OpenSSL/lib/SimiOS -lssl -lcrypto

#    embedFramework.files = $$IOS_FRAMEWORK_PATH/VideoToolbox.framework
#    embedFramework.path = Frameworks
#    QMAKE_BUNDLE_DATA += embedFramework
#    LIBS += -F$$MOBILE_DEPENDENCIES/libwebp-ios-framework -framework WebP
#    QMAKE_LFLAGS += -F$$MOBILE_DEPENDENCIES/libwebp-ios-framework/WebP.framework
#    LIBS += -lz -lbz2.1.0 -liconv -lc++
#    LIBS += -F$$IOS_FRAMEWORK_PATH -framework Accelerate -framework CoreMotion -framework VideoToolbox
#    QMAKE_LFLAGS += -F$$IOS_FRAMEWORK_PATH/Accelerate.framework -F$$IOS_FRAMEWORK_PATH/CoreMotion.framework -F$$IOS_FRAMEWORK_PATH/VideoToolbox.framework
#    LIBS += -F$$MOBILE_DEPENDENCIES/ffmpeg-kit-full-4/libavcodec.xcframework/ios-arm64_x86_64-simulator -framework libavcodec
#    LIBS += -F$$MOBILE_DEPENDENCIES/ffmpeg-kit-full-4 -framework libavcodec
#    QMAKE_LFLAGS += -F$$MOBILE_DEPENDENCIES/ffmpeg-kit-full-4/libavcodec.xcframework

} else:unix:android {
    message(Building for Android)
    ANDROID_EXTRA_LIBS =
    CONFIG += shared
    QMAKE_CXXFLAGS += -fPIC
    QMAKE_LFLAGS += -Wl,-Bsymbolic
    QT += androidextras
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
    RESOURCES += DataHMI/DataHMI_Android.qrc

    OTHER_FILES += \
        android/src/org/qtproject/notification/NotificationClient.java \
        android/AndroidManifest.xml
    # Should not change QT_ARCH, this will be used in many internal QT File
    BUILD_ARCH = $$QT_ARCH
    ! contains(ANDROID_ABIS, $$QT_ARCH) {
        message(QT_ARCH not in ANDROID_ABIS)
        BUILD_ARCH = $$first(ANDROID_ABIS)
        message(BUILD_ARCH change to $$BUILD_ARCH)
    }

    OPENCV_SRC_DIR=$$PWD/opencv-ffmpeg-android-build-env/opencv
    FFMPEG_SRC_DIR=$$PWD/opencv-ffmpeg-android-build-env/FFmpeg
    BOOST_SRC_DIR=$$PWD/boost-android-build-env/build/out
    OPENCV_BUILD_DIR = $$OPENCV_SRC_DIR/build-android-$$BUILD_ARCH
    FFMPEG_BUILD_DIR = $$FFMPEG_SRC_DIR/build-android-$$BUILD_ARCH
    BOOST_BUILD_DIR = $$BOOST_SRC_DIR/$$BUILD_ARCH
    ANDROID_HOME = $$(ANDROID_HOME)
    OPENSSL_BUILD_DIR=$$ANDROID_HOME/android-openssl/ssl_1.1

    contains(BUILD_ARCH, x86) {
        BOOST_BUILD_ARCH_SUFFIX = x32
    } else:contains(BUILD_ARCH, x86_64) {
        BOOST_BUILD_ARCH_SUFFIX = x64
    } else:contains(BUILD_ARCH, armeabi-v7a) {
        BOOST_BUILD_ARCH_SUFFIX = a32
    } else {
        BOOST_BUILD_ARCH_SUFFIX = a64
    }

    INCLUDEPATH += \
        $$OPENCV_BUILD_DIR/install/sdk/native/jni/include \
        $$FFMPEG_BUILD_DIR/include \
        $$BOOST_BUILD_DIR/include/boost-1_78 \
        $$OPENSSL_BUILD_DIR/include \

    LIBS += -L$$OPENSSL_BUILD_DIR/$$BUILD_ARCH -lssl -lcrypto

    ANDROID_EXTRA_LIBS += \
        $$OPENSSL_BUILD_DIR/$$BUILD_ARCH/libcrypto_1_1.so \
        $$OPENSSL_BUILD_DIR/$$BUILD_ARCH/libssl_1_1.so

    #LIBS += -L$$BOOST_BUILD_DIR/lib -lboost_regex-clang-mt-$$BOOST_BUILD_ARCH_SUFFIX-1_78

    LIBS += -L$$FFMPEG_BUILD_DIR/lib -lavcodec -lavutil

    LIBS += \
        -L$$OPENCV_BUILD_DIR/install/sdk/native/libs/$$BUILD_ARCH \
        -lopencv_world \
        -lopencv_img_hash
    ANDROID_EXTRA_LIBS += \
        $$OPENCV_BUILD_DIR/install/sdk/native/libs/$$BUILD_ARCH/libopencv_world.so \
        $$OPENCV_BUILD_DIR/install/sdk/native/libs/$$BUILD_ARCH/libopencv_img_hash.so
} else {
    message(Not building for Android and IOS)
    PKGCONFIG += opencv4
    LIBS += `pkg-config --cflags --libs opencv4`
    INCLUDEPATH += $$PWD/../../../../usr/include/opencv4
    DEPENDPATH += $$PWD/../../../../usr/include/opencv4
    INCLUDEPATH += /usr/local/include
    LIBS += -L/usr/local/lib -lavformat -lavcodec -lavutil
}

qtcAddDeployment()
