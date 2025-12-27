#!/bin/bash
# Save as: ~/.config/dunst/scripts/flameshot-handler.sh
# Make executable: chmod +x ~/.config/dunst/scripts/flameshot-handler.sh

# This script only runs when you click the notification
# Extract the screenshot path from the notification
SCREENSHOT_PATH=$(echo "$DUNST_BODY" | grep -oP '(?<=file://|: )(/[^\s]+\.png)' | head -1)

# If no path found, try alternative patterns
if [ -z "$SCREENSHOT_PATH" ]; then
    SCREENSHOT_PATH=$(echo "$DUNST_SUMMARY $DUNST_BODY" | grep -oP '/[^\s]+\.png' | head -1)
fi

# If still no path, try to get the latest screenshot
if [ -z "$SCREENSHOT_PATH" ]; then
    SCREENSHOT_PATH=$(ls -t ~/Pictures/flameshot/*.png 2>/dev/null | head -1)
fi

# Open the screenshot only if file exists
if [ -n "$SCREENSHOT_PATH" ] && [ -f "$SCREENSHOT_PATH" ]; then
    xdg-open "$SCREENSHOT_PATH"
fi
