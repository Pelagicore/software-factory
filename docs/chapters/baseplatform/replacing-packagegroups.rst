:orphan:

.. _replacing-packagegroups:

Replacing packagegroups by hand-picked components
==================================================

By default PELUX include components from Qt Auto using the packagegroups feature.
This chapter describes how to replace these default Qt Auto components with
hand-picked components in a new image.

The following packagegroups from Qt Auto are included in the PELUX image.

* ``packagegroup-b2qt-automotive-addons``
* ``nativesdk-packagegroup-b2qt-automotive-qt5-toolchain-host``
* ``packagegroup-b2qt-automotive-qt5-toolchain-target``
 
These packagegroups add several Qt Auto add-ons (includes ``neptune-ui`` among others) 
and packages that are used when building SDK for host and target machines.

In a typical project, the users of PELUX will build their own image. To do that add the 
file ``meta-pelux/<image-recipe-path>/<image-name>.bb`` and update it according to what
packagegroups are intended to be included in the new image.

If all of the Qt Auto components defined in above packagegroups are needed in the new image 
then simply include the following line in the new image-recipe.

.. code-block:: bash

    DESCRIPTION = "New PELUX image with QtAuto frontend"

    require layers/b2qt/recipes-core/images/core-image-pelux-qtauto-neptune.bb

If the new image want to omit all of the Qt Auto components in the above mentioned packagegroups
and add some other component ``<other-component>``, then it can simply inherit from ``core-image-pelux`` 
in its image-recipe and append ``<other-component>`` to the image.

.. code-block:: bash

    DESCRIPTION = "New PELUX image without QtAuto frontend"

    inherit core-image-pelux

    IMAGE_INSTALL_append = " <other-component> "

If only packagegroups that are used in building Qt Auto host and target SDK are needed, then update the 
image-recipe as follows.

.. code-block:: bash

    DESCRIPTION = "New PELUX image with QtAuto frontend"

    inherit core-image-pelux-qtauto

If only ``neptune-ui`` and other add-ons in ``packagegroup-b2qt-automotive-addons`` packagegroup
are needed, then update the image-recipe as follows.

.. code-block:: bash

    DESCRIPTION = "New PELUX image with QtAuto frontend"

    require layers/b2qt/recipes-core/images/core-image-pelux-qtauto-neptune.bb

    TOOLCHAIN_HOST_TASK_remove = " nativesdk-packagegroup-b2qt-automotive-qt5-toolchain-host "
    TOOLCHAIN_TARGET_TASK_remove = " packagegroup-b2qt-automotive-qt5-toolchain-target "
