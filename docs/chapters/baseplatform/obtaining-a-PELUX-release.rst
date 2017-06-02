Obtaining a PELUX release
=========================

The following manifests can be used for a build:

* `pelux-intel.xml` - For building the `core-image-pelux` image for Intel
* `pelux-intel-qt.xml` - For building the `core-image-pelux-qt` image, which is the baseline with QtAS
* `pelux-rpi.xml` - For building the `core-image-pelux` image for Raspberry Pi 3

Variables:

* Manifest, refers to what `<manifest-name>.xml` file you want to use, for example `pelux-intel.xml`. Each hardware platform targeted by the PELUX reference has its own manifest describing what other git repositories are needed for the build.
* Image, refers to what version of PELUX should be built. Currently there are two versions: `core-image-pelux` and `core-image-pelux-qt`. The latter being a version that includes QtAS_ components that enable the NeptuneUI demo application.

Create a directory for the PELUX build. Instruct repo tool to fetch a manifest using the command `repo init`. In this context, branch denotes what branch of git repo `pelux-manifests` to use. Then make repo tool fetch all sources using the command `repo sync`.

.. literalinclude:: snippets/repo-init.sh
    :language: bash

When done fetching the sources, create a build directory and set up bitbake. TEMPLATECONF tells the `oe-init-build-env` script which path to fetch configuration samples from.

.. note:: The example below get the template configuration for the Intel BSP, adapt the path according to your current BSP.

.. literalinclude:: snippets/repo-source.sh
    :language: bash

The script will create configs if there are no configs present, a message about created `conf/local.conf` and `conf/bblayers.conf` files is normal.


Finally, build the desired image. See the variables description above for information on the different images.

.. literalinclude:: snippets/bitbake.sh
    :language: bash

.. _QtAS: https://www.qt.io/qt-automotive-suite/
