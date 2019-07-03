:orphan:

.. _building-pelux-sources:

Building PELUX
==============

Pelux is build on top of multiple sources, they are described on an ``xml`` file called ``pelux.xml``. 
In order to clone all the sources at once, ``repo`` is used.

Fetching sources
----------------

Create a directory for the PELUX build. On that directory, run ``repo init``, and it will create a ``.repo`` directory which will later be used for fetching the sources.
Run ``repo sync`` to fetch all sources on a new directory called sources.

.. code-block:: bash

    # Initialize repo on the given repository
    repo init -u https://github.com/Pelagicore/pelux-manifests.git

    #Fetch the sources based on the .repo directory
    repo sync

Now all the repositories required for building PELUX have been cloned under ``sources/`` directory. 

A note on image types
---------------------
PELUX images are available with the `-dev` suffix, which include some extra
development and debugging tools. Images are also available as `-update` to generate update artifacts for the :ref:`SOTA
System<getting-started-sota>`. The `-dev` and `-update` images can also be merged to build `-dev-update` which includes both features on the image. 

It should be noted that the regular image is *not* a production ready image. For
a production project, it is recommended to create an image that can be based on
the PELUX image to begin with, but one will probably want to create a custom
image eventually, as the project evolves further and further away from vanilla
PELUX. For example, a PELUX-based image has an empty root password and an ssh
server installed by default.

Image variants
--------------
Pelux can be build for `intel`, `arp`, `rpi`, and `qemu`. Our variants are dependent on the target we are building for.
If the variant contains only the target, a minimal image will be available to be built with no graphics layer. If the variant contains the target name, and the suffix ``-qtauto``, the minimal image will be available to be build as well as the image containing Qt Automotive.

The only variant which does not offer a graphical UI is QEMU. 

All the variants set different configurations, therefore it is important to specify the correct variant before sourcing for bitbake. 

**Intel variants**

- intel
- intel-qtauto

**RaspberryPi variants**

- rpi
- rpi-qtauto

**ARP variants**

- arp
- arp-qtauto

**QEMU variants**

- qemu-x86-64_nogfx

When sourcing, you can tell the ``oe-init-build-dev`` script, to use a specific directory for configuration of a variant.

``TEMPLATECONF`` tells the ``oe-init-build-env`` script which path to fetch
configuration samples from.

.. code-block:: bash

    TEMPLATECONF=`pwd`/sources/meta-pelux/conf/variant/<VARIANT-NAME> source sources/poky/oe-init-build-env build


The script will create configurations if there are no configurations present. A printout about
creating ``conf/local.conf`` and ``conf/bblayers.conf`` is normal.


.. _building-pelux-sources-available-images:

Available images
^^^^^^^^^^^^^^^^
We support intel, ARP and raspberry pi builds. The qt-auto layer can be found on all of them. 

Once you have synced the repo, run the following to configure the environment for Qt Automotive images. 

.. code-block:: bash

    # For intel-qtauto:
    TEMPLATECONF=`pwd`/sources/meta-pelux/conf/variant/intel-qtauto source sources/poky/oe-init-build-env build
    # For rpi-qtauto:
    TEMPLATECONF=`pwd`/sources/meta-pelux/conf/variant/rpi-qtauto source sources/poky/oe-init-build-env build
    # For arp-qtauto:
    TEMPLATECONF=`pwd`/sources/meta-pelux/conf/variant/arp-qtauto source sources/poky/oe-init-build-env build

For ``arp-qtauto``, ``intel-qtauto`` and ``rpi-qtauto`` variants, we support the following images: 

Minimal Images
""""""""""""""
* core-image-pelux-minimal  
* core-image-pelux-minimal-dev
* core-image-pelux-minimal-update 
* core-image-pelux-minimal-dev-update 

Qt Automotive + Neptune 3 UI images
"""""""""""""""""""""""""""""""""""
* core-image-pelux-qtauto-neptune
* core-image-pelux-qtauto-neptune-dev
* core-image-pelux-qtauto-neptune-update
* core-image-pelux-qtauto-neptune-dev-update

In case you want to build only the pelux base image, that can be done by removing `qtauto` suffix from the variant name.

.. code-block:: bash

    # For intel: 
    TEMPLATECONF=`pwd`/sources/meta-pelux/conf/variant/intel source sources/poky/oe-init-build-env build
    # For rpi:
    TEMPLATECONF=`pwd`/sources/meta-pelux/conf/variant/rpi source sources/poky/oe-init-build-env build
    # For arp:
    TEMPLATECONF=`pwd`/sources/meta-pelux/conf/variant/arp source sources/poky/oe-init-build-env build

For ``arp``, ``intel`` and ``rpi`` variants, we support the following images: 

Minimal images
""""""""""""""
* core-image-pelux-minimal  
* core-image-pelux-minimal-dev
* core-image-pelux-minimal-update 
* core-image-pelux-minimal-dev-update 

Building the image
^^^^^^^^^^^^^^^^^^

Finally, build the desired image. See the variables description above for
information on the different images.

.. note:: Building an image takes some time, therefore consider `building the sdk installer
          <http://pelux.io/software-factory/master/swf-blueprint/docs/articles/baseplatform/creating-sdk.html>`_
          or reduce the future builds by `setting up and using Yocto cache
          <http://pelux.io/software-factory/master/swf-blueprint/docs/articles/infrastructure/ci-cd/howto-yocto-cache.html?highlight=mirror#setting-up-and-using-a-yocto-cache>`_ 

.. code-block:: bash

    bitbake <image>

When the build is complete the result will be available in
``tmp/deploy/images/<machine>/``. It is possible to generate a number of
different image formats, ranging from just the rootfs as a tarball to ready
disk-images containing EFI-bootloader, configuration and rootfs and that can be
written directly to a storage device. For PELUX, the preferred format is
``.wic`` images, which are complete disk-images. By default, a compressed wic
image and a bmap file will be built for faster deployment.

Building with Vagrant
---------------------

In the current setup in our CI system we use Docker with Vagrant, however only in a
GNU/Linux system. It should still work under Windows or OSX, but we have not tried it.

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

At this point, we recommend using ``vagrant ssh`` and to follow the same
instructions as when building locally (but inside the Docker container).

4. Move the built images to the host

The directory where you cloned pelux-manifests is bind-mounted to ``/vagrant``
inside the container, so you can simply run:

.. code-block:: bash

    cp <YOCTO_DIR>/build/tmp/deploy/images /vagrant

For more detailed steps, refer to the ``Jenkinsfile`` in ``pelux-manifests``,
where we have automated our building of PELUX.

.. _Qt Automotive Suite: https://www.qt.io/qt-automotive-suite/
