Creating a PELUX release
========================

Tasks needed to prepare PELUX for release
-----------------------------------------
#. Choose version number.
#. Decide what Yocto release to follow.
#. Decide what Qt version to support.
#. Prepare the manifest and layers.
#. Prepare the Software Factory Baseline.
#. Prepare the release notes.
#. Announce the release.
#. Post-release retrospective.

How-to perform the tasks
------------------------
In many of the tasks below, one is required to create both a branch and a tag.
The rationale for this is that minor changes made after a release should go into
the same branch, but will get a new tag with an updated minor version number.

Before touching any files
^^^^^^^^^^^^^^^^^^^^^^^^^
* Choose version number. If this is a regular release, it should be ``X.0``
  where X is the major version from the latest release incremented by one.
  If this is a minor release (bugfixes, typos etc), it will be ``X.Y``, where X
  is the major version from the latest release, and Y is the minor version
  number from latest release incremented by one.
* Decide on what Yocto release to follow. If this is a major release then
  this is usually the latest Yocto release. If this is minor release, then
  this was already decided when the major release was done, and you should
  not change it.
* Decide on what Qt version to support. The Qt project does not follow the
  same release cadence as the Yocto project does. This will typically be the
  latest Qt version on a major release, and the same as for the major
  release in a minor release.

Prepare the manifest
^^^^^^^^^^^^^^^^^^^^
* Prepare the layers

  * Create a branch in each layer we maintain matching the Yocto release
    that this PELUX release is targeting. This probably already exists, in
    which case make sure that the branch is up-to-date.
  * Create a tag in the branch pointing to the latest commit in the branch.

* Create a release branch in pelux-manifests.
* Point to specific layer revisions in ``pelux.xml`` and push the manifest to
  the release branch.

    * Don't point to tags here, since tags are moving targets. We create
      tags in our own layers for convenience, and to make maintenance
      easier, but don't point to them here.
    * Make sure the commits pointed to are on the branches matching the
      Yocto release we're targeting.
    * For the Qt layers, point to revisions for the Qt release targeted in
      this PELUX Baseline release.

* Make sure the manifest builds properly in the CI system for all variants
  without any unexpected warnings and with no errors.
* Make sure each variant works on target as intended.
* Make sure the SDK builds properly for all variants
* Create a tag in the release branch.

Prepare the SDE
^^^^^^^^^^^^^^^
* Make sure the SDE can be used with the latest build of the platform SDK for
  all variants available
* Create a release branch
* Create a tag in the release branch

Prepare the Software Factory Baseline
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* Sync the Baseline with the Blueprint.
* Make sure the docs are built properly by the CI system without warnings.
* Proofread the generated docs.
* Create a release branch, and push the latest docs to it.
* Make sure the PELUX version is set in ``CMakeLists.txt``.
* Create a tag in the release branch.
* Make sure the CI system builds and deploys the release version of the docs to
  ``pelux.io/software-factory/<VERSION>/``.

Prepare the release notes
^^^^^^^^^^^^^^^^^^^^^^^^^
* Write down all the information from the steps done before touching any
  files into the release notes.
* Point out the branch, tag and commit for the manifest used in the release.
* Point out the branch, tag and commit for the SDE used in the release.
* Point out the branch, tag and commit for the PELUX Software Factory
  Baseline used in the release.
* Mention that the release notes themselves are part of the release.

Announce the release
^^^^^^^^^^^^^^^^^^^^
* Update the downloads page on ``pelux.io``. Put the release notes there.
* Write a blog post on ``pelux.io`` announcing the release.
* Post about the release to other relevant channels (mailing lists, social media
  etc).

After releasing
^^^^^^^^^^^^^^^
* It is an important part of the process to improve the process. Make sure this
  is done, and that any changes made are being documented.
* Increment any major version numbers on the master branches of the components
  that are part of the release, so that it becomes clear that future development
  belongs to the next release.

.. tags:: howto
