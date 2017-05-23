if [[ "$SDK_NAME" =~ ([A-Za-z]+) ]]; then
  SDK_BASE_NAME=${BASH_REMATCH[1]}
else
  echo "Invalid SDK name: $SDK_NAME"
  exit 1
fi

if [ "$SDK_BASE_NAME" == "iphonesimulator" ]; then
  echo "Not compiling shader for iOS simulator"
  exit 0
fi

# Compiles a single shader
SDK=${SDK_NAME} # iphoneos10.0
METAL_FILE="${INPUT_FILE_PATH}"
FILE_BASE="${INPUT_FILE_BASE}"
METAL_DIRECTORY="${TARGET_TEMP_DIR}/Metal"
echo "Compiling Metal shader ${INPUT_FILE_NAME}"

# Metal version from https://developer.apple.com/library/content/documentation/Metal/Reference/MetalShadingLanguageGuide/comp-opt/comp-opt.html
METAL_VERSION="ios-metal1.1"
COMPILED_FILE="${METAL_DIRECTORY}/${FILE_BASE}.air"

xcrun -sdk ${SDK} metal -Wall -Wextra -std=${METAL_VERSION} "${METAL_FILE}" -o "${COMPILED_FILE}"
