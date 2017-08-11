Creating a manifest
===================

Manifest repositories are used to store repo tool [#repotool]_ manifests. These manifests are used, in repo tool, to fetch all the sources, tools and scripts needed to build a PELUX-based system.

The PELUX project contains a good reference [#pelux-manifests]_ for how a manifest repository
should look like. When creating a new manifest repository, it is a good idea to duplicate the PELUX manifests, and see which parts can be kept in your own manifests.

It is not necessary to ``git clone`` the PELUX manifests, since the git history is likely not important for your project. Instead of ``git clone``:ing the manifests, you may opt to simply copy them. To do this, browse to the PELUX manifests GitHub page [#pelux-manifests]_, and press the "Clone or download" button, then press "Download ZIP".

In the examples below, it is assumed that the downloaded zip is named "pelux-manifests.zip".

Creating a git repo for the new manifests
-----------------------------------------

The ``repo`` tool assumes all manifests to be stored in a git repo, to keep track of changes, thus a new git repository must be created for the manifests.

.. code-block:: bash

    $ mkdir my-manifests
    $ cd my-manifests
    $ git init
    $ unzip <path-to-zip>/pelux-manifests.zip

Do not stage and commit the newly unpacked files just yet. Some tweaks must be done to the files before they can be re-used by your project.

Tweaking the manifest files
---------------------------

Below follows general recommendations for modifications of common files.

* The ``ci-scripts`` directory can likely be kept as-is, if these scripts seem useful for your project
* The ``doc`` directory should contain extra documentation for the repository, if applicable
* The vagrant-cookbook directory should contain a ``git submodule`` pointing to ``git@github.com:Pelagicore/vagrant-cookbook.git``, or a different repository containing vagrant scripts. This submodule is used by the ``Vagrantfile``, and is only needed if Vagrant [#vagrant]_ is used for the project.
* CONTRIBUTING, LICENSE, and README should be updated according to the ``pelux-manifests`` license and your project guidelines
* The ``Dockerfile`` can likely be left as-is, and can be customized according to your project needs for Docker builds
* The ``Jenkinsfile`` sets up a Jenkins [#jenkins]_ pipeline [#jenkinspipeline]_ for Continuous Integration (CI) builds of your manifest. This file must be modified to accomodate your project. In particular:
  * Directory names must be updated (for example, the TEMPLATECONF variable bust be set to match your layer structure)
  * Image names must be updated to reflect your own image names (``core-image-pelux`` may become ``core-image-yourproject``)
  * In general, this file can be customized to suite your project's CI needs
* The ``Vagrantfile`` should be usable as-is, but can be modified to accommodate your project's CI and virtualized build needs
* The ``xml`` files in the repository are the actual manifest files. The manifest files in the repository must be modified to indicate the correct repositories. It is common to structure the manifets files in a hierachical fashion, such that a common base manifest is created, and (possibly several) specialized manifests include this base manifest. An example of this can be seen in the PELUX manifests repository, where the ``pelux-base.xml`` manifest is included in, for instance, the ``pelux-intel.xml`` and ``pelux-rpi.xml`` manifests.

.. [#repotool] https://source.android.com/source/using-repo
.. [#pelux-manifests] https://github.com/Pelagicore/pelux-manifests
.. [#vagrant] https://source.android.com/source/using-repo
.. [#jenkins] https://www.vagrantup.com/
.. [#jenkinspipeline] https://jenkins.io/doc/book/pipeline/
