
.. _SOTA-system:


SOTA system
===========

Introduction and goals
----------------------

The SOTA System is responsible for distributing and applying updates using
over-the-air mechanisms so that machines running PELUX can get new
functionality and security fixes.

Requirements overview
^^^^^^^^^^^^^^^^^^^^^

Basic usage
"""""""""""

- A Release manager *generates update artifacts* from a PELUX build tree
- A Release manager *pushes update artifacts* onto a SOTA server
- A SOTA client automatically *fetches update artifacts* from a SOTA server
- A SOTA client *extracts the update artifacts* and *updates* PELUX components
  such as the kernel, bootloader, rootfs etc...

Basic requirements
""""""""""""""""""

A SOTA system should allow over-the-air updates of PELUX installations. Given
the automotive context, the following requirements are critical:

+----------------+-------------------------------------------------------------+
| Requirement ID | Requirement description                                     |
+================+=============================================================+
| RA-1           | Atomic updates                                              |
+----------------+-------------------------------------------------------------+
| RA-2           | Automatic revert when a non-working update is applied       |
+----------------+-------------------------------------------------------------+
| RA-3           | Integrity and signatures of updates are verified            |
+----------------+-------------------------------------------------------------+
| RA-4           | Fleet management (controlled deployment and monitoring)     |
+----------------+-------------------------------------------------------------+

More information on requirements in the :ref:`arch-vertical-configurations`.

Quality goals
^^^^^^^^^^^^^

+----------+--------------+----------------------------------------------------+
| Priority | Quality-Goal | Scenario                                           |
+==========+==============+====================================================+
| 1        | Safety       | A PELUX system should never end up in a corrupted  |
|          |              | or inconsistent state as a result of a SOTA system |
|          |              | operation.                                         |
+----------+--------------+----------------------------------------------------+
| 1        | Security     | If configured accordingly, any update artifact     |
|          |              | which has not been signed by a PELUX Release       |
|          |              | manager should not be applied.                     |
+----------+--------------+----------------------------------------------------+
| 2        | Correctness  | The result of an update should be exactly the one  |
|          |              | intended by the Release manager.                   |
+----------+--------------+----------------------------------------------------+
| 3        | Flexibility  | PELUX release managers should be kept informed of  |
|          |              | all update failures and able to cancel an update   |
|          |              | deployment.                                        |
+----------+--------------+----------------------------------------------------+
| 4        | Usability    | Update artifacts should be distributed in a        |
|          |              | compressed format to minimize the time needed for  |
|          |              | an update and the network usage.                   |
+----------+--------------+----------------------------------------------------+

Stakeholders
^^^^^^^^^^^^

+-----------------------+--------------------------+---------------------------+
| Role                  | Description              | Goal, Intention           |
+=======================+==========================+===========================+
| PELUX Release manager | Decides when a new PELUX | Wants to publish an       |
|                       | is released              | update of PELUX to the    |
|                       |                          | currently running         |
|                       |                          | instances                 |
+-----------------------+--------------------------+---------------------------+
| Server administrator  | Maintains a publicly     | Wants to install and      |
|                       | accessible server        | maintain a SOTA Server    |
+-----------------------+--------------------------+---------------------------+
| PELUX Developer       | Maintains the            | Wants to configure the    |
|                       | distribution             | SOTA Client for new use   |
|                       |                          | cases                     |
+-----------------------+--------------------------+---------------------------+
| BSP Developer         | Adapts PELUX to new      | Wants to integrate the    |
|                       | platforms                | SOTA system on new        |
|                       |                          | platforms                 |
+-----------------------+--------------------------+---------------------------+
| UI Developer          | Develops a user          | Wants to integrate SOTA   |
|                       | interface on PELUX       | Client to the GUI         |
+-----------------------+--------------------------+---------------------------+

Constraints
-----------

The SOTA system should:

- work on a typical embedded Linux context, for instance with a bootloader such
  as U-Boot or a build system such as Yocto
- be free software

System scope and context
------------------------

The purpose of this section is to put the SOTA system into a broader context,
and show how this subsystem interacts with other parts of the larger PELUX
system.

Business context
^^^^^^^^^^^^^^^^

The business context shows how the SOTA system uses other subsystems and is
being used by other software.

.. uml::

    node "GUI"
    node "ECUs/FPGAs" as satellites
    node "Partitions"
    node "Bootloader"

    database "Updates Database" as updatedb
    node "Web Browser" as webbrowser

    node "SOTA System" {
        [SOTA Client] <-> [SOTA Server]
    } 

    updatedb     <-- [SOTA Server]: Requests
    webbrowser    -> [SOTA Server]: Controls
    GUI           -> [SOTA Client]: Triggers
    [SOTA Client] -> satellites   : Updates
    [SOTA Client] -> Partitions   : Updates
    [SOTA Client] -> Bootloader   : Switch Rootfs

+------------------+-----------------------------------------------------------+
| Neighbor         | Description                                               |
+==================+===========================================================+
| Updates database | Used by the SOTA Server to store update artifacts and     |
|                  | meta-data                                                 |
+------------------+-----------------------------------------------------------+
| GUI              | Uses the SOTA Client to trigger an update                 |
+------------------+-----------------------------------------------------------+
| Bootloader       | Used by the SOTA Client to atomically switch rootfs       |
+------------------+-----------------------------------------------------------+
| Partitions       | Used by the SOTA Client when updating a rootfs            |
+------------------+-----------------------------------------------------------+
| ECUs/FPGAs       | Used by the SOTA Client to update offboard processing     |
|                  | units                                                     |
+------------------+-----------------------------------------------------------+

Technical context
^^^^^^^^^^^^^^^^^

The following diagram shows the participating computers with their technical
connections.

.. uml::

    node "Build server" as buildserver
    node "Release manager computer" as releasemancomp
    node "Update distribution server" as updatedistribserv {
        [SOTA Server]
    }
    node "Machine running PELUX" as peluxmachine {
        [SOTA Client]
    }
    node "ECUs/FPGAs" as satellites

    buildserver -down-> releasemancomp: SSH/FTP/HTTP/...
    releasemancomp <-> [SOTA Server]: Management API or UI
    [SOTA Server] <-> [SOTA Client]: Direct Device Integration API
    [SOTA Client] -> satellites: Automotive buses

+------------------------------+-----------------------------------------------+
| Node                         | Description                                   |
+==============================+===============================================+
| Build server                 | Where update artifacts are built              |
+------------------------------+-----------------------------------------------+
| Release manager computer     | Where update artifacts are uploaded to the    |
|                              | SOTA Server                                   |
+------------------------------+-----------------------------------------------+
| Updates distribution machine | Where update artifacts are stored and         |
|                              | distributed.                                  |
|                              |                                               |
|                              | Where updates are monitored.                  |
+------------------------------+-----------------------------------------------+
| Machine running PELUX        | Where update artifacts are meant to be        |
|                              | received and applied                          |
+------------------------------+-----------------------------------------------+
| ECUs/FPGAs                   | Satellite machines that can be updated        |
+------------------------------+-----------------------------------------------+

Solution strategy
-----------------

* Implement the SOTA client using the **SWUpdate** framework.
* Implement the SOTA server using **Hawkbit**
  
Details on those choices are given in the appendix of this document.

Building blocks view
--------------------

Level 0
^^^^^^^

.. uml::

    () "Client UI API" as clientuiapi
    () "Management UI & API" as mgmtapi
    () "Direct Device Integration API" as ddiapi

    clientuiapi <-> [SOTA Client]
    [SOTA Client] <-> ddiapi
    ddiapi <-> [SOTA Server]
    [SOTA Server] -> mgmtapi

- More details on the Direct Device Integration (DDI) API in the `Bosch IoT Rollout documentation`_.
- More details on the SOTA Client UI integration API in the `SWUpdate IPC documentation`_.
- More details on the Management API in the `dedicated Hawkbit documentation`_.
  (Only the Management UI usage will be documented in the rest of this document)

.. _Bosch IoT Rollout documentation: https://docs.bosch-iot-rollouts.com/documentation/developerguide/apispecifications/directdeviceintegrationapi.html
.. _SWUpdate IPC documentation: https://sbabic.github.io/swupdate/swupdate-ipc.html
.. _dedicated Hawkbit documentation: http://www.eclipse.org/hawkbit/documentation/interfaces/management-api.html

Level 0 - SOTA Client
^^^^^^^^^^^^^^^^^^^^^

.. uml::

    () "DDI API" as ddiapi 
    () "Client UI API" as clientuiapi

    package "SOTA Client" as sotaclient {
        node "Surricata Daemon" as surricata
        node "Artifact Extractor" as extractor
        node "Descriptor Parser" as parser
        node "Handlers" as handlers {
            node "Flash Handler" 
            node "UBI Handler" 
            node "Bootloader Handler" 
            node "Lua Handler" 
            node "Shell Handler" 
            node "..." 
        }
        
        surricata -> extractor
        extractor -> parser
        parser -> handlers
    }

    ddiapi <-> surricata
    clientuiapi <-> sotaclient

- More details on the chosen SOTA Client architecture in `this slide about SWUpdate`_.

.. _this slide about SWUpdate: https://youtu.be/6sKLH95g4Do?t=1685

Level 0 - SOTA Server
^^^^^^^^^^^^^^^^^^^^^

.. uml::

    () "Management API" as mgmtapi 
    () "Management UI" as mgmtui
    () "DDI API" as ddiapi

    database "Updates database" {
        node Artifacts
        node Metadata
    }

    package "SOTA Server" as sotaserver {
        cloud "HTTP Server" as httpserver
        node "Rollout policy and monitoring" as rollout
            
        rollout <-> httpserver
    }

    Artifacts -> rollout
    Metadata -> rollout
    mgmtapi <-> httpserver
    mgmtui <-> httpserver
    ddiapi <-> httpserver

- More details on the chosen SOTA Server architecture in the `Hawkbit documentation`_

.. _Hawkbit documentation: https://www.eclipse.org/hawkbit/documentation/architecture/architecture.html

Runtime view
------------

Update rollout
^^^^^^^^^^^^^^

.. uml::

    "Release manager" -> "SOTA Server": Uploads new .swu
    "SOTA Server" <- "SOTA Client": Polls for update
    "SOTA Server" -> "SOTA Client": Distributes new .swu
    rnote over "SOTA Client"
     Update installation
    endrnote

Working update installation scenario
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. uml::

    "Rootfs 'A'"  -> "SOTA Client": Runs
    "SOTA Server" -> "SOTA Client": Distributes .swu
    "SOTA Client" -> "Rootfs 'B'" : Flash updates
    "SOTA Client" -> "Bootloader" : Reboot instruction
    "Bootloader"  -> "Rootfs 'B'" : Boots
    "Rootfs 'B'"  -> "SOTA Client": Runs
    "SOTA Client" -> "SOTA Server": Notifies of success

Non-working update installation scenario
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. uml::

    "Rootfs 'A'"  -> "SOTA Client": Runs
    "SOTA Server" -> "SOTA Client": Distributes .swu
    "SOTA Client" -> "Rootfs 'B'" : Flash updates
    "SOTA Client" -> "Bootloader" : Reboot instruction
    "Bootloader"  -> "Rootfs 'B'" : Boots
    "Rootfs 'B'"  ->x]: Fails
    "Bootloader"  -> "Rootfs 'A'" : Boots
    "Rootfs 'A'"  -> "SOTA Client": Runs
    "SOTA Client" -> "SOTA Server": Notifies of failure

Deployment view
---------------

The deployment context of the SOTA Solution is documented in the System scope
and context part of this document.

Cross-cutting concepts
----------------------

Update artifacts
^^^^^^^^^^^^^^^^

Update artifacts generated by the build server, stored by the SOTA Server and
fetched and applied by the SOTA Client are bundled in a format named ``.swu``. It
is essentially a CPIO archive containing various files and scripts and most
importantly a top-level "sw-description" file describing the content of the
bundle.  This sw-description must be written by hand by PELUX developers in a
XML or libconfig format.

More details on this format can be found in the `sw-description documentation`_

.. _sw-description documentation: https://sbabic.github.io/swupdate/sw-description.html

Design decisions
----------------

Integrated Web Server
^^^^^^^^^^^^^^^^^^^^^

The chosen SOTA Client, SWUpdate, offers various configurable features. One of
those feature is called "`Mongoose daemon mode`_", it hosts a web app on the
SWUpdate-running machine so that users can connect with a web browser and upload
update artifacts to their PELUX machine.

Having a web server running on an automotive application has been considered as
an unnecessary risk and it has therefore been disabled by default.

.. _Mongoose daemon mode: https://sbabic.github.io/swupdate/mongoose.html

Yocto Integration
^^^^^^^^^^^^^^^^^

The chosen SOTA Client, SWUpdate, can be easily integrated to a Yocto build
system using an official layer named meta-swupdate providing the necessary
recipes to build SWUpdate and .swu artifacts.

The developers of SWUpdate also provide a meta-swupdate-boards layer with
example recipes on how to integrate SWUpdate to a couple of platforms. Most of
the code in this layer is irrelevant to us since it refers to a demo
"core-image-full-cmdline" image and to platforms such as the wandboard or
beaglebone which are not supported by PELUX.

meta-swupdate has been integrated to the default PELUX manifests, to avoid code
duplication. However, it has been decided that the meta-swupdate-boards
contained too much superfluous code and the few relevant parts of that layer
have been directly integrated in meta-pelux.

Partition layout
^^^^^^^^^^^^^^^^

As stated in the :ref:`arch-vertical-configurations`, in order to achieve some of
its requirements, a SOTA client potentially needs to impact the partitioning of
a system. For instance, different schemes are possible: A+B, normal+recovery or
in-place upgrades.

The chosen solution, SWUpdate, is a generic framework that can be used to
implement all of those update strategies. It has been decided that using an A/B
partitioning should be the way to go and this is the partitions scheme that is
used in the provided reference sw-description files.

For convenience, a freshly built PELUX image consists of a single rootfs that
can be flashed on a SD Card. When an update is applied, its artifact comes with
a re-partitioning script that checks whether a "Rootfs B" is available. On the
first application, such a partition is not available, so the script will
re-partition the card to create a second partition and will flash the new rootfs
on this new partition.

After this, new updates will only need to be applied on the Rootfs that is
not currently in use.

Bootloader requirements
^^^^^^^^^^^^^^^^^^^^^^^

For atomic partition switching in an A+B context, the SOTA Client needs to tell
the bootloader which partition should be booted. SWUpdate has support for a
couple of bootloaders at a fairly low-level. It allows artifacts, when they are
being applied, to set boot environment variables.

For instance, GRUB and U-Boot are supported and sw-description files can set
a rootfs partition variable to a specific number that reflects the partition
which should be booted. It is then possible to include a custom script in the
U-Boot or GRUB boot process that reads this environment variable and boots the
kernel with a corresponding "`root=/dev/...`" command line.

If a new bootloader is to be used with PELUX, it can be supported in SWUpdate
by following the example of the `"none" bootloader plugin`_ which requires
four functions: `env_set`, `env_unset`, `env_get` and `apply_list`.
Hardware-specific artifacts can then use that plugin to set a variable and
the bootloader can use that variable to select a suitable kernel command line.

.. _"none" bootloader plugin: https://github.com/sbabic/swupdate/blob/master/bootloader/none.c

Quality requirements
--------------------

The quality requirements are documented in the Integration and goals part of
this document.

Risks and technical debts
-------------------------

The SOTA System is a critical component in an automotive system and presents a
lot of risks. The architecture presented in this document mitigates those risks
by taking into account early in the design process the need for atomic updates
and artifacts signature.

Technical debts are minimized with the chosen architecture because SWUpdate and
Hawkbit are widely used in the industry and supported by stable companies and
foundations such as Bosch, Eclipse or DENX. We can expect those components to be
supported on the long term. Those components have also been chosen for their
flexibility that should effectively adapt to new use cases.

Glossary
--------

See the :ref:`arch-glossary` page for explanations of important terms.

