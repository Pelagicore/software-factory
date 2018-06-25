:orphan:

.. _SOTA-system:

.. toctree::
    :hidden:

    ../../swf-blueprint/docs/articles/architecture/arch-vertical-configurations.rst
    ../../swf-blueprint/docs/articles/architecture/arch-glossary.rst

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
beaglebone which aren't supported by PELUX.

meta-swupdate has been integrated to the default PELUX manifests, to avoid code
duplication. However, it has been decided that the meta-swupdate-boards
contained too much superfluous code and the few relevant parts of that layer
have been directly integrated in meta-pelux.

Partition layout
^^^^^^^^^^^^^^^^

As stated in the `Vertical configurations page`_, in order to achieve some of
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

.. _Vertical configurations page: http://pelux.io/software-factory/master/swf-blueprint/docs/articles/architecture/arch-vertical-configurations.html#update-management

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

Appendix: Getting started with Hawkbit and SWUpdate
---------------------------------------------------

Due to a lack of clear instructions available on the internet, this appendix
details the necessary steps to setup a local installation of Hawkbit and
interface it with a PELUX system. This should be enough to set up a local
development environment but extra steps would be needed for a real updates
deployment context.

Context
^^^^^^^

For the rest of the tutorial, we will assume you have two machines connected
on an IP network:

- A development machine running a standard Linux distribution. We will assume
  that this machine has the *192.168.3.11* IP address. This machine must have
  Java 8 (Both OpenJDK and Oracle Java 1.8 work), Maven and rabbitmq-server
  installed.
- A raspberrypi3 or an Intel NUC (intel-corei7-64) running PELUX. Other
  platforms should have similar configurations in the future but the Raspberry Pi
  and Intel NUC are currently the only supported platforms.

Compiling SWUpdate artifacts
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can generate update artifacts of PELUX from your Yocto build directory
using bitbake. For example a .swu file for *core-image-pelux-minimal* can be
generated using:

.. code-block:: bash

    $ bitbake core-image-pelux-minimal-update

The resulting file can then be found at one of the following locations depending on the
build target:

*build/tmp/deploy/images/raspberrypi3/core-image-pelux-minimal-update-raspberrypi3.swu*

*build/tmp/deploy/images/intel-corei7-64/core-image-pelux-minimal-update-intel-corei7-64.swu*

More details can be found in the :ref:`building-PELUX-sources` page.

Hawkbit installation
^^^^^^^^^^^^^^^^^^^^

We will fetch Hawkbit from its GitHub repository.

.. code-block:: bash

    $ git clone https://github.com/eclipse/hawkbit
    $ cd hawkbit

Recent versions of Hawkbit aren't yet supported by SWUpdate so we need to
manually select a slightly older version of Hawkbit.

.. code-block:: bash

    $ git checkout 0.2.0M4

We can now compile Hawkbit using Maven.

.. code-block:: bash

    $ mvn clean install

And run the generated Hawkbit Server:

.. code-block:: bash

    $ java -jar ./hawkbit-runtime/hawkbit-update-server/target/hawkbit-update-server-0.2.0-SNAPSHOT.jar

Accessing the Hawkbit panel
^^^^^^^^^^^^^^^^^^^^^^^^^^^

As detailed in the main part of this document, Hawkbit offers two mechanisms
for artifacts management: the Management UI and the Management API. We will
detail the usage of the Management UI here.

You can access the Management UI from a Web Browser on the development machine
by opening the following URL: http://localhost:8080

The default credentials are:

- **username:** *admin*
- **password:** *admin*

To change those logins, you need to modify
hawkbit-runtime/hawkbit-update-server/src/main/resources/application.properties
and recompile Hawkbit using ``mvn clean install``.

Running SWUpdate in Surricata mode
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Before setting up a deployment campaign on Hawkbit, we will start SWUpdate on
the machine running PELUX to let Hawkbit know our device exists.

.. code-block:: bash

    $ swupdate -H <hardware name>:1.0 -e stable,alt -f /etc/swupdate.cfg -l 5 -u '-t DEFAULT -u http://192.168.3.11:8080 -i DeviceID'

