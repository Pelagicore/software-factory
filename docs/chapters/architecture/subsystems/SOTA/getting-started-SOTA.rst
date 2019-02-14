.. _getting-started-sota:

Getting started with Hawkbit and SWUpdate
-----------------------------------------

Due to a lack of clear instructions available on the internet, this appendix
details the necessary steps to setup a local installation of Hawkbit and
interface it with a PELUX system. This should be enough to set up a local
development environment but extra steps would be needed for a real updates
deployment context.

Context
^^^^^^^

For the rest of the tutorial, we will assume you have two machines connected
on an IP network:

- A development machine running a standard Linux distribution. We will assume
  that this machine has the *192.168.3.11* IP address. This machine must have
  Java 8 (Both OpenJDK and Oracle Java 1.8 work), Maven and rabbitmq-server
  installed.
- A raspberrypi3 running PELUX. Other platforms should have similar
  configurations in the future but the Raspberry Pi is currently the only
  supported platform.

Compiling SWUpdate artifacts
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can generate update artifacts of PELUX from your Yocto build directory
using bitbake. For example a .swu file for *core-image-pelux-minimal* can be
generated using:

.. code-block:: bash

    $ bitbake core-image-pelux-minimal-update

The resulting file can then be found at:
*build/tmp/deploy/images/raspberrypi3/core-image-pelux-minimal-update-raspberrypi3.swu*

More details can be found in the :ref:`building-PELUX-sources` page.

Hawkbit installation
^^^^^^^^^^^^^^^^^^^^

We will fetch Hawkbit from its GitHub repository.

.. code-block:: bash

    $ git clone https://github.com/eclipse/hawkbit
    $ cd hawkbit

Recent versions of Hawkbit are not yet supported by SWUpdate so we need to
manually select a slightly older version of Hawkbit.

.. code-block:: bash

    $ git checkout 0.2.0M4

We can now compile Hawkbit using Maven.

.. code-block:: bash

    $ mvn clean install

And run the generated Hawkbit Server:

.. code-block:: bash

    $ java -jar ./hawkbit-runtime/hawkbit-update-server/target/hawkbit-update-server-0.2.0-SNAPSHOT.jar

Accessing the Hawkbit panel
^^^^^^^^^^^^^^^^^^^^^^^^^^^

As detailed in the main part of this document, Hawkbit offers two mechanisms
for artifacts management: the Management UI and the Management API. We will
detail the usage of the Management UI here.

You can access the Management UI from a Web Browser on the development machine
by opening the following URL: http://localhost:8080

The default credentials are:

- **username:** *admin*
- **password:** *admin*

To change those logins, you need to modify
hawkbit-runtime/hawkbit-update-server/src/main/resources/application.properties
and recompile Hawkbit using ``mvn clean install``.

Running SWUpdate in Surricata mode
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Before setting up a deployment campaign on Hawkbit, we will start SWUpdate on
the machine running PELUX to let Hawkbit know our device exists.

.. code-block:: bash

    $ swupdate -H raspberrypi3:1.0 -e stable,alt -f /etc/swupdate.cfg -l 5 -u '-t DEFAULT -u http://192.168.3.11:8080 -i DeviceID'

.. note:: - The `H` option specifies the hardware name and revision.
          - The `e` option selects the software and mode that should be used
            (for instance: alt installs on the partition B, main installs on
            the partition A).
          - The `f` option points to the SWUpdate config file.
          - The `l` option chooses a verbose log level.
          - The `u` option is followed by options dedicated to the Surricata
            mode.
          - The `t` option selects the tenant ID of the device.
          - The second `u` option points to the Hawkbit instance you want to
            download your artifacts from.
          - The `i` option represents the id of the device.

You should now see a new target appearing in the left side of the Deployment
tab of Hawkbit with the name you chose as *"DeviceID"* in the above command.

Update campaign rollout
^^^^^^^^^^^^^^^^^^^^^^^

Upload
""""""

- Go to the **Upload** tab from the left selector
- Create a Software Module of type "OS" named Rootfs of version 1.0 and then
  click on it
- Use the "Upload file" button to select the .swu file you generated earlier
  and then press the "Process" button to validate the upload

