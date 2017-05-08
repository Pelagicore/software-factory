
Git workflow
************

The suggested workflow when working in a somewhat large project with git, given that one does not
use gerrit or a similar tool, is a rather general pull request based flow. The following flow is
general enough so that it works in both GitHub, GitLab and Bitbucket, at least.

Assume in the examples below that the URL to the repo is
``git@github.com:Pelagicore/software-factory.git``.

General setup
=============
#. Fork the repo. That fork will end up at ``git@github.com:<username>/software-factory.git``
#. Clone the original fork and add a remote for the upstream to the repo ::

    $ git clone git@github.com:<username>/software-factory.git
    $ git remote add upstream git@github.com:Pelagicore/software-factory.git

This will make the fork have ``origin`` as remote name, which we thing feels most natural for most
developers, as it is the repository the developer will typically push to.  On the other hand, we
recommend to always type the remote and branch name when pushing, which forces the developer to be
more explicit about their intentions.

For each set of changes
=======================
#. Check out the master branch and make sure it is up to date ::

   $ git checkout master
   $ git pull upstream master
   $ git push origin master

#. Check out a new branch to work on ::

   $ git checkout -b some_branch_name

   This is optional, it is possible to work on master as well, but it has the downside of making
   master blocked while waiting for merge.

#. Do some work, and commit it. ::

   $ touch new_file
   $ git add new_file
   $ git commit -s -m "add new_file"

#. Make sure your branch is up-to-date with master ::

   $ git pull upstream master --rebase

    This is to make sure that any conflicts that exist before pushing are resolved locally before
    pushing. It might be the case that there are more people working on the same code that has a
    pull request which just got accepted, which would lead to a conflict in master. Then it is
    better to resolve the conflict in the local branch before creating a new pull request. To keep
    the git log clear of empty merge commits, we recommend rebasing.

#. Push to the forked remote ::

   $ git push origin some_branch_name

#. Create a pull request in whatever web frontend for git is being used

Make sure the rest of the team is notified of the pull request. There are different ways of handling
changes to the pull request. Either any new changes can be added to an existing commit and
force-pushed to the forked repo, or they can be added on top of the existing commit. The pull
request will be updated either way.

Whenever the team is satisfied with the changes, pull the changes in by accepting the pull request.
