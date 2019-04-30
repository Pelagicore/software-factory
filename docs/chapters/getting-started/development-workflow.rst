Development Workflow
====================

The development workflow depends on what is intended to be developed.

If the intention is to add or modify a component/service then one should use the SDK.

If it's a bigger development task modifying the platform itself then the more appropriate
way is to build the system image from sources.

Component development
---------------------
* Flash the target with the intended image
* `Fetch <../sdk/installing-the-sdk.html>`_ the SDK
* `Install <../../swf-blueprint/docs/articles/sdk/installing-the-sdk.html>`_ the SDK 
* Develop your component following the recommended `Git workflow <../../swf-blueprint/docs/articles/workflow/git-workflow.html>`_
* `Cross compile <../../swf-blueprint/docs/articles/sdk/using-the-sdk-to-crosscompile.html>`_ your component
* `Deploy <../../swf-blueprint/docs/articles/sdk/run-binary-on-target.html>`_ your compiled component on target

Platform development
--------------------
* Follow these `instructions <../../chapters/baseplatform/building-PELUX-sources.rst>`_
