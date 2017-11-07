Building PELUX sources
======================

This chapter details how to download and configure the sources of a PELUX build, so
that an image can be built.

To obtain a PELUX release, simply download the manifest (`pelux.xml`) used for
building, and decide what image to build. Currently there are two versions:
`core-image-pelux-minimal` and `core-image-pelux-qtauto-neptune`. The latter
being a version that includes `Qt Automotive Suite`_ components that enable the
NeptuneUI demo application.

Create a directory for the PELUX build. Instruct repo tool to fetch a manifest
using the command `repo init`. In this context, branch denotes what branch of
git repo `pelux-manifests` to use. Then make repo tool fetch all sources using
the command `repo sync`.

.. code-block:: bash

    mkdir pelux
    cd pelux
    repo init -u https://github.com/Pelagicore/pelux-manifests.git -b <branch>
    repo sync

When done fetching the sources, create a build directory and set up bitbake.
``TEMPLATECONF`` tells the ``oe-init-build-env`` script which path to fetch
configuration samples from.

.. note:: The example below get the template configuration for the Intel BSP
          without Qt Automotive Suite (QtAS). Use ``intel-qtauto`` as the last
          part of the path to get QtAS support. The same pattern is used for the
          Raspberry Pi BSP (``rpi`` and ``rpi-qtauto``).

.. code-block:: bash

    TEMPLATECONF=`pwd`/sources/meta-pelux/conf/variant/intel source sources/poky/oe-init-build-env build

The script will create configs if there are no configs present, a message about
created ``conf/local.conf`` and ``conf/bblayers.conf`` files is normal.

Finally, build the desired image. See the variables description above for
information on the different images.

.. code-block:: bash

    bitbake <image>

When the build is complete the result will be available in
``tmp/deploy/images/<machine>/``. It is possible to generate a number of
different image formats, ranging from just the rootfs as a tarball to ready
disk-images containing EFI-bootloader, configuration and rootfs and that can be
written directly to a storage device. For PELUX, the preferred format for the
Intel NUC are ``.wic`` images, which are complete disk-images. For the Raspberry
Pi 3, the preferred format is ``.rpi-sdimg`` which can be directly written to
the SD card.

.. _Qt Automotive Suite: https://www.qt.io/qt-automotive-suite/
