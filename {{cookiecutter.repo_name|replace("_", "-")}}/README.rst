{{cookiecutter.project_name}}  |Travis|_ |Codecov|_
===================================================
.. |Travis| image:: https://travis-ci.org/edx/{{cookiecutter.repo_name|replace("_", "-")}}.svg?branch=master
.. _Travis: https://travis-ci.org/edx/{{cookiecutter.repo_name|replace("_", "-")}}

.. |Codecov| image:: http://codecov.io/github/edx/{{cookiecutter.repo_name|replace("_", "-")}}/coverage.svg?branch=master
.. _Codecov: http://codecov.io/github/edx/{{cookiecutter.repo_name|replace("_", "-")}}?branch=master

The ``README.rst`` file should start with a brief description of the repository, which sets it in the context of other repositories under the ``edx`` organization. It should make clear where this fits in to the overall edX codebase. You may also want to provide a brief overview of the code in this repository, including the main components and useful entry points for starting to understand the code in more detail, or link to a comparable description in your repo's docs.

Documentation
-------------
.. |ReadtheDocs| image:: https://readthedocs.org/projects/{{cookiecutter.repo_name|replace("_", "-")}}/badge/?version=latest
.. _ReadtheDocs: http://{{cookiecutter.repo_name|replace("_", "-")}}.readthedocs.io/en/latest/

`Documentation <https://{{cookiecutter.repo_name|replace("_", "-")}}.readthedocs.io/en/latest/>`_ is hosted on Read the Docs. The source is hosted in this repo's `docs <https://github.com/edx/{{cookiecutter.repo_name|replace("_", "-")}}/tree/master/docs>`_ directory. To contribute, please open a PR against this repo.

License
-------

The code in this repository is licensed under version 3 of the AGPL unless otherwise noted. Please see the LICENSE_ file for details.

.. _LICENSE: https://github.com/edx/{{cookiecutter.repo_name|replace("_", "-")}}/blob/master/LICENSE

How To Contribute
-----------------

Contributions are welcome. Please read `How To Contribute <https://github.com/edx/edx-platform/blob/master/CONTRIBUTING.rst>`_ for details. Even though it was written with ``edx-platform`` in mind, these guidelines should be followed for Open edX code in general.

Reporting Security Issues
-------------------------

Please do not report security issues in public. Please email security@edx.org.

Get Help
--------

Ask questions and discuss this project on `Slack <https://openedx.slack.com/messages/general/>`_ or in the `edx-code Google Group <https://groups.google.com/forum/#!forum/edx-code>`_.
