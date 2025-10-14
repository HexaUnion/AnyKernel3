### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=Evanescence Kernel by Hexaboo
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=creek
device.name2=sapphire
device.name3=topaz
device.name4=xun
device.name5=
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties

# shell variables
slot=$(find_slot);
block=/dev/block/bootdevice/by-name/boot$slot;
is_slot_device=1;
ramdisk_compression=auto;
patch_vbmeta_flag=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;

ui_print "[INFO] Verifying kernel image"
"$BIN/busybox" sha256sum -cs Image.zst.sha256 \
  || abort "[ERR] SHA256 mismatch"

ui_print "[INFO] Unpacking kernel image"
"$BIN/zstd" -d -q --no-progress -o "$AKHOME/Image" "$AKHOME/Image.zst" \
  || abort "[ERR] Decompress failed"

ui_print "[SUCCESS] Unpacked kernel successfully"

# boot install
split_boot
if [ -f "split_img/ramdisk.cpio" ]; then
    unpack_ramdisk
    write_boot
else
    flash_boot
fi
## end boot install
