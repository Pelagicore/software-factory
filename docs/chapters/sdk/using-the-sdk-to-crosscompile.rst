Using the SDK to cross compile
==============================

Cross compiling with the help of the SDK is not much different from normal compilation. There are some more pitfalls, but let's get on with the happy cases for now.

Sourcing Environment
--------------------

After the installation the SDK it needs to be sourced. This means that the SDK toolchain and the sysroot environment variables will be set in your active terminal session.

.. code-block:: bash
                
    cd ~/sdk
    source environment-setup-corei7-64-poky-linux

To check if the environment has already been sourced grep for variables which start with `OECORE` in the environment for example like this:

.. code-block:: bash

    env | grep OECORE
    OECORE_DISTRO_VERSION=2.2.1
    OECORE_SDK_VERSION=2.2.1

    
This means that the environment has been sourced.

Cross Compiling
---------------

In the easiest case, when all the projects dependencies are already installed in the SDK, crosscompiling is really easy. Navigate in to the directory and use cmake and make to compile it as you normally would (see :ref:`Compilation<template-service-compilation-label>`). The environment will make sure that the right compiler and cmake will be used.
