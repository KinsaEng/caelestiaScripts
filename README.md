# Caelestia Shell Patch Script

This script automates routine changes I make to **Caelestia Shell** on a **Hyprland** setup. After updates, it quickly applies all my preferred patches to fix or modify default behavior.

> ⚠️ **Warning:** This script modifies system files and requires **root privileges**. Use at your own risk.

---

## Included Patches

1. **24-hour Clock**
   - Converts the default 12-hour AM/PM clock format to 24-hour format.

2. **Celsius**
   - Forces temperature display to Celsius instead of Fahrenheit.

3. **Notifications Container**
   - By default, there was no button to open the notification dock.
   - Patch enables opening the dock via **right-click or middle-click** on the "Do Not Disturb" button.

4. **Power Options**
   - Default power options were not working correctly.
   - Replaced `loginctl` commands with `hyprctl`.
   - Added custom script for switching to Windows (`switchos.sh`) instead of Hibernate.
   - Ensures shutdown, reboot, and other power options function properly.

5. **Communication Workspace**
   - The Communication workspace opened Discord by default.
   - Changed to Signal (my preferred messenger) so Win+C opens Signal instead of Discord.

6. **GIF Patch**
   - Replaced default GIFs with custom ones according to personal preference.

7. **Lockscreen Notifications**
   - Prevents notification content from being displayed on the lockscreen.

---

## Usage

```bash
# Run the script with root privileges
sudo ./caelestia-patch.sh

# Restore mode (reinstall Caelestia Shell/CLI)
./caelestia-patch.sh --restore
```

## You can exclude certain patches during execution. Examples:
1 3 5       # Skip patches 1, 3, and 5
2-4         # Skip patches 2, 3, and 4
ENTER       # Apply all patches


## Requirements

- yay (for Arch-based systems)

- Caelestia Shell and CLI installed

- Root privileges (script modifies system files)


