.. _getting-started-swc:

Getting Containerized Applications up and running in PELUX
----------------------------------------------------------

Preparing the Launcher
^^^^^^^^^^^^^^^^^^^^^^

An essential part of integrating a complete solution for containerization is to implement some 
kind of an Application Launcher, which is responsible for launching applications in either 
containerized or non-containerized mode. It should also be responsible for setting up sandboxes 
for containerized applications and then launch the application entry point.

In PELUX `QtApplicationManager`_ is used as the launcher to run Neptune3 UI applications in 
containerized form. Qt Application Manager provides a plugin interface to configure, set up and 
launch containerized applications. The container plugin interface is described in `Containers`_ 
section of QtApplicationManager documentation. This requires implementing the `ContainerInterface`_ 
and `ContainerManagerInterface`_

.. _QtApplicationManager: http://code.qt.io/cgit/qt/qtapplicationmanager.git/
.. _Containers: https://doc.qt.io/QtApplicationManager/containers.html
.. _ContainerInterface: https://doc.qt.io/QtApplicationManager/containerinterface.html
.. _ContainerManagerInterface: https://doc.qt.io/QtApplicationManager/containermanagerinterface.html

Using the Qt Application Manager Plugin Interface, an example plugin is developed to communicate 
with SoftwareContainerAgent. This plugin is available as part of Qt Application Manager code 
and serves as an example of how to develop a container plugin for Qt Application Manager. The 
code for the plugin is available `here`_ under the **examples/softwarecontainer-plugin**.

.. _here: https://github.com/qt/qtapplicationmanager

Launcher Configuration
^^^^^^^^^^^^^^^^^^^^^^

Neptune3 UI is integrated as default UI for PELUX. As part of the integration, Neptune3 UI uses 
a default configuration located at **/opt/neptune3/am-config.yaml**. However, this configuration is 
not enough to enable softwarecontainer-plugin and run Neptune3 applications inside 
softwarecontainer. There is another configuration file integrated to append to the default 
configuration, located at **/opt/am/sc-config.yaml**. This configuration enables the 
softwarecontainer-plugin as well as defines what Neptune3 applications should be run inside the 
container. See the contents of **/opt/am/sc-config.yaml** below,

.. code-block:: bash

    #
    # Copyright Pelagicore 2017
    #
    formatVersion: 1
    formatType: am-configuration
    ---
    containers:
      selection:
        - com.pelagicore.calendar: "softwarecontainer"
        - "*": "process"

      softwarecontainer:
        dbus: system

    plugins:
      container: [ "/usr/lib/libsoftwarecontainer-plugin.so" ]

The above configuration defines what software container plugin to use as well as Neptune3's 
calendar application to run inside software container, while running the rest of the applications 
on the host system as normal processes.

All above mentioned configurations and plugin libraries are installed as part of default PELUX software 
container integration. The above configuration can be modified to either use a different plugin or run 
different applications inside a container.

Service Manifest
^^^^^^^^^^^^^^^^

Service manifest files are used to define capabilities that can be assigned to software containers. 
Capabilities are a way to define the container's access to the host system's environment, services and 
resources. Each capability defines its access to the host system through definition of several 
gateways. Software container provides several gateways which are described in detail in the `Gateway`_ 
chapter of `Software Container documentation`_. The below service manifest configuration is 
defined/integrated with PELUX in **/etc/softwarecontainer/service-manifest.d/io.qt.ApplicationManager.Application.json**. 
It contains one capability that defines dbus, wayland and device gateways which are required 
to run Neptune3 UI calendar application inside a container. Several capabilities can be defined in 
the same file with different sets of gateway accesses. It is the responsibility of the Launcher 
application to map and assign appropriate capabilities to each application that it intends to 
launch in a container. The `Service manifests`_ page provides some examples on how to configure this 
file.

.. _Gateway: https://pelagicore.github.io/softwarecontainer/user-docs/chapters/gateways/00-index.html
.. _Software Container documentation: https://pelagicore.github.io/softwarecontainer/user-docs/
.. _Service manifests: https://pelagicore.github.io/softwarecontainer/user-docs/chapters/service-manifests/index.html#service-manifests

.. code-block:: bash

    #
    # Copyright Pelagicore 2017
    #
    {
      "version": "1",
      "capabilities": [
        {
          "name": "io.qt.ApplicationManager.Application",
          "gateways": [
            {
              "id": "dbus",
              "config": [
                {
                 "dbus-gateway-config-session": [
                    {
                      "direction": "*",
                      "interface": "*",
                      "object-path": "*",
                      "method": "*"
                    }
                  ],
                 "dbus-gateway-config-system": [
                    {
                      "direction": "*",
                      "interface": "*",
                      "object-path": "*",
                      "method": "*"
                    }
                  ]
                }
              ]
            },
            {
              "id": "wayland",
              "config": [
                {
                  "enabled": true
                }
              ]
            },
            {
              "id": "devicenode",
              "config": [
                {
                  "name": "/dev/dri/renderD128"
                },
                {
                  "name": "/dev/tty0"
                },
                {
                  "name": "/dev/tty1"
                }
              ]
            }
          ]
        }
      ]
    }

.. tags:: howto
