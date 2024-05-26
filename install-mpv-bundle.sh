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
            <string>public.ogg</string>
            <string>public.flac</string>
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
            <string>public.mkv</string>
            <string>public.flv</string>
            <string>public.webm</string>
        </array>
    </dict>
</array>
<key>UTExportedTypeDeclarations</key>
<array>
    <dict>
        <key>UTTypeIdentifier</key>
        <string>public.mkv</string>
        <key>UTTypeDescription</key>
        <string>MKV Video</string>
        <key>UTTypeConformsTo</key>
        <array>
            <string>public.movie</string>
        </array>
        <key>UTTypeTagSpecification</key>
        <dict>
            <key>public.filename-extension</key>
            <array>
                <string>mkv</string>
            </array>
            <key>public.mime-type</key>
            <array>
                <string>video/x-matroska</string>
            </array>
        </dict>
    </dict>
    <dict>
        <key>UTTypeIdentifier</key>
        <string>public.ogg</string>
        <key>UTTypeDescription</key>
        <string>OGG Audio</string>
        <key>UTTypeConformsTo</key>
        <array>
            <string>public.audio</string>
        </array>
        <key>UTTypeTagSpecification</key>
        <dict>
            <key>public.filename-extension</key>
            <array>
                <string>ogg</string>
            </array>
            <key>public.mime-type</key>
            <array>
                <string>audio/ogg</string>
            </array>
        </dict>
    </dict>
    <dict>
        <key>UTTypeIdentifier</key>
        <string>public.flv</string>
        <key>UTTypeDescription</key>
        <string>FLV Video</string>
        <key>UTTypeConformsTo</key>
        <array>
            <string>public.movie</string>
        </array>
        <key>UTTypeTagSpecification</key>
        <dict>
            <key>public.filename-extension</key>
            <array>
                <string>flv</string>
            </array>
            <key>public.mime-type</key>
            <array>
                <string>video/x-flv</string>
            </array>
        </dict>
    </dict>
    <dict>
        <key>UTTypeIdentifier</key>
        <string>public.webm</string>
        <key>UTTypeDescription</key>
        <string>WebM Video</string>
        <key>UTTypeConformsTo</key>
        <array>
            <string>public.movie</string>
        </array>
        <key>UTTypeTagSpecification</key>
        <dict>
            <key>public.filename-extension</key>
            <array>
                <string>webm</string>
            </array>
            <key>public.mime-type</key>
            <array>
                <string>video/webm</string>
            </array>
        </dict>
    </dict>
</array>
</dict>
</plist>
EOL

cp "$ICON_PATH" "$APP_PATH/Contents/Resources/mpv.icns"

echo "$APP_NAME has been created and moved to Applications folder."
