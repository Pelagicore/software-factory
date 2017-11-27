PELUX Continuous Integration jobs
=================================

For the PELUX Baseline, the Jenkins instance at `pelux.io/jenkins
<http://pelux.io/jenkins>`_ has some predefined jobs that we run regularly or on
commit.

Jenkins jobs
------------
The jobs available in our Jenkins set up can be divided into three categories,
yocto builds, Software Factory builds and meta jobs.

Many of the jobs we have are `multi-branch pipelines`_. In Jenkins terms, this
means that it scans the repository it is configured for, and builds any branches
and any pull requests. This makes it easy to build for sanity checking a pull
request before pulling it in, while still automatically building the target
branches whenever they are changed.

Building pull requests works for at least both GitHub and GitLab, and PELUX uses
GitHub for this.

A multi-branch pipeline is triggered whenever there is a change to any of the
branches or pull requests in the repository. Depending on network set up, this
can be done by polling the repo or by using a webhook. Since the PELUX Jenkins
is publicly available, we're using webhooks. This also ensures that there is no
delay from push to build.

Yocto builds
^^^^^^^^^^^^
The yocto builds currently do not archive any artifacts. This is for legal
reasons, as archiving the artifacts on a public Jenkins instance would
constitute "distribution" as described in the GNU GPL. When we build a binary
release of PELUX, we will archive the artifacts and the complete and
corresponding source code.

We use a cache for all Yocto jobs except the nightly. The reason behind that is
to ensure that a clean build (which is what a typical user would do) works as
expected.

PELUX-manifests
    This is set up as a multi-branch pipeline job. It builds a full PELUX
    baseline system with all four configurations (Intel and Raspberry Pi 3, with
    and without QtAuto for each).

Pelux-manifests-nightly
    Builds the three main branches (master + two latest yocto releases) in all
    configurations, without cache, every night.

Software Factory
^^^^^^^^^^^^^^^^
Software Factory Blueprint Build
    A multi-branch pipeline that builds the Software Factory Blueprint.

PELUX Software Factory Build
    A multi-branch pipeline that builds the PELUX Software Factory. If
    successful, triggers a build of the software-factory-deploy job (see below).

Meta
^^^^
The following jobs are specific to the set up of pelux.io, and are therefore
considered meta jobs.

pelux.io Website Build
    A multi-branch pipeline that builds the `pelux.io <https://pelux.io>`_
    website. If successful, triggers a build of the pelux.io Website Deploy job
    (see below)

pelux.io Website Deploy
    Copies the artifacts stored from pelux.io Website Build to the web server
    where pelux.io is served.

PELUX Software Factory Deploy
    Copies the artifacts stored from PELUX Software Factory to the web server
    where `pelux.io/software-factory <https://pelux.io/software-factory>`_ is
    served.

Wipe Cache Weekly
    Wipes out the Yocto cache once a week to make sure it doesn't grow out of
    control.

.. _multi-branch pipelines: https://wiki.jenkins.io/display/JENKINS/Pipeline+Multibranch+Plugin
