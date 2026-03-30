#!/bin/bash

CONFIG_DIR="/etc/xdg/quickshell/caelestia"
SHELL_DIR="/etc/xdg/quickshell/caelestia/shell.qml"
NOTIFY_DIR="/etc/xdg/quickshell/caelestia/modules/utilities/cards/Toggles.qml"
PCONFIG_FILE="/usr/lib/python3.14/site-packages/caelestia/subcommands/toggle.py"
POWER_FILE="/etc/xdg/quickshell/caelestia/config/SessionConfig.qml"
POWER_FILE_CONTENT="/etc/xdg/quickshell/caelestia/modules/session/Content.qml"
LOCK_FILE="/etc/xdg/quickshell/caelestia/modules/lock/NotifGroup.qml"

BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Restore Mode
if [[ "$1" == "--restore" ]]; then
    if [[ $EUID -eq 0 ]]; then
        echo "[!] Do NOT run with sudo when using --restore"
        echo "[INFO] Dropping privileges..."
        sudo -u "${SUDO_USER:-$USER}" yay -S --needed caelestia-shell caelestia-cli
        exit 0
    fi

    if ! command -v yay &>/dev/null; then
        echo "[!] yay is not installed."
        exit 1
    fi

    yay -S caelestia-shell caelestia-cli
    echo "[*] Restore attempt finished."
    exit 0
fi

# Auto sudo
if [[ $EUID -ne 0 ]]; then
    echo "[INFO] Elevating privileges..."
    exec sudo "$0" "$@"
fi

# Exclude Menu
echo -e "${CYAN}==>${NC} Available patches:"
echo -e " ${CYAN}1) 24-hour clock"
echo -e " 2) Celsius"
echo -e " 3) Notifications container"
echo -e " 4) Power options ${NC}exclusion recommended)${CYAN}"
echo -e " 5) Discord -> Signal"
echo -e " 6) GIF patch ${NC}exclusion recommended${CYAN}"
echo -e " 7) Lockscreen text"
# echo -e " 8) Custom OSD for fullscreen"
echo

echo -e " ==> ${NC} " 'Patches to exclude: (eg: "1 2 3", "1-3" or ENTER to skip, recommended "4 6")  ' "${CYAN}"
read -p ' ==>' EXCLUDES
echo -e "${NC}"
# Parse ranges (1-3 etc.)
parse_excludes() {
    local result=()
    for item in $EXCLUDES; do
        if [[ "$item" =~ ^([0-9]+)-([0-9]+)$ ]]; then
            for ((i=${BASH_REMATCH[1]}; i<=${BASH_REMATCH[2]}; i++)); do
                result+=("$i")
            done
        else
            result+=("$item")
        fi
    done
    EXCLUDES="${result[@]}"
}

parse_excludes

is_excluded() {
    for i in $EXCLUDES; do
        [[ "$i" == "$1" ]] && return 0
    done
    return 1
}

echo "[INFO] Excluded patches: ${EXCLUDES:-none}"
echo

# Patch 1: Clock
if ! is_excluded 1; then
    echo "[*] Forcing 24-hour clock..."
    grep -rl "Config.services.useTwelveHourClock" "$CONFIG_DIR" | while read -r file; do
        sed -i 's/Config.services.useTwelveHourClock/false/g' "$file"
        echo "Patched: $file"
    done
fi

# Patch 2: Celsius
if ! is_excluded 2; then
    echo "[*] Forcing Celsius display..."
    grep -rl "Config.services.useFahrenheitPerformance" "$CONFIG_DIR" | while read -r file; do
        sed -i 's/Config.services.useFahrenheitPerformance/false/g' "$file"
        echo "Patched: $file"
    done
    grep -rl "Config.services.useFahrenheit" "$CONFIG_DIR" | while read -r file; do
        sed -i 's/Config.services.useFahrenheit/false/g' "$file"
        echo "Patched: $file"
    done
fi

# Patch 3: Notifications
if ! is_excluded 3; then
    echo "[*] Adding notifications container..."
    if [[ -f "$NOTIFY_DIR" ]]; then
        perl -0777 -i.bak -pe '
        s/onClicked: Notifs\.dnd = !Notifs\.dnd/MouseArea {\n    anchors.fill: parent\n    acceptedButtons: Qt.LeftButton | Qt.RightButton\n\n    onClicked: \(mouse\) => {\n        if \(mouse.button === Qt.LeftButton\) {\n            Notifs.dnd = !Notifs.dnd\n        } else if \(mouse.button === Qt.RightButton\) {\n            Quickshell.execDetached\(\["qs", "-c", "caelestia", "ipc", "call", "drawers", "toggle", "sidebar"\]\)\n        }\n    }\n}/s' "$NOTIFY_DIR"
        echo "Patched: $NOTIFY_DIR"
    fi
