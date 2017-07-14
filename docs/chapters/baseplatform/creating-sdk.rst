Building the SDK installer
===========================

Building the SDK installer is not very different from creating the corresponding
target image. All you have to do, is pass an additional option to bitbake:

.. code-block:: bash

    bitbake -c populate_sdk <image>

This command will create a toolchain installer that contains the sysroot that
matches your target root filesystem. The installer will be created in
tmp/deploy/sdk directory. Please refer to :ref:`installing-sdk` for setup and
usage of the generated SDK installer.
