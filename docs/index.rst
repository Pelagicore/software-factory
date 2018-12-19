Welcome to the PELUX Development Handbook
*****************************************
Revision: |release|

-------------------

What is PELUX?
--------------
From pelux.io_:

    *PELUX is an agnostic reference integration platform that enables you to
    build and develop automotive Linux-based systems without vendor lock-in.
    As an open source solution accelerator, PELUX helps you prototype and create
    production-ready, converged automotive systems, including advanced
    driver-assistance systems (ADAS), telematics units and in-vehicle
    infotainment systems.*

What is the Development Handbook?
---------------------------------
The PELUX Development Handbook documentation contains processes, instructions
and how-tos for how to work with PELUX, as well as instructions for how to
create a standalone project based on PELUX.


Why PELUX?
^^^^^^^^^^
PELUX is an agnostic reference integration platform for building automotive
Linux-based systems, e.g. In-Vehicle Infotainment (IVI) systems. IVI systems
are usually responsible for everything shown in the dashboard of the car as
well as the head-unit, which is usually placed in or above the center stack
where one normally had just a radio back in the days.

IVI systems are obviously put into cars by its car maker. However, most car
makers do not develop the software for these systems in-house, but they contract
a large software supplier. These software suppliers usually provide both
hardware and software as a bundle.

With such a bundle, the software usually will only work on the specific
hardware, and the only one who the car maker can utilize for upgrades or support
is the supplier. This leads to vendor lock-in, and it is something we believe is
bad.

With PELUX, the car maker can start working on the software directly without the
need for specific hardware. PELUX works on commodity hardware and for developing
UI software or generic middleware there is usually no need for the automotive
grade hardware anyway. PELUX is modular enough so that once the need for
automotive grade hardware arises, it can be easily modified to work with that
hardware.

PELUX being open-source together with readily-available instructions in this
handbook, a car maker, or any interested individual, can experiment with the
system, build prototypes or simply download and run it.


.. _pelux.io: https://pelux.io

-------------------

.. toctree::
    :caption: Table of contents
    :maxdepth: 2

    chapters/architecture/index
    chapters/baseplatform/index
    chapters/ci-and-cd/index
    chapters/workflow/git/index
    chapters/sdk/index
    chapters/sde/index
    swf-blueprint/docs/articles/templates/index
    swf-blueprint/docs/articles/licensing/index
    chapters/workflow/release/index

.. toctree::
    :caption: About
    :maxdepth: 2

    swf-blueprint/docs/articles/intro/index.rst

.. toctree::
    :caption: Categories
    :maxdepth: 1

    categories/howto.rst
    categories/process.rst