.. note:: - The `H` option specifies the hardware name and revision. The
            supported hardware names are **raspberrypi3** and **intel-corei7-64** 
          - The `e` option selects the software and mode that should be used
            (for instance: alt installs on the partition B, main installs on
            the partition A).
          - The `f` option points to the SWUpdate config file.
          - The `l` option chooses a verbose log level.
          - The `u` option is followed by options dedicated to the Surricata
            mode.
          - The `t` option selects the tenant ID of the device.
          - The second `u` option points to the Hawkbit instance you want to
            download your artifacts from.
          - The `i` option represents the id of the device.

You should now see a new target appearing in the left side of the Deployment
tab of Hawkbit with the name you chose as *"DeviceID"* in the above command.

Update campaign rollout
^^^^^^^^^^^^^^^^^^^^^^^

Upload
""""""

- Go to the **Upload** tab from the left selector
- Create a Software Module of type "OS" named Rootfs of version 1.0 and then
  click on it
- Use the "Upload file" button to select the .swu file you generated earlier
  and then press the "Process" button to validate the upload

`Note:`: Hawkbit offers "Management APIs" that can potentially automatize those
steps.

Distribution Management
"""""""""""""""""""""""

- Go to the **Distributions Management** tab from the left selector
- Create a Distribution of type "OS with app(s)", named PELUX of version 1.0
- Drag and drop the Rootfs on the right pane onto the PELUX distribution on the
  left pane
- Click the actions button and apply the changes

Target Filters
""""""""""""""

- Go to the **Target Filters** tab from the left selector
- Create a new filter named "Default filter" and use a generic filter such as
  "name==*"

Rollout
"""""""
- Go to the **Rollout** tab from the left selector
- Create a new rollout campaign named "PELUX 1.0 Deployment". Select the PELUX
  distribution set, the default filter and enter 1 in the "Number of groups"
  field. You should see stats of deployment appearing
- Press the "Play" icon on the right side of your rollout campaign to activate
  the deployment

Applying the update
^^^^^^^^^^^^^^^^^^^

At this point, you can either wait for a while, so that SWUpdate polls for
updates and finds the new deployment campaign or kill and restart SWUpdate.
You should find detailed information on the installation process in the
standard output of SWUpdate.

When the update is applied, you can also check the Hawkbit Management UI and
see the status of your rollout campaign changed.

Going further
^^^^^^^^^^^^^

Persistent storage
""""""""""""""""""

The above instructions don't use a database to store artifacts and metadata.
This means that every time Hawkbit will be restarted, its rollout campaigns
will be lost. This is handy for a development environment but unsustainable for
a real world scenario.

You can set up a MariaDB server to keep data between two executions of Hawkbit.
Start by installing the `mariadb-server` package from your distribution's
repositories. Then, make sure the server is running

.. code-block:: bash

    $ systemctl start mariadb-server

Once MariaDB is running, you need to create a database for Hawkbit. For the
rest of the instructions, we will use the default MariaDB user whose username
is *root* and password is empty but you can create a new user and adapt the
instructions accordingly.

.. code-block:: bash

    $ mysql -uroot -p

Then create a database with

.. code-block:: sql

    CREATE DATABASE hawkbit;

You now need to configure Maven to build a MariaDB backend for Java DB. Open
*hawkbit-runtime/hawkbit-update-server/pom.xml* and add the following block
inside the **dependencies** element:

.. code-block:: xml

    <dependency>
        <groupId>org.mariadb.jdbc</groupId>
        <artifactId>mariadb-java-client</artifactId>
        <scope>compile</scope>
    </dependency>

Hawkbit must be configured to connect to the database you created earlier.
Append the following configuration values at the end of
*hawkbit-runtime/hawkbit-update-server/src/main/resources/application.properties*

.. code-block:: INI

    spring.jpa.database=MYSQL
    spring.datasource.url=jdbc:mysql://localhost:3306/hawkbit
    spring.datasource.username=root
    spring.datasource.password=
    spring.datasource.driverClassName=org.mariadb.jdbc.Driver

Finally, run a new build with ``mvn clean install`` and restart Hawkbit. Your
data should now be stored in the database.

Device authentication
"""""""""""""""""""""

