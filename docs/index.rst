Welcome to the PELUX Baseline Software Factory
**********************************************
Revision: |release|

-------------------

What is the Software Factory?
-----------------------------
The Software Factory documentation contains processes, instructions and how-tos
for how to work with PELUX, as well as instructions for how to create a
standalone project based on PELUX.

What is PELUX?
--------------
From pelux.io_:

    *PELUX is a Linux based platform for your automotive infotainment project.
    The PELUX software architecture is optimized to secure the shortest path
    from silicon to pixel and thereby provide optimal performance to deliver a
    stunning infotainment solution. It’s based on Yocto and offers an improved
    developer experience.*


Why PELUX?
^^^^^^^^^^
PELUX is a base platform for building automotive infotainment systems (IVI
systems for short). IVI systems are usually responsible for everything shown in
the dashboard of the car as well as the head-unit, which is usually placed in or
above the center stack where one normally had just a radio back in the days.

IVI systems are obviously put into cars by its car maker. However, most car
makers don't develop the software for these systems in-house, but they contract
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
Software Factory, a car maker, or any interested individual, can experiment with
the system, build prototypes or simply download and run it.


.. _pelux.io: https://pelux.io

-------------------

.. toctree::
    :caption: About
    :maxdepth: 2

    swf-blueprint/docs/articles/intro/index.rst

.. toctree::
    :caption: Table of contents
    :maxdepth: 2

    chapters/workflow/git/index
    chapters/baseplatform/index
    chapters/ci-and-cd/index
    chapters/sdk/index
    chapters/sde/index
    chapters/architecture/index
    swf-blueprint/docs/articles/templates/index
    swf-blueprint/docs/articles/licensing/index
    chapters/workflow/release/index

.. toctree::
    :caption: Categories
    :maxdepth: 1

    categories/howto.rst
    categories/process.rst
