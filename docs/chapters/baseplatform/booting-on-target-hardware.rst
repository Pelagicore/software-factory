Booting on target hardware
==========================
.. note:: Login as user ``root``.

ARP
---

On the ARP there are three options available for booting:

1. USB: Boot from a USB-stick by simply inserting said USB-stick into one of the
   USB ports on the ARP. Make sure that USB is set as boot source in BIOS/u-boot
2. SD-card: Insert the SD-card into the slot labeled "SMARC SD" located next
   to the USB ports. This feature requires ARP version >= 1.5.
3. EMMC: On most SMARC devices there is an EMMC which can be used for booting.
   This is the boot option with best performance. However, it requires some
   setup to get the PELUX image on to the EMMC. An example of such a setup would
   be putting the image in question on to a USB-stick with containing Ubuntu-live,
   boot into the Ubuntu live mode and use `dd` to write the image onto the EMMC.

NUC
---

Plug in the USB-stick and boot the target, make sure to configure EFI to boot
from USB. No other actions should be needed.

Raspberry Pi 3
--------------

Insert the SD-card into the Raspberry Pi and boot it up. Make sure to use the
HDMI output.

QEMU
----

Booting up a QEMU image is described in :ref:`booting-a-qemu-image`.
