Obtaining a PELUX release
=========================

The following manifests can be used for a build:

* `pelux-intel.xml` - For building the `core-image-pelux` image for Intel
* `pelux-intel-qtauto.xml` - For building the `core-image-pelux-qtauto` image, which is the baseline with `Qt Automotive Suite`_
* `pelux-rpi.xml` - For building the `core-image-pelux` image for Raspberry Pi 3

Variables:

* Manifest, refers to what `<manifest-name>.xml` file you want to use, for example `pelux-intel.xml`. Each hardware platform targeted by the PELUX reference has its own manifest describing what other git repositories are needed for the build.
* Image, refers to what version of PELUX should be built. Currently there are two versions: `core-image-pelux` and `core-image-pelux-qtauto`. The latter being a version that includes `Qt Automotive Suite`_ components that enable the NeptuneUI demo application.

Create a directory for the PELUX build. Instruct repo tool to fetch a manifest using the command `repo init`. In this context, branch denotes what branch of git repo `pelux-manifests` to use. Then make repo tool fetch all sources using the command `repo sync`.

.. code-block:: bash

    mkdir pelux
    cd pelux
    repo init -u https://github.com/Pelagicore/pelux-manifests.git -m <manifest> -b <branch>
    repo sync

When done fetching the sources, create a build directory and set up bitbake. ``TEMPLATECONF`` tells the ``oe-init-build-env`` script which path to fetch configuration samples from.

.. note:: The example below get the template configuration for the Intel BSP, adapt the path according to your current BSP.

.. code-block:: bash

    TEMPLATECONF=`pwd`/sources/meta-pelux-bsp-intel/conf/ source sources/poky/oe-init-build-env build

The script will create configs if there are no configs present, a message about created ``conf/local.conf`` and ``conf/bblayers.conf`` files is normal.

Finally, build the desired image. See the variables description above for information on the different images.

.. code-block:: bash

    bitbake <image>

When the build is complete the result will be available in ``tmp/deploy/images/<machine>/``. It is possible to generate a number of different image formats, ranging from just the rootfs as a tarball to ready disk-images containing EFI-bootloader, configuration and rootfs and that can be written directly to a storage device. For PELUX, the preffered format for the Intel NUC are .wic images, which are complete disk-images.

.. _Qt Automotive Suite: https://www.qt.io/qt-automotive-suite/
