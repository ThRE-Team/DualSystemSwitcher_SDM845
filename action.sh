#!/system/bin/sh
# Dual System Switcher
# ThRE Team

MODDIR="/data/adb/modules/DualSystemSwitcher"
WORK_DIR="/cache/DualSystem"
mkdir -p "$WORK_DIR"

if [ ! -b "/dev/block/sda28" ]; then
    ui_print "[-] Error: /dev/block/sda28 not found!"
    ui_print "[!] Aborting installation to prevent bricking."
    ui_print "======================================"
    exit 1
fi

if [ -f "$MODDIR/parted" ]; then
    cp "$MODDIR/parted" "$WORK_DIR/parted"
    chmod 755 "$WORK_DIR/parted"
else
    echo "[-] ERROR: parted not found!"
    exit 1
fi

"$WORK_DIR/parted" -s /dev/block/sde print | grep -q "48.*system_1"
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

setenforce 0 2>/dev/null

if [ "$CURRENT_SYS" = "1" ]; then
    echo "[*] Switch to -> System_2"
    
    "$WORK_DIR/parted" -s /dev/block/sde name 8 vbmeta_1
    "$WORK_DIR/parted" -s /dev/block/sde name 45 boot_1
    "$WORK_DIR/parted" -s /dev/block/sde name 47 vendor_1
    "$WORK_DIR/parted" -s /dev/block/sde name 48 system_1
    "$WORK_DIR/parted" -s /dev/block/sda name 18 cust_1
    "$WORK_DIR/parted" -s /dev/block/sda name 21 userdata_1
    "$WORK_DIR/parted" -s /dev/block/sda name 22 Extended
    "$WORK_DIR/parted" -s /dev/block/sda name 23 vbmeta
    "$WORK_DIR/parted" -s /dev/block/sda name 24 vendor
    "$WORK_DIR/parted" -s /dev/block/sda name 25 system
    "$WORK_DIR/parted" -s /dev/block/sda name 26 cust
    "$WORK_DIR/parted" -s /dev/block/sda name 27 userdata
    "$WORK_DIR/parted" -s /dev/block/sda name 28 boot
else
    echo "[*] Switch to -> System_1"
    "$WORK_DIR/parted" -s /dev/block/sde name 8 vbmeta
    "$WORK_DIR/parted" -s /dev/block/sde name 45 boot
    "$WORK_DIR/parted" -s /dev/block/sde name 47 vendor
    "$WORK_DIR/parted" -s /dev/block/sde name 48 system
    "$WORK_DIR/parted" -s /dev/block/sda name 18 cust
    "$WORK_DIR/parted" -s /dev/block/sda name 21 userdata
    "$WORK_DIR/parted" -s /dev/block/sda name 22 Extended
    "$WORK_DIR/parted" -s /dev/block/sda name 23 vbmeta_2
    "$WORK_DIR/parted" -s /dev/block/sda name 24 vendor_2
    "$WORK_DIR/parted" -s /dev/block/sda name 25 system_2
    "$WORK_DIR/parted" -s /dev/block/sda name 26 cust_2
    "$WORK_DIR/parted" -s /dev/block/sda name 27 userdata_2
    "$WORK_DIR/parted" -s /dev/block/sda name 28 boot_2
fi

echo "[+] Done! System_$CURRENT_SYS Active."
echo "--------------------------------------"
echo "[!] Maybe Need Reboot"
echo "======================================"
exit 0
