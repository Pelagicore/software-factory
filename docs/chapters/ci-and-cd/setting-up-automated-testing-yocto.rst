Setting up automated testing on a NUC using Yocto
=================================================

This article describes how automated deployment can be set up for test automation of images on a
HW-target directly from bitbake on the build host. Relevant upstream documentation is available in the Yocto docs
for automated runtime testing_.

After following this how-to you should have:

* An Intel NUC which is ready to use as testing target
* Knowledge about how to get bitbake to deploy and run tests using that testing target


How it works
------------
In order to facilitate the deployment of images to the NUC a "testmaster" image is used. The NUC is setup to boot
this testmaster image by default, and then bitbake can deploy the target rootfs and target kernel using scp and some
scripting.

The target rootfs is put on a separate partition, so the testmaster stays intact. Then the bootloader is
told to boot a secondary entry called "test" once, and the target is rebooted which will cause it to boot using the
rootfs and kernel that should be tested. The tests are then triggered using an ssh connection, and when all tests are
done the target is rebooted once more so it ends up in testmaster image again.

There are hooks for enabling bitbake to power-cycle the NUC, which is required if the testing should be able
to recover from e.g. images that doesn't boot. Without those hooks it depends on that a reboot can be initiated over an
ssh connection. This how-to will not describe these hooks though.


Preparing the NUC
-----------------
There is an image called `core-image-testmaster` which is used as a basis for the setup. Following are a number of
manual steps that need to be performed when deploying this image. The `repo` tool is used in the examples, for
more information see :ref:`using-the-repo-tool`

Start by building the image:

.. code-block:: bash

    mkdir test-automation && cd test-automation
    repo init -u https://github.com/Pelagicore/pelux-manifests.git -m pelux-intel-qtauto.xml -b master
    repo sync
    TEMPLATECONF=`pwd`/sources/meta-pelux-bsp-intel/conf-qt/ source sources/poky/oe-init-build-env build
    echo 'EFI_PROVIDER = "systemd-boot"' >> conf/local.conf
    bitbake core-image-testmaster

We will deploy this image to a USB-stick with the following partition scheme:

=========== =========== ========== =======
Partition # File system Label      Comment
=========== =========== ========== =======
1           vfat        boot
2           ext3
3           swap
4           ext3        testrootfs Will be mounted by scripts, so need correct label
=========== =========== ========== =======

Instead of deploying directly to the USB-stick using mkefidisk.sh we run mkefidisk on a file-backed loop-device
in order to leave more space at the end of the disk for partition #4. Mkefidisk would otherwise grow the partition #2
as much as possible to fill the USB-stick.

Please note that the last argument to mkefidisk.sh is the name of the device on the target HW, e.g. /dev/sda or /dev/mmcblk2, etc.

.. code-block:: bash

    dd if=/dev/zero of=output.img count=1024 bs=4M
    sudo losetup --find --show output.img
    sudo ../sources/poky/scripts/contrib/mkefidisk.sh /dev/loop<NUMBER FROM PREVIOUS COMMAND> tmp/deploy/images/intel-corei7-64/core-image-testmaster-intel-corei7-64.hddimg /dev/sda
    sudo losetup -d /dev/loop<NUMBER FROM PREVIOUS COMMAND>

We now have a 4GB big disk image which we can write to a USB-stick.

.. code-block:: bash

    sudo dd if=output.img of=/dev/sd<YOUR USB DEVICE> bs=10M status=progress

When this is completed, remove and re-insert the USB-stick. Partition #1-3 will be created now, but we need to manually add
partition #4.

.. code-block:: bash

    sudo fdisk /dev/sd<YOUR USB DEVICE>
    - Press n for new partition
    - Press p for a primary partition
    - Press enter twice to get it to fill all remaining space
    - Press w to write
    sudo mkfs.ext3 -L testrootfs /dev/sd<YOUR USB DEVICE>4

Now mount the testmaster rootfs in order to do some changes there:

