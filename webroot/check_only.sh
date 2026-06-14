#!/system/bin/sh

PARTED="/data/adb/modules/DualSystemSwitcher/parted"
STATUS_LOG="/data/adb/modules/DualSystemSwitcher/webroot/status.txt"
CHECK_STATUS="/data/adb/modules/DualSystemSwitcher/webroot/check_only.sh"

chmod 755 $PARTED $CHECK_STATUS

if $PARTED -s /dev/block/sde print | grep -q '48.*system_1'; then
    echo "SYSTEM_2" > "$STATUS_LOG"
else
    echo "SYSTEM_1" > "$STATUS_LOG"
fi

chmod 666 "$STATUS_LOG"
echo "$(cat $STATUS_LOG) ACTIVATED!"
