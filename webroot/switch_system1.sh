#!/system/bin/sh
# Dual System Switcher
# ThRE Team

MODDIR="/data/adb/modules/DualSystemSwitcher"
WORK_DIR="/cache/DualSystem"
mkdir -p "$WORK_DIR"
STATUS_LOG="/data/adb/modules/DualSystemSwitcher/webroot/status.txt"
PARTED="/data/adb/modules/DualSystemSwitcher/parted"

if [ ! -b "/dev/block/sda28" ]; then
    ui_print "[-] Error: /dev/block/sda28 not found!"
    ui_print "[!] Aborting installation to prevent bricking."
    ui_print "======================================"
    exit 1
fi

if [ -f "$PARTED" ]; then
    chmod 755 $PARTED $CHECK_STATUS
else
    echo "[-] ERROR: parted not found!"
    exit 1
fi

"$PARTED" -s /dev/block/sde print | grep -q "48.*system_1"
if [ $? -eq 0 ]; then
    CURRENT_SYS="2"
else
    CURRENT_SYS="1"
fi

echo "======================================"
echo "    Dual System Switcher"
echo "    R12 by ThRE Team"
echo "======================================"
echo "[*] Current Active: System_$CURRENT_SYS"
echo "--------------------------------------"

    echo "[*] Switch to -> System_1"
    "$PARTED" -s /dev/block/sde name 8 vbmeta
    "$PARTED" -s /dev/block/sde name 45 boot
    "$PARTED" -s /dev/block/sde name 47 vendor
    "$PARTED" -s /dev/block/sde name 48 system
    "$PARTED" -s /dev/block/sda name 18 cust
    "$PARTED" -s /dev/block/sda name 21 userdata
    "$PARTED" -s /dev/block/sda name 22 Extended
    "$PARTED" -s /dev/block/sda name 23 vbmeta_2
    "$PARTED" -s /dev/block/sda name 24 vendor_2
    "$PARTED" -s /dev/block/sda name 25 system_2
    "$PARTED" -s /dev/block/sda name 26 cust_2
    "$PARTED" -s /dev/block/sda name 27 userdata_2
    "$PARTED" -s /dev/block/sda name 28 boot_2

"$PARTED" -s /dev/block/sde print | grep -q "48.*system_1"
if [ $? -eq 0 ]; then
    echo "SYSTEM_2" > "$STATUS_LOG"
    STATUS_SYS="2"
else
    echo "SYSTEM_1" > "$STATUS_LOG"
    STATUS_SYS="1"
fi

echo "[+] Done! System_$STATUS_SYS Active."
echo "--------------------------------------"
echo "[!] Maybe Need Reboot"
echo "======================================"
exit 0
