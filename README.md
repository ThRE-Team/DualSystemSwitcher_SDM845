# Dual System Switcher – User Instructions (SDM845 Only)

> [!WARNING]
> **CRITICAL REQUIREMENT:** This switcher does not create or repartition your storage automatically. The secondary partition layout MUST be manually created and named beforehand using `parted` via TWRP/OrangeFox before flashing or triggering this script.

### Prerequisites & Partition Requirements
Your storage table must be repartitioned beforehand to accommodate the secondary slot layout at the end of your block device (`/dev/block/sda`). The script will actively look for index 28 (`boot_2`) as a safety guardrail; if it is missing, the switcher will immediately abort to prevent bricking.  

Ensure your custom partition table exactly matches the following schema before proceeding:

#### Example:

| Number | Start | End | Size | File system | Name | Flags |
| :---: | :--- | :--- | :--- | :--- | :--- | :--- |
| **21** | 1611MB | 64.0GB | 62.4GB | ext4 | `userdata` | |
| **22** | 64.0GB | 69.4GB | 5369MB | ext4 | `Extended` | |
| **23** | 69.4GB | 69.4GB | 1049kB | | `vbmeta_2` | |
| **24** | 69.4GB | 70.4GB | 1074MB | | `vendor_2` | |
| **25** | 70.4GB | 73.7GB | 3221MB | | `system_2` | |
| **26** | 73.7GB | 74.5GB | 872MB | | `cust_2` | |
| **27** | 74.5GB | 122GB | 47.2GB | ext4 | `userdata_2` | |
| **28** | 122GB | 122GB | 67.1MB | | `boot_2` | |

---

### How to Use the Switcher
You can execute the switch using three different methods depending on your current state:

#### Method 1: Via Magisk / KernelSU Manager (While Android is Booted)
* Install the `DualSystemSwitcher.zip` as a normal module in your Magisk or KernelSU Manager app.
* After installation is complete, do not reboot directly from the module installer page. Whenever the file is executed—whether installed as a module or flashed/run otherwise—it will automatically trigger the slot switch.
* The advantage of this module is that after a reboot, you can easily use the Action button inside the module context (or manually trigger action.sh) to switch slots anytime.
* The terminal will output your current slot position and seamlessly flip the partition names.
* Manually Reboot your device immediately after making a switch.

#### Method 2: Via Custom Recovery (TWRP / OrangeFox)
* Boot your device into Custom Recovery.
* Select **Install** and choose `DualSystemSwitcher.zip`.
* Flash the zip. The universal `update-binary` backend will automatically detect the recovery environment, map the file descriptors, and switch the partition layouts on the fly.  

#### Method 3: Via Terminal (Manual Root Trigger)
If you are modifying or managing files manually from an active Terminal interface:

```bash
su
sh /data/adb/modules/DualSystemSwitcher/action.sh
```

---

### Safety System Check (Failsafe Guard)
* **Wrong Device Protection:** If you flash or run this script on an un-partitioned device or an entirely different chipset architecture, the built-in safety script will detect the absence of the `/dev/block/sda28` block node.
* It will safely terminate with an error message: `[-] Error: /dev/block/sda28 not found!`, keeping your primary OS completely untouched and secureDual