Hawkbit offers mechanisms for device authentication. This is a useful security
feature to verify the identity of a target. Details on how to set this up in
the `corresponding Hawkbit documentation page`_.

.. _corresponding Hawkbit documentation page: https://www.eclipse.org/hawkbit/documentation/security/security.html

Appendix: case studies
-----------------------

This appendix summarizes the researches that led to the above choice. The
following paragraphs analyzes various update solutions in the specific context
of PELUX.

`Sysup`_
^^^^^^^^

This is a very simple tool to achieve A/B partition switching. It is actually
just an initramdisk script that runs pivot_root on the wanted partition. It is
very simple and straightforward but actually, it does not even contain an
upgrade solution. Also, it does not allow fallback if the kernel or bootloader
fails. This solution can not be enough for the needs of the automotive industry
and will not be retained for PELUX.

`Smart2`_
^^^^^^^^^

This tool has not been updated for a while, contains lots of legacy code and
pending issues. It is also just a package manager which can not guarantee
atomic updates. Atomic updates being essential in the context of car systems,
smart2 can not be used for PELUX.

`Swupd`_
^^^^^^^^

This solution offers a variety of disk layouts possibilities. It can also
download source from remote or local media which is a good point. However, the
approach of Swupd is to favor speed over failure resilience which means that
the system can end up in an inconsistent state and can not rollback. Also, this
tool is only able to update the rootfs. Overall, this is not an acceptable
solution for the automotive use case and it has not been kept for PELUX.

`Fwup`_
^^^^^^^

This self-contained tool offers a variety of functions useful in the context of
critical embedded systems. It supports atomic updates (with A/B and recovery
schemes) and rollback, digital signature, local and remote updates, potentially
MCUs upgrade thanks to "file-resources" and it integrates well with Yocto.
Unfortunately, it does not support fleet management in itself and needs to be
combined with something else.

`Resin`_
^^^^^^^^

This is a containerized update tool that relies on two Docker containers: a
resin supervisor and an application container both running on top of a
stateless OS. This offers a very interesting approach to zero-downtime
upgrading and A/B partitioning thanks to a "hand over" mechanism between two
application containers. Unfortunately, this tool relies on a commercial offer
with very complex pricing when it comes to large fleet of devices. Moreover,
this tool does not updates the host OS (bootloader, kernel, rootfs) and it
requires applications designed to be ran in a container environment which is
not the case in PELUX. Because of those two reasons, this solution has not been
retained for PELUX.

`Adaptive AUTOSAR UCM`_
^^^^^^^^^^^^^^^^^^^^^^^

The Adaptive Autosar `Update and Configuration Management` functional cluster
that is in charge of distributing updates across the vehicle could potentially 
be developed in the future and become a standard for the industry. However, as
of today, it is purely speculative, it would require a high stage of
integration into an actual vehicle and it would still require some sort of
component in the PELUX Linux platform side to apply the updates. While this is
useful to keep in mind for the future, this can not be retained for PELUX.

`Mender`_
^^^^^^^^^

This is a block based update solution that supports rollback and atomic
updates. It guarantees integrity and authentication security requirements, has
a fully-featured deployment panel and a handy Yocto layer.  Mender is easy to
integrate to an embedded Linux system but at the cost of its lack of
flexibility. Mender imposes an A/B scheme with two additional partitions for
bootloader and data. The kernels also have to be located in the A and B
partitions as files. The goal of PELUX being to serve as a baseline for various
projects, we will prefer a more flexible solution such as one of those detailed
below.

`OSTree`_
^^^^^^^^^

OSTree is an elegant file-based update mechanism that uses hard links to
achieve in-place(no A/B partitioning) atomic updates. It is often described as
a "git for operating systems". It currently benefits from a very large and
active community. It has support for rollback. It integrates with Yocto easily.
It was chosen by AGL for all of those reasons. However, OSTree suffers from
some limitations if the rootfs to be upgraded is corrupted and since OSTree is
only able to update file systems, it can not always upgrade kernels and can not
flash other types of firmwares such as Bootloaders or MCUs. Hence, this
solution may not be enough on its own depending on the needs of the project.

`QtOTA`_
^^^^^^^^

