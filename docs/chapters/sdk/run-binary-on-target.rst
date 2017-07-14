Deploying and running a binary executable on target
===================================================

Once the binary has been cross compiled, it needs to be installed on the target. To do so the easiest way is to use SSH. For that to work you need to know the IP address of your target.

.. note:: The `Raspberry Pi documentation`_ describes how to find a new device on the network. Finding the IP address for our device will work in the same manner.

.. _`Raspberry Pi documentation`: https://www.raspberrypi.org/documentation/remote-access/ip-address.md

The default user on the PELUX image is `root` and it doesn't ask for a password logging in via SSH. Use `scp` to copy your binary to the target.

.. code-block:: bash

    scp build/template-service root@<ip address>:

Now that the binary file has been copied to the target it can be run there.

.. code-block:: bash

    ssh root@<ip address>
    ./template-service