.. code-block:: bash

    sudo mount /dev/sd<YOUR USB DEVICE>2 /mnt/

    # Create image used to identify if system is booted into the testmaster image
    sudo touch /mnt/etc/masterimage

    # Make sure the testmaster image shows a login prompt
    sudo ln -sf /lib/systemd/system/getty@.service /mnt/etc/systemd/system/getty.target.wants/getty@tty1.service

    # Create a network conf file which we then copy to rootfs, this one uses DHCP
    cat <<EOF > /tmp/20-wired.network
    [Match]
    Name=en*

    [Network]
    DHCP=ipv4

    [DHCP]
    RouteMetric=10
    ClientIdentifier=mac
    EOF
    sudo cp /tmp/20-wired.network /mnt/etc/systemd/network/


    # Unmount
    sudo umount /mnt

Now we mount the EFI partition to add a bootloader entry called "test" which boots the kernel and file system under test.

.. code-block:: bash

    # Set correct label on EFI partition
    sudo dosfslabel /dev/sd<YOUR USB DEVICE>1 boot

    # Mount EFI partition
    sudo mount /dev/sd<YOUR USB DEVICE>1 /mnt/
    # Create temp bootloader config file which we then copy
    cat <<EOF > /tmp/test.conf
    title test
    linux /test-kernel
    options LABEL=test root=/dev/sda4 ro rootwait console=ttyS0 console=tty0
    EOF
    sudo cp /tmp/test.conf /mnt/loader/entries/

    # Unmount
    sudo umount /mnt

The USB-stick should now be ready and can be inserted into a NUC and booted, do that and check what IP-address it gets
using e.g. "ip a".


Building and testing an image
-----------------------------

There is some configuration that needs to be setup in local.conf in order to enable target testing, so add the
following to conf/local.conf

.. code-block:: bash

    IMAGE_FSTYPES += "tar.gz"
    INHERIT += "testimage"
    TEST_TARGET = "SystemdbootTarget"
    TEST_TARGET_IP = "<IP of NUC>"
    TEST_SERVER_IP = "<IP of machine used for building>"

Sometimes we need to set TEST_SERVER_IP, although that shouldn't be necessary according to the docs.
This might be related to multiple network interfaces confusing the auto-detection.

You can now build and test basically any image using ``bitbake -c testimage <my image>``, e.g.:

.. code-block:: bash

    bitbake -c testimage core-image-pelux

Adding a new test
-----------------

The unit tests run by bitbake when executing the `testimage` target of an image
are Python scripts executed on the build machine. They rely on the standard
`unittest` module and infrastructure but are extended by Yocto's `oeqa` module.

The unittest module of Python offers the basic testing capabilities. For
instance, the `TestCase` class has an `assertTrue(condition, message)` method to
verify whether a condition is true. This module is documented `in the Python
documentation`_.

The `oeqa` module extends unittest with additional features. For instance, the
`OERuntimeTestCase` class has a `target.run(command)` method which can remotely
trigger a command via SSH. Other functionalities include files copying or
package management. This module is documented `in the Yocto documentation`_.

Adding a new test can be done by creating a new `.py` file under the
`lib/oeqa/runtime/cases` directory of any Yocto layer. For instance, let's
create a minimal test case checking the output and status of the `echo` command.
Put the following code into
`sources/meta-pelux/lib/oeqa/runtime/cases/hello.py`

.. code-block:: python

    from oeqa.runtime.case import OERuntimeTestCase
    from oeqa.core.decorator.depends import OETestDepends

    class HelloTest(OERuntimeTestCase):
        @OETestDepends(['ssh.SSHTest.test_ssh'])
        def test_hello(self):
            (status, output) = self.target.run("echo hello")
            self.assertTrue(status == 0,"'echo hello' did not return a 0 status")
            self.assertTrue(output == "hello", "'echo hello' did not show hello")

Bitbake can now find this test but it won't be executed by default. If you want
your test to be ran, you need to set the `TEST_SUITES` variable in your
`local.conf`. For instance, add the following line:

.. code-block:: bash

    TEST_SUITES = "ping ssh hello"

Note that the order is important and that there might be dependencies between
tests. Here, `hello` depends on `ssh` which depends on `ping`. Various examples of
test cases can be found in `sources/poky/meta/lib/oeqa/runtime/cases/`.

.. _testing: http://www.yoctoproject.org/docs/current/dev-manual/dev-manual.html#performing-automated-runtime-testing
.. _meta-pelux: https://github.com/Pelagicore/meta-pelux
.. _in the Python documentation: https://docs.python.org/2/library/unittest.html
.. _in the Yocto documentation: https://wiki.yoctoproject.org/wiki/Image_tests#Writing_new_tests