This solution contains a set of scripts and QML APIs to easily integrate OSTree
in a Yocto and Qt/QML system. QtOTA seems preferable over OSTree alone if the
final system is tightly linked to a Qt architecture. However, it suffers from
the same limitations as OSTree such as the incapacity to update Bootloaders or
MCUs.

`GENIVI SOTA (Aktualizr)`_
^^^^^^^^^^^^^^^^^^^^^^^^^^

GENIVI defined a modular architecture for Software over-the-air update
deployment split into a SOTA Server, SOTA Client and installer. The SOTA server
offers various deployment scenarios based a on VIN (vehicle identifiers)
registry. The client side, whose current reference implementation is Aktualizr,
can download any kind of data from the server and relay that to an installer.
It is also worth noting that this implementation supports complex security
mechanisms using Uptane and RVI. Aktualizr is not enough on its own, it needs to
be integrated with an installer to provide a fully featured update solution.

`SWUpdate`_
^^^^^^^^^^^

This tool is extremely flexible, it is even described by its developers as an
update framework. It is fault resilient, supports atomic updates, fallback(with
both A/B and Normal+recovery). it makes few assumptions regarding the base
system, flashes entire compressed images, it can interface with complex fleet
management systems such as Hawkbit, it guarantees integrity and authentication,
offers APIs for GUI integration, is easily integrated to Yocto and can be
extended with handlers to upgrade FPGAs, MCUs or other components and is well
documented. SWUpdate meets the requirements of PELUX.

`RAUC`_
^^^^^^^

This solution is failsafe, atomic, can revert to a previous state, is flexible
enough when it comes to partition layout, uses a bundle of images that can be
downloaded from the network or from local media, interfaces with `Hawkbit`_, has
authentication and integrity mechanisms, offers a DBus API, integrates well
with Yocto and can be extended to flash other components. RAUC is very similar
to SWUpdate and also qualifies for the needs of PELUX.

Conclusions
^^^^^^^^^^^

If RVI (as opposed to just https) or Uptane (as opposed to just TLS) or the
Vehicle fleet management of GENIVI SOTA (as opposed to Hawkbit) is considered
useful, we advise to combine Aktualizr with the upgrade solution chosen below:

If you want to be able to download and flash full images we advise to use
SWUpdate or RAUC (those two solutions offer pretty much the same
functionalities). However, if you decide to use differential updates, we
advise to use OSTree instead.

For PELUX, we decided that Aktualizr was not needed for our use cases. We also
decided to start with full images flashing and maybe explore OSTree later on.
We then chose to start with SWUpdate alone and then combine it with OSTree.

References
^^^^^^^^^^

* https://wiki.yoctoproject.org/wiki/System_Update
* https://konsulko.com/wp-content/uploads/2016/09/Device-sideSoftwareUpdateStrategiesforAGL.pdf
* https://events.static.linuxfound.org/sites/events/files/slides/20170601_Secure_OTA_Updates_for_Vehicles_with_Uptane.pdf
* https://events.static.linuxfound.org/sites/events/files/slides/linuxcon-japan-2016-softwre-updates-sangorrin.pdf
* https://events.static.linuxfound.org/sites/events/files/slides/elc16_angelatos.pdf
* https://elinux.org/images/1/19/Babic--software_update_in_embedded_systems.pdf


.. _Sysup: https://www.codefidence.com/sysup
.. _Smart2: https://github.com/ubinux/smart2
.. _Swupd: https://github.com/clearlinux/swupd-client
.. _Fwup: https://github.com/fhunleth/fwup
.. _Resin: https://resin.io/
.. _Adaptive Autosar UCM: https://www.autosar.org/fileadmin/user_upload/standards/adaptive/17-10/AUTOSAR_SWS_UpdateAndConfigManagement.pdf
.. _Mender: https://mender.io/
.. _OSTree: https://ostree.readthedocs.io/en/latest/
.. _QtOTA: http://doc.qt.io/QtOTA/
.. _GENIVI SOTA (Aktualizr): https://github.com/advancedtelematic/aktualizr
.. _SWUpdate: https://sbabic.github.io/swupdate/
.. _RAUC: https://www.rauc.io/
.. _Hawkbit: https://www.eclipse.org/hawkbit/
