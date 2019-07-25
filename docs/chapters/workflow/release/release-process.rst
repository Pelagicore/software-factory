PELUX Release Process
=====================

The release process for PELUX describes what's needed in order to make a release
of PELUX. This includes artifacts, properties, notes, and an actual how-to for
moving forward with a release.

There are two types of releases, source releases, and binary releases. A binary
release has all the requirements of a source release and more. This split is for
licensing reasons, as there are more obligations when doing a binary release.

Binary release
--------------
Binary images (starting from Pelux 3.0) are now available for `releases`_.
Each new release will have a set of binary images supporting the various
variants as mentioned below.

Currently 4 different platforms are supported:
- Intel x86_64
- Raspberry Pi 3
- Automotive Reference Platform
- QEMU

2 flavors are offered for each hardware platform: Qt Auto image as well as the
minimal one, while only minimal image is offered for QEMU.

Besides the images an SDK is also available.
The file name for the SDK installer looks like this:
``pelux-glibc-x86_64-core-image-pelux-qtauto-neptune-dev-<VARIANT>.sh``

.. This is to get red and green colours for the symbols below
.. role:: available
.. role:: unavailable
.. raw:: html

    <!-- The defined roles in rst will translate to style sheet classes -->
    <style> .available {color:green} .unavailable {color:red} </style>

+--------------------------------------------+------------------+------------------+------------------+-------------------+
|                                            |      Variant name                                                          |
+          Image name                        +------------------+------------------+------------------+-------------------+
|                                            | intel            | arp              | rpi              | qemu              |
+============================================+==================+==================+==================+===================+
| core-image-pelux-minimal-dev               | :available:`✔`   | :available:`✔`   | :available:`✔`   | :available:`✔`    |
+--------------------------------------------+------------------+------------------+------------------+-------------------+
| core-image-pelux-qtauto-neptune-dev        | :available:`✔`   | :available:`✔`   | :available:`✔`   | :unavailable:`✘`  |
+--------------------------------------------+------------------+------------------+------------------+-------------------+ 


Source release
--------------
The release process for PELUX sources follows the guidelines set up in the
`Yocto Development Manual`_. The URL for PELUXs' released sources is here_.


List of artifacts
^^^^^^^^^^^^^^^^^
- A manifest file (.xml) pointing out all layers used in a Yocto build of the
  PELUX baseline. Would typically be `pelux.xml` in the pelux-manifests
  repository. If the upcoming release is targeting several poky releases, a
  separate manifest should be used for each poky release targeted.
- A version of the PELUX SDE
- A version of the PELUX Baseline Software Factory + Software Factory Blueprint,
  with instructions matching the platform and SDE so that one can build with the
  beforementioned manifest file(s). This means that there could be a need for
  several versions of these as well, if there are changes in instructions
  between releases.
- A file with release notes containing:
    - Release version and name.
    - Major changes since last release.
    - Instructions or pointers to instructions that have changed as a result of
      the changes since last release.
    - This list of artifacts.
- Compressed Binary Wic bz2 images of all the variants for all the supported
  platforms and corresponding bmap files.
- The source code of all the packages that are included in the released images.
- SDK installers for all the supported hardware platforms.

Component attributes for a PELUX release
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
To properly map a release of the PELUX Baseline, we collect a number of
attributes for the components that make up a release. This goes further than
only the artifacts produced in the release, since an artifact can be an
aggregate of several components (such as Yocto layers).

Versioning
    The PELUX Baseline uses a release versioning scheme similar to what Debian
    uses for their releases. A version number is X.Y where X and Y are integers.
    Most releases will be X.0, with bug fixes and security updates in subsequent
    X.Y releases. Any more substantial development done after a release will go
    into the next release.

Git tags
    Wherever we use git tags below, the tag name should map to the version name.
    This can be done by tagging it as ``PELUX_<Version>`` or similar, depending
    on what repository it is.

Yocto manifests
"""""""""""""""
The Yocto manifest has the following attributes:

* Branch name
* Git tag

The branch name is generic and should map to a Yocto release branch name,
whereas the git tag is specific and maps to a specific commit on that branch.

Yocto layers
""""""""""""
For our own Yocto layers, we collect the following attributes to tie them to a
release:

* Branch name
* Git tag

The branch name is generic and should map to a Yocto release branch name,
whereas the git tag is specific and maps to a specific commit on that branch.
Once set and part of a release, the tag should not be moved. See the reasoning
around versioning above.

The following of our own layers are included in a PELUX baseline release:

* meta-arp
* meta-bistro
* meta-pelux
* meta-template

PELUX SDE
"""""""""
For the PELUX SDE, we collect the following attributes to tie it to a release:

* Branch name
* Git tag

PELUX Baseline Software Factory
"""""""""""""""""""""""""""""""
For the PELUX Baseline Software Factory, we collect the following attributes to
tie them to a release:

* Branch name
* Git tag

For the Software Factory, the branch name should match the version number.

Other files
"""""""""""
Release notes
    For the release notes, they should simply be named
    ``PELUX_<VERSION>_Release_Notes`` where <VERSION> is the version number of
    the release.


.. _`Yocto Development Manual`: https://www.yoctoproject.org/docs/1.8/dev-manual/dev-manual.html#providing-the-source-code
.. _here: https://pelux.io/artifacts/pelux/3.0/sources/source-release/
.. _`releases`: https://pelux.io/releases/
