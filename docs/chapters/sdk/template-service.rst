Template Service
================

The template service serves as an example CMake_ project for service
developers that should be used as a starting point while creating platform
services, as well as as a set of guidelines to follow in source
repositories. The guidelines described are not set-in-stone. Also, in
general consistency is better than getting stuck on difficult-to-apply
guidelines so please use these to an extent which is reasonable. The point
is to support a common pattern within the project.

To acquire the template service source code the user needs to fetch the
code from github.

.. code-block:: bash

    git clone https://github.com/Pelagicore/template-service.git

.. _template-service-compilation-label:

Compilation
-----------

In order to compile the template service the user needs to use the CMake
build system. The CMake build system can be installed by following the
instructions on the `CMake install webpage`_ or by using your Linux
distribution's package manager.

.. code-block:: bash

    cd template-service
    mkdir build && cd build
    cmake .. && make -j4

.. note:: The example above presents how to compile the template service natively for your host machine, but it works the same for cross-compilation, since the SDK will set a different environment for cmake.

.. _CMake: https://cmake.org/
.. _CMake install webpage: https://cmake.org/install/
