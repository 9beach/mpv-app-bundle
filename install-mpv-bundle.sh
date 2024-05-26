#!/bin/bash

if [ -d /Applications/mpv.app ]; then
	echo "/Applications/mpv.app is already installed."
	echo "Please remove it and try again."
	exit 1
fi

APP_NAME="mpv.app"
APP_PATH="/Applications/$APP_NAME"
MPV_PATH="$(which mpv)"
ICON_PATH="mpv.icns"

if ! [ -f "$ICON_PATH" ]; then
	echo "Please set ICON_PATH correctly."
	exit 1
fi

mkdir -p "$APP_PATH/Contents/MacOS"
mkdir -p "$APP_PATH/Contents/Resources"

cat <<EOL > "$APP_PATH/Contents/MacOS/mpv-wrapper"
#!/bin/bash

$MPV_PATH --player-operation-mode=pseudo-gui "\$@"
EOL
chmod +x "$APP_PATH/Contents/MacOS/mpv-wrapper"

cat <<EOL > "$APP_PATH/Contents/Info.plist"
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>mpv-wrapper</string>
    <key>CFBundleIdentifier</key>
    <string>org.mpv-player.macos</string>
    <key>CFBundleName</key>
    <string>mpv</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundleIconFile</key>
    <string>mpv.icns</string>
    <key>LSArchitecturePriority</key>
    <array>
        <string>arm64</string>
        <string>x86_64</string>
    </array>
    <key>CFBundleDocumentTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeName</key>
            <string>Audio Document</string>
            <key>CFBundleTypeRole</key>
            <string>Viewer</string>
            <key>LSHandlerRank</key>
            <string>Owner</string>
            <key>LSItemContentTypes</key>
            <array>
                <string>public.audio</string>
            </array>
        </dict>
        <dict>
            <key>CFBundleTypeName</key>
            <string>Video Document</string>
            <key>CFBundleTypeRole</key>
            <string>Viewer</string>
            <key>LSHandlerRank</key>
            <string>Owner</string>
            <key>LSItemContentTypes</key>
            <array>
                <string>public.video</string>
                <string>public.movie</string>
            </array>
        </dict>
    </array>
</dict>
</plist>
EOL

cp "$ICON_PATH" "$APP_PATH/Contents/Resources/mpv.icns"

echo "$APP_NAME has been created and moved to Applications folder."

