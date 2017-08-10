Licensing
=========

Each source code file needs to mention which license applies and who owns
the copyright in the file header. The purpose of this is to make it
absolutely clear, for both humans and tooling, which license applies to
that particular file even when the file is moved to another project. In
order to achieve what is stated above, the header should include:

* A copyright statement
* A license header
* An SPDX tag

Examples of this setup for different programming languages can be found here:
https://github.com/Pelagicore/OpenSourceTemplates/tree/master/examples

The rationale behind using both a license header and an SPDX tag is to
make it readable for humans that do not know the abbreviations of
licenses as well as making it explicit enough to support compliance
tooling in a future proof way. As SPDX is the licensing standard that
compliance tooling will be using in the future, and indeed already is
used by tool makers such as WindRiver and Black Duck, they are included
both for support for tooling and future proofing the format.
