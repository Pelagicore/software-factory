PELUX Release Process
=====================

The release process for PELUX describes what's needed in order to make a release
of PELUX. This includes artifacts, properties, notes, and an actual how-to for
moving forward with a release.

There are two types of releases, source releases, and binary releases. A binary
release has all the requirements of a source release and more. This split is for
licensing reasons, as there are more obligations when doing a binary release.

Source release
--------------
In a source release, we release no binaries, which means that any binary parts,
such as the platform itself, will have to be built by the user.

List of artifacts
^^^^^^^^^^^^^^^^^
* A manifest file (.xml) pointing out all layers used in a yocto build of the
  PELUX baseline. Would typically be `pelux.xml` in the pelux-manifests
  repository.
* A version of the PELUX Baseline Software Factory + Software Factory Blueprint,
  with instructions matching the platform one can build with the beforementioned
  manifest file.
* A file with release notes containing:
    * Release version and name.
    * Major changes since last release.
    * Instructions or pointers to instructions that have changed as a result of
      the changes since last release.
    * This list of artifacts.


Component attributes for a PELUX release
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
TBD

How-to release PELUX
^^^^^^^^^^^^^^^^^^^^
TBD


Binary release
--------------
TBD
