Downloading and installing the SDK
==================================

Download the SDK for your hardware from the `PELUX website`_. The SDK is a very huge file as it contains tho whole sysroot for the project in addition to some native tools. Depending on the internet connectivity speed it could take a while.

.. note:: Note that the version number at the end of the SDK download file is not the version of the SDK but in fact the version number of poky, which is the upstream Yocto distribution PELUX is using.

Installing the SDK
------------------

When the SDK has been downloaded from a HTTP server then per default is not executable. This needs to be changed with `chmod`.

.. code-block:: bash
                
    cd ~/Downloads
    chmod +x poky-glibc-x86_64-core-image-pelux-qt-corei7-64-toolchain-2.2.1.sh
    
It is a self extracting shell script which can be executed. This will start an interactive program which first asks where to install the SDK. The easiest way is to install it in your `home` directory in it's own directory, like `~/sdk`, instead of the default which is `/opt`. `/opt` is most probably not prepared for your user to install anything into.

.. code-block:: bash

    ➜ jdoe@tux Downloads ./poky-glibc-x86_64-core-image-pelux-qt-corei7-64-toolchain-2.2.1.sh
    Poky (Yocto Project Reference Distro) SDK installer version 2.2.1
    =================================================================
    Enter target directory for SDK (default: /opt/poky/2.2.1): ~/sdk
    You are about to install the SDK to "/home/jdoe/sdk". Proceed[Y/n]? Y
    Extracting SDK.............done
    Setting it up...done
    SDK has been successfully set up and is ready to be used.

Now the SDK is installed and can be used.

.. _`PELUX website`: http://pelux.io/downloads
