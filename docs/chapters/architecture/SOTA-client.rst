:orphan:

.. _SOTA-client:

SOTA client
===========

Introduction and goals
----------------------

Requirements overview
^^^^^^^^^^^^^^^^^^^^^

Basic usage
"""""""""""

Basic requirements
""""""""""""""""""

Quality goals
^^^^^^^^^^^^^

Stakeholders
^^^^^^^^^^^^

Constraints
-----------

System scope and context
------------------------

Business context
^^^^^^^^^^^^^^^^

Technical context
^^^^^^^^^^^^^^^^^

Solution strategy
-----------------

Building blocks view
--------------------

Runtime view
------------

Deployment view
---------------

Cross-cutting concepts
----------------------

Design decisions
----------------

Quality requirements
--------------------

Risks and technical debts
-------------------------

Glossary
--------

Appendix: case studies
-----------------------

This appendix summarizes the researches that led to the above choice. The
following paragraphs analyzes various update solutions in the specific context
of PELUX.

`Sysup`_
^^^^^^^^

This is a very simple tool to achieve A/B partition switching. It is actually
just an initramdisk script that runs pivot_root on the wanted partition. It is
very simple and straightforward but actually, it doesn't even contain an
upgrade solution. Also, it doesn't allow fallback if the kernel or bootloader
fails. This solution can not be enough for the needs of the automotive industry
and will not be retained for PELUX.

`Smart2`_
^^^^^^^^^

This tool hasn't been updated for a while, contains lots of legacy code and
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
solution for the automotive use case and it hasn't been kept for PELUX.

`Fwup`_
^^^^^^^

This self-contained tool offers a variety of functions useful in the context of
critical embedded systems. It supports atomic updates (with A/B and recovery
schemes) and rollback, digital signature, local and remote updates, potentially
MCUs upgrade thanks to "file-resources" and it integrates well with Yocto.
Unfortunately, it doesn't support fleet management in itself and needs to be
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
not the case in PELUX. Because of those two reasons, this solution hasn't been
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

GENIVI defined a modular architecture for Software Over The Air update
deployment split into a SOTA Server, SOTA Client and installer. The SOTA server
offers various deployment scenarios based a on VIN (vehicle identifiers)
registry. The client side, whose current reference implementation is Aktualizr,
can download any kind of data from the server and relay that to an installer.
It is also worth noting that this implementation supports complex security
mechanisms using Uptane and RVI. Aktualizr isn't enough on its own, it needs to
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

For PELUX, we decided that Aktualizr wasn't needed for our use cases. We also
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