fi

# Patch 4: Power
if ! is_excluded 4; then
    echo "[*] Patching power options..."
    if [[ -f "$POWER_FILE" ]]; then
        sed -i 's/"loginctl", "terminate-user", ""/"hyprctl", "dispatch", "exit"/g' "$POWER_FILE"
        sed -i 's/"systemctl", "poweroff"/"poweroff"/g' "$POWER_FILE"
        sed -i '/property string hibernate: "downloading"/a \        property string switchos: "window"' "$POWER_FILE"
        sed -i '/property list<string> hibernate:/a \        property list<string> switchos: ["switchos.sh"]' "$POWER_FILE"
        sed -i 's/"systemctl", "reboot"/"reboot"/g' "$POWER_FILE"
        sed -i 's/icon: Config.session.icons.hibernate/icon: Config.session.icons.switchos/g' "$POWER_FILE_CONTENT"
        sed -i 's/command: Config.session.commands.hibernate/command: Config.session.commands.switchos/g' "$POWER_FILE_CONTENT"
        echo "Patched: $POWER_FILE"
    fi
fi

# Patch 5: Discord
if ! is_excluded 5; then
    echo "[*] Changing Discord to Signal..."
    if [[ -f "$PCONFIG_FILE" ]]; then
        sed -i 's/\[{"class": "discord"}\]/[{"class": "signal"}]/g' "$PCONFIG_FILE"
        sed -i 's/\["discord"\]/["signal-desktop"]/g' "$PCONFIG_FILE"
        echo "Patched: $PCONFIG_FILE"
    fi
fi

# Patch 6: GIFs
if ! is_excluded 6; then
    echo "[*] Patching gifs..."
    cp "$CONFIG_DIR/assets/pepe-frog.gif" "$CONFIG_DIR/assets/pepe-frog.gif.bak"
    cp "$CONFIG_DIR/assets/portal-rick-and-morty.gif" "$CONFIG_DIR/assets/portal-rick-and-morty.gif.bak"

    mv "$CONFIG_DIR/assets/pepe-frog.gif.bak" "$CONFIG_DIR/assets/bongocat.gif"
    mv "$CONFIG_DIR/assets/portal-rick-and-morty.gif.bak" "$CONFIG_DIR/assets/kurukuru.gif"

    echo "[*] GIF patch done."
fi

# Patch 7: Lock text
if ! is_excluded 7; then
    echo "[*] Patching lockscreen notification text..."
    if [[ -f "$LOCK_FILE" ]]; then
        perl -0777 -i.bak -pe '
        s/component NotifLine: StyledText\s*\{.*?TextMetrics\s*\{.*?\}\s*\}/component NotifLine: StyledText {
            id: notifLine
            Layout.fillWidth: true
            text: qsTr("%1 notification%2").arg(root.notifs.length).arg(root.notifs.length === 1 ? "" : "s")
            color: root.urgency === "critical" ? Colours.palette.m3onSecondaryContainer : Colours.palette.m3onSurface
            font.pointSize: Appearance.font.size.small
            font.italic: true

            Component.onCompleted: modelData.lock(this)
            Component.onDestruction: modelData.unlock(this)
        }/s
        ' "$LOCK_FILE"

        echo "Patched: $LOCK_FILE"
    fi
fi

# # Patch 8: Custom OSD for fullscreen
# if ! is_excluded 8; then
#     echo "[*] Patching $SHELL_DIR Custom OSD for fullscreen..."
#     if [[ -f "$SHELL_DIR" ]]; then
        
#         sed -i '/import "modules\/lock"/a import "modules/fosd"' "$SHELL_DIR"
#         sed -i '/Drawers {}/a \    Fosd {}' "$SHELL_DIR"

#         echo "Patched: $SHELL_DIR"
#     fi
# fi


# Done
echo
echo "[INFO] qs -c CONFIG_NAME kill"
echo "[INFO] qs -c CONFIG_NAME"
echo "[*] Done."