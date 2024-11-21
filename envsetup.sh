#!/bin/bash

shell_dir=$(pwd)

echo $shell_dir

source ./build_scripts/sudo_askpass_setup.sh
./build_scripts/docker_installer.sh
git submodule update --init --recursive

echo "Please provide your NDK path. Please have version larger than 22."
echo "Example: /home/oryza/Android/Sdk/ndk/22.1.7171670"
read -s -p "Enter your NDK path: " ORYZA_NDK_PATH
echo

cd $shell_dir/opencv-ffmpeg-android-build-env/

need_to_build_opencv=false
for dir in \
        "$(pwd)/FFmpeg" \
        "$(pwd)/opencv" \
        "$(pwd)/opencv_contrib"
do
    if ! [ -d "$dir" ]; then
        need_to_build_opencv=true
        break
    else
        echo "$dir is present in Opencv build folder"
    fi
done

if [ "$need_to_build_opencv" == true ]; then
    echo "Some libs are not built yet, removing and build opencv from scratch"
    sudo -A ./build.sh
else
    echo "OpenCV already built, skipping..."
fi

cd $shell_dir/boost-android-build-env/
if ! [ -d "$(pwd)/build/out" ]; then
    echo "Building Boost"
    sudo -A ./build-android.sh --boost=1.78.0 $ORYZA_NDK_PATH
else 
    echo "Build folder $(pwd)/build/out present, not building Boost"
fi
cd $shell_dir
