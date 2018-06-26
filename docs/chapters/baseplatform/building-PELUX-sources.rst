:orphan:

.. _building-pelux-sources:

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
Both PELUX images are available as `-dev` variants, which include some extra
development and debugging tools. For some platforms, those images are also
available as `-update` to generate update artifacts for the :ref:`SOTA
System<SOTA-system>`.

It should be noted that the regular image is *not* a production ready image. For
a production project, it is recommended to create an image that can be based on
the PELUX image to begin with, but one will probably want to create a custom
image eventually, as the project evolves further and further away from vanilla
PELUX. For example, a PELUX-based image has an empty root password and an ssh
server installed by default.

Building locally
----------------

Create a directory for the PELUX build. Instruct repo tool to fetch a manifest
using the command `repo init`. In this context, branch denotes what branch of
git repo `pelux-manifests` to use. If you want to use a released version of
PELUX, use the SHA id of the commit pointed to by the release tag (or the branch
that the commit lies on). Otherwise, ``master`` is usually a good choice for
cutting-edge.

Then make repo tool fetch all sources using the command `repo sync`.

.. code-block:: bash

    mkdir pelux
    cd pelux
    repo init -u https://github.com/Pelagicore/pelux-manifests.git -b <branch>
    repo sync


Available images
^^^^^^^^^^^^^^^^

.. This is to get red and green colours for the symbols below
.. role:: available
.. role:: unavailable
.. raw:: html

    <!-- The roles we defined in rst will translate to style sheet classes -->
    <style> .available {color:green} .unavailable {color:red} </style>

+--------------------------------------------+------------------+------------------+------------------+----------------+
|                                            |      Variant name                                                       |
+          Image name                        +------------------+------------------+------------------+----------------+
|                                            | intel            | intel-qtauto     | rpi              | rpi-qtauto     |
+============================================+==================+==================+==================+================+
| core-image-pelux-minimal                   | :available:`✔`   | :available:`✔`   | :available:`✔`   | :available:`✔` |
+--------------------------------------------+------------------+------------------+------------------+----------------+
| core-image-pelux-minimal-dev               | :available:`✔`   | :available:`✔`   | :available:`✔`   | :available:`✔` |
+--------------------------------------------+------------------+------------------+------------------+----------------+
| core-image-pelux-qtauto-neptune            | :unavailable:`✘` | :available:`✔`   | :unavailable:`✘` | :available:`✔` |
+--------------------------------------------+------------------+------------------+------------------+----------------+
| core-image-pelux-qtauto-neptune-dev        | :unavailable:`✘` | :unavailable:`✘` | :unavailable:`✘` | :available:`✔` |
+--------------------------------------------+------------------+------------------+------------------+----------------+
| core-image-pelux-minimal-update            | :unavailable:`✘` | :unavailable:`✘` | :available:`✔`   | :available:`✔` |
+--------------------------------------------+------------------+------------------+------------------+----------------+
| core-image-pelux-minimal-dev-update        | :unavailable:`✘` | :unavailable:`✘` | :available:`✔`   | :available:`✔` |
+--------------------------------------------+------------------+------------------+------------------+----------------+
| core-image-pelux-qtauto-neptune-update     | :unavailable:`✘` | :unavailable:`✘` | :unavailable:`✘` | :available:`✔` |
+--------------------------------------------+------------------+------------------+------------------+----------------+
| core-image-pelux-qtauto-neptune-dev-update | :unavailable:`✘` | :unavailable:`✘` | :unavailable:`✘` | :available:`✔` |
+--------------------------------------------+------------------+------------------+------------------+----------------+

When done fetching the sources, create a build directory and set up bitbake.
``TEMPLATECONF`` tells the ``oe-init-build-env`` script which path to fetch
configuration samples from.

.. note:: The example below get the template configuration for the Intel BSP
          without Qt Automotive Suite (QtAS). Use ``intel-qtauto`` as the last
          part of the path to get QtAS support. The same pattern is used for the
          Raspberry Pi BSP (``rpi`` and ``rpi-qtauto``). There is also
          experimental support for ``qemu-x86-64-nogfx``.

.. code-block:: bash

    TEMPLATECONF=`pwd`/sources/meta-pelux/conf/variant/intel source sources/poky/oe-init-build-env build

The script will create configs if there are no configs present, a message about
created ``conf/local.conf`` and ``conf/bblayers.conf`` files is normal.

Building the image
^^^^^^^^^^^^^^^^^^

Finally, build the desired image. See the variables description above for
information on the different images.

.. note:: Building an image takes some time, therefore consider `building the sdk installer <http://pelux.io/software-factory/master/swf-blueprint/docs/articles/baseplatform/creating-sdk.html>`_ or reduce the future builds by `setting up and using Yocto cache <http://pelux.io/software-factory/master/swf-blueprint/docs/articles/infrastructure/ci-cd/howto-yocto-cache.html?highlight=mirror#setting-up-and-using-a-yocto-cache>`_ 

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

When we build internally at Pelagicore in our CI system, we use Docker with
Vagrant, however only in a GNU/Linux system. It should still work under Windows
or OSX, but we haven't tried it.

Dependencies:
^^^^^^^^^^^^^

* Docker CE
* Virtualization enabled in BIOS

.. note:: Ubuntu and Debian both have very old versions of Docker in their apt
          repositories. Follow the steps at `docker.io
          <https://docs.docker.com/engine/installation/linux/docker-ce/debian/>`_
          to install the latest version of Docker.

Procedure:
^^^^^^^^^^

1. Clone the pelux-manifests git repository with submodule

.. code-block:: bash

    git clone --recurse-submodules git@github.com:Pelagicore/pelux-manifests.git


2. Start Docker through Vagrant

.. code-block:: bash

    docker build -t pelux .
    docker run -d --name pelux-build -v $(pwd):/docker pelux

3. Run inside the Docker container

At this point, we recommend using ``vagrant ssh`` and follow the same
instructions as when building locally (but inside the Docker container).

4. Move the built images to the host

The directory where you cloned pelux-manifests is bind-mounted to ``/vagrant``
inside the container, so you can simply run:

.. code-block:: bash

    cp <YOCTO_DIR>/build/tmp/deploy/images /vagrant

For more detailed steps, refer to the ``Jenkinsfile`` in ``pelux-manifests``,
where we have automated our building of PELUX.

.. _Qt Automotive Suite: https://www.qt.io/qt-automotive-suite/
