Building PELUX sources
======================

This chapter details how to download and configure the sources of a PELUX build, so
that an image can be built.

To obtain a PELUX release, simply download the manifest (`pelux.xml`) used for
building, and decide what image to build. Currently there are two versions:
`core-image-pelux-minimal` and `core-image-pelux-qtauto-neptune`. The latter
being a version that includes `Qt Automotive Suite`_ components that enable the
NeptuneUI demo application.

A note on development images
----------------------------
Both PELUX images are available as `-dev` versions, which, for example, sets an
empty root password and allows empty password login via ssh. This is usually
useful during development. The base image for PELUX sets a default root password
to "root", unless the `-dev` image is used.

The `-dev` images also install various useful tools for development and
debugging, such as gdb, strace and so on.

Building locally
----------------

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

Building with Vagrant
---------------------

When we build internally at Pelagicore in our CI system, we use vagrant.  Please
note that we only run this setup in a GNU/Linux system at Pelagicore. It should
still work under Windows or OSX, but we haven't tried it.

Dependencies:
^^^^^^^^^^^^^

* Vagrant
* Docker
* Virtualization enabled in BIOS

Procedure:
^^^^^^^^^^

1. Clone the pelux-manifests git repository.
2. Start vagrant

.. code-block:: bash

    vagrant up


3. Set variables to be used below

.. code-block:: bash

    export bitbake_image="core-image-pelux-minimal"
    export yoctoDir="/home/vagrant/pelux_yocto"
    export manifest="pelux.xml"
    export variant="intel"

4. Do repo init

.. code-block:: bash

    vagrant ssh -c "/vagrant/ci-scripts/do_repo_init ${manifest}"


5. Setup bitbake with correct local.conf and bblayers.conf

.. code-block:: bash

    export templateconf="${yoctoDir}/sources/meta-pelux/conf/variant/${variant}"
    vagrant ssh -c /vagrant/vagrant-cookbook/yocto/initialize-bitbake.sh \
        ${yoctoDir} \
        ${templateconf}"


6. Bitbake the PELUX image

.. code-block:: bash

    vagrant ssh -c "/vagrant/vagrant-cookbook/yocto/build-images.sh \
        ${yoctoDir} \
        ${bitbake_image}"


7. Move the built images to the host

.. code-block:: bash

    vagrant scp :${yoctoDir}/build/tmp/deploy/images ../images


Don't put them into the source folder because then they will be syncroniced back
into the docker instance into the `/vagrant` directory which might take a
reasonable amount of resources to do.

The container/virtual machine started via vagrant will sync the cloned git
repository and use the manifests contained in it to set up the build
environment. This means that the branch/commit currently checked out will
determine what version is being built. The final step will copy the image
directory containing the built images to the directory on the host where vagrant
was started.

For more detailed steps, refer to the scripts in `vagrant-cookbook`.

.. _Qt Automotive Suite: https://www.qt.io/qt-automotive-suite/