`Note:`: Hawkbit offers "Management APIs" that can potentially automatize those
steps.

Distribution Management
"""""""""""""""""""""""

- Go to the **Distributions Management** tab from the left selector
- Create a Distribution of type "OS with app(s)", named PELUX of version 1.0
- Drag and drop the Rootfs on the right pane onto the PELUX distribution on the
  left pane
- Click the actions button and apply the changes

Target Filters
""""""""""""""

- Go to the **Target Filters** tab from the left selector
- Create a new filter named "Default filter" and use a generic filter such as
  "name==*"

Rollout
"""""""
- Go to the **Rollout** tab from the left selector
- Create a new rollout campaign named "PELUX 1.0 Deployment". Select the PELUX
  distribution set, the default filter and enter 1 in the "Number of groups"
  field. You should see stats of deployment appearing
- Press the "Play" icon on the right side of your rollout campaign to activate
  the deployment

Applying the update
^^^^^^^^^^^^^^^^^^^

At this point, you can either wait for a while, so that SWUpdate polls for
updates and finds the new deployment campaign or kill and restart SWUpdate.
You should find detailed information on the installation process in the
standard output of SWUpdate.

When the update is applied, you can also check the Hawkbit Management UI and
see the status of your rollout campaign changed.

Going further
^^^^^^^^^^^^^

Persistent storage
""""""""""""""""""

The above instructions don't use a database to store artifacts and metadata.
This means that every time Hawkbit will be restarted, its rollout campaigns
will be lost. This is handy for a development environment but unsustainable for
a real world scenario.

You can set up a MariaDB server to keep data between two executions of Hawkbit.
Start by installing the `mariadb-server` package from your distribution's
repositories. Then, make sure the server is running

.. code-block:: bash

    $ systemctl start mariadb-server

Once MariaDB is running, you need to create a database for Hawkbit. For the
rest of the instructions, we will use the default MariaDB user whose username
is *root* and password is empty but you can create a new user and adapt the
instructions accordingly.

.. code-block:: bash

    $ mysql -uroot -p

Then create a database with

.. code-block:: sql

    CREATE DATABASE hawkbit;

You now need to configure Maven to build a MariaDB backend for Java DB. Open
*hawkbit-runtime/hawkbit-update-server/pom.xml* and add the following block
inside the **dependencies** element:

.. code-block:: xml

    <dependency>
        <groupId>org.mariadb.jdbc</groupId>
        <artifactId>mariadb-java-client</artifactId>
        <scope>compile</scope>
    </dependency>

Hawkbit must be configured to connect to the database you created earlier.
Append the following configuration values at the end of
*hawkbit-runtime/hawkbit-update-server/src/main/resources/application.properties*

.. code-block:: INI

    spring.jpa.database=MYSQL
    spring.datasource.url=jdbc:mysql://localhost:3306/hawkbit
    spring.datasource.username=root
    spring.datasource.password=
    spring.datasource.driverClassName=org.mariadb.jdbc.Driver

Finally, run a new build with ``mvn clean install`` and restart Hawkbit. Your
data should now be stored in the database.

Device authentication
"""""""""""""""""""""

Hawkbit offers mechanisms for device authentication. This is a useful security
feature to verify the identity of a target. Details on how to set this up in
the `corresponding Hawkbit documentation page`_.

.. _corresponding Hawkbit documentation page: https://www.eclipse.org/hawkbit/documentation/security/security.html

.. tags:: howto

References
^^^^^^^^^^

* https://wiki.yoctoproject.org/wiki/System_Update
* https://konsulko.com/wp-content/uploads/2016/09/Device-sideSoftwareUpdateStrategiesforAGL.pdf
* https://events.static.linuxfound.org/sites/events/files/slides/20170601_Secure_OTA_Updates_for_Vehicles_with_Uptane.pdf
* https://events.static.linuxfound.org/sites/events/files/slides/linuxcon-japan-2016-softwre-updates-sangorrin.pdf
* https://events.static.linuxfound.org/sites/events/files/slides/elc16_angelatos.pdf
* https://elinux.org/images/1/19/Babic--software_update_in_embedded_systems.pdf

