Writing the image
=================

This section describes how to write the build output, a ready disk-image, to a removable media. Further information can be found in the `Poky documentation`_.

NUC / Minnowboard
-----------------

Use the ``dd`` utility to write the image to the raw block device. For example:

.. code-block:: bash

    dd if=core-image-pelux-intel-corei7-64.wic of=<host-device> bs=4M

Raspberry Pi 3
--------------

Write the generated image file to an SD-card using e.g.:

.. code-block:: bash

    dd if=core-image-pelux-raspberrypi3.rpi-sdimg of=<host-device> bs=4M

.. note:: The ``<host-device>`` is the SD-card or other removable media device on the host, e.g. ``/dev/mmcblk0`` or ``/dev/sdc``. More information on how to discover the SD-card or other media device can be found in the `following documentation`_.

Booting on target hardware
==========================

NUC
---

Plug in the USB-stick and boot the target, make sure to configure EFI to boot from USB. No other actions should be needed.

Raspberry Pi 3
--------------

Insert the SD-card into the Raspberry Pi and boot it up.

.. note:: Login as user ``root``.

.. _Poky documentation: http://git.yoctoproject.org/cgit.cgi/poky/tree/README.hardware
.. _following documentation: https://www.raspberrypi.org/documentation/installation/installing-images/linux.md
