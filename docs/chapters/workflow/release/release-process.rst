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
- A manifest file (.xml) pointing out all layers used in a Yocto build of the
  PELUX baseline. Would typically be `pelux.xml` in the pelux-manifests
  repository.
- A version of the PELUX Baseline Software Factory + Software Factory Blueprint,
  with instructions matching the platform one can build with the beforementioned
  manifest file.
- A file with release notes containing:
    - Release version and name.
    - Major changes since last release.
    - Instructions or pointers to instructions that have changed as a result of
      the changes since last release.
    - This list of artifacts.


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

* meta-bistro
* meta-pelux
* meta-template

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

How-to release PELUX
^^^^^^^^^^^^^^^^^^^^
TBD


Binary release
--------------
TBD

