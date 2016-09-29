if [[ "$SDK_NAME" =~ ([A-Za-z]+) ]]; then
  SDK_BASE_NAME=${BASH_REMATCH[1]}
else
  echo "Invalid SDK name: $SDK_NAME"
  exit 1
fi

if [ "$SDK_BASE_NAME" == "iphonesimulator" ]; then
  echo "Not building shader library for iOS simulator"
  exit 0
fi

echo "Building shader library"

SDK=${SDK_NAME} # iphoneos10.0
METAL_DIRECTORY=${TARGET_TEMP_DIR}/Metal

# Metal version from https://developer.apple.com/library/content/documentation/Metal/Reference/MetalShadingLanguageGuide/comp-opt/comp-opt.html
METAL_VERSION="ios-metal1.1"
COMPILED_FILES=${METAL_DIRECTORY}/*.air
ARCHIVE_OUT=${METAL_DIRECTORY}/Shaders.metal-ar
LIBRARY_OUTPUT=${METAL_LIBRARY_OUTPUT_DIR}/${METAL_LIBRARY_FILE_BASE}.metallib

xcrun -sdk ${SDK} metal-ar rcs ${ARCHIVE_OUT} ${COMPILED_FILES}
xcrun -sdk ${SDK} metallib -o ${LIBRARY_OUTPUT} ${ARCHIVE_OUT}
