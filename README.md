# Caelestia Shell Patch Script

This script automates routine changes I make to [**Caelestia Shell**](https://github.com/caelestia-dots/caelestia) on a [**Hyprland**](https://github.com/hyprwm/Hyprland) setup. After updates, it quickly applies all my preferred patches to fix or modify default behavior.

> ⚠️ **Warning:** This script modifies system files and requires **root privileges**. Use at your own risk.

---

## Included Patches

1. **24-hour Clock** – Converts the default 12-hour AM/PM clock format to 24-hour format.
2. **Celsius** – Forces temperature display to Celsius instead of Fahrenheit.
3. **Notifications Container** – Adds right-click/middle-click functionality on the "Do Not Disturb" button to open the notification dock.
4. **Power Options** – Fixes default power options, replaces `loginctl` and `systemctl` with `hyprctl`, and adds a custom Windows switch script (you might wanna change windows switch script by changing "switchos.sh" to "hibernate" in the script). 
5. **Communication Workspace** – Changes default workspace messenger from Discord to Signal (Win+C opens Signal).
6. **GIF Patch** – Replaces default GIFs with personal preference GIFs (you might wanna change it too).
7. **Lockscreen Notifications** – Prevents notification content from showing on the lockscreen.

---

## Usage

```bash
# Run the script with root privileges
sudo ./caelestia-patch.sh

# Restore mode (reinstall Caelestia Shell/CLI)
./caelestia-patch.sh --restore
```

* Exclude patches during execution:

```bash
1 3 5       # Skip patches 1, 3, and 5
2-4         # Skip patches 2, 3, and 4
ENTER       # Apply all patches
```

---

## Requirements

* [Caelestia Shell](https://github.com/caelestia-dots/caelestia) – the base repository this script modifies
* `yay` (for Arch-based systems)
* Root privileges

---

## Notes

* The script only modifies **local system files** and contains **no personal data**.
* Use with caution, especially on production systems.
* For the original Caelestia Shell repository, see: [https://github.com/caelestia-dots/caelestia](https://github.com/caelestia-dots/caelestia)
