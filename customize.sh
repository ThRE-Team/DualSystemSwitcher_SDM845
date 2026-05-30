#!/sbin/sh
# Dual System Switcher
# ThRE Team

if [ -n "$KSU" ] || [ -n "$MAGISK_VER" ]; then
    OUTFD=1
    ui_print() { echo "$1"; }
    BASE_DIR="$MODPATH"
else
    OUTFD=$(parse_cmdline "updater")
    [ -z "$OUTFD" ] && OUTFD=$3
    [ -z "$OUTFD" ] && OUTFD=/proc/self/fd/2
    ui_print() { echo -e "ui_print $1\nui_print" >&"$OUTFD"; }
    BASE_DIR=$(dirname "$(readlink -f "$0")")
fi

ui_print "======================================"
ui_print "    Dual System Switcher"
ui_print "    R12 by ThRE Team"
ui_print "======================================"

if [ ! -b "/dev/block/sda28" ]; then
    ui_print "[-] Error: /dev/block/sda28 not found!"
    ui_print "[!] Aborting installation to prevent bricking."
    ui_print "======================================"
    exit 1
fi

WORK_DIR="/cache/DualSystem"
mkdir -p "$WORK_DIR"

if [ -f "$BASE_DIR/parted" ]; then
    cp "$BASE_DIR/parted" "$WORK_DIR/parted"
elif [ -f "./parted" ]; then
    cp "./parted" "$WORK_DIR/parted"
elif [ -f "/tmp/parted" ]; then
    cp "/tmp/parted" "$WORK_DIR/parted"
else
    cp "parted" "$WORK_DIR/parted" 2>/dev/null
fi

if [ -f "$WORK_DIR/parted" ]; then
    chmod 755 "$WORK_DIR/parted"
else
    ui_print "[-] ERROR: parted not found!"
    exit 1
fi


"$WORK_DIR/parted" -s /dev/block/sde print | grep -q "48.*system_1"
if [ $? -eq 0 ]; then
    CURRENT_SYS="2"
else
    CURRENT_SYS="1"
fi

ui_print "[*] Current Active: System_$CURRENT_SYS"

setenforce 0 2>/dev/null

if [ "$CURRENT_SYS" = "1" ]; then
    ui_print "[*] Switch to -> System_2"
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
    ui_print "[*] Switch to -> System_1"
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

ui_print "[+] Done! System_$CURRENT_SYS Active."
ui_print "[!] Maybe Need Reboot"
ui_print "======================================"
exit 0
