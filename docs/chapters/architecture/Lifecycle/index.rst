:orphan:

.. _Life cycle-Management:

Life cycle management
=====================

Introduction and goals
----------------------

The life cycle cluster is a set of components that work closely with each other
to define and implement the functionality required in the life cycle of a typical
IVI scope.

Requirements Overview
^^^^^^^^^^^^^^^^^^^^^

- Life cycle Management must override blocking consumers on shutdown
- Supply Management must be able to route hardware power events
- The system should detect the wake up reason to prevent or modify start-up if
  functionality is not needed
- The system functionality to store necessary data is depending on the shutdown
  mode
- In diagnostic or flash sessions the life cycle is controlled by diagnostic
- Before a managed reset/reboot, the system provides a degraded mode in order
  to maintain main user services
- The system has the ability to delay the shutdown depending on application state
- The system has the ability to manage a timeout to shutdown depending on application
  state
- The system has to follow the global car operation modes
- There must be a normal operation mode
- The system can be woken up by the user pressing the Power On button on the ECU
- The system can be woken up by the user inserting a CD/DVD in the drive
- The system can be woken up by the user pressing the CD/DVD eject button
- The system can be woken up by an active bus signal
- The system can be shutdown by a specific Clamp State notification
- The system can be shutdown by the ECU after a product defined timeout when there is
  no active Clamp State
- The system can be instructed to shutdown by an external tester
- There must be a parking mode
- There must be an operation mode for transporting the cars
- There must be an operation mode for building the cars in factories
- There must be an operation mode for flashing devices
- There must be a thermal management
- Following power up, the system is gradually functional
- The life cycle must provide watchdog functionality for system applications
- The ECU must handle an immediate power off
- The life cycle must ensure safety critical applications can always be started by the
  driver
- To provide Log&Trace data for problem analysis the DLT must be supported
- Accordingly to its state, the system could generate a reset/reboot
- The system must support a real time clock and an uptime clock
- For specific states, the system is not allowed to reboot
- There must be a communication mode
- There must be a shutdown delay mode
- The Life cycle Management can stop applications or reboot the system if a CPU load
  threshold is reached
- The emergency call must be possible in all situations where the customer is present
- The system can be woken up from network/bus signals
- Life cycle Management must be able to perform a fast system shutdown when requested [1]_

Constraints
-----------

The Life cycle management system should:

- API should provide functionality to modify the set of power events an
  already-registered consumer is interested in
- The Life cycle Management needs a dependency graph to resolve start-dependencies
- Work on a typical embedded Linux context
- Be open source software

Use cases
---------

- pre-shutdown, a “passive” mode, is the obvious use-case
- low-voltage and similar scenarios. Here, power consumption needs to be reduced,
  and some services might want to do that while staying loaded.
- postponed shutdown of certain services, e.g. allowing the user to complete an
  ongoing phone call before shutting down.
- various special modes that may require actions / mode-changes from multiple
  components, e.g. factory reset, workshop mode, etc

Context and Scope
-----------------

The purpose of this section is to put the GENIVI Life cycle Management system into
a broader context, and show how this subsystem interacts with other parts of the
larger PELUX system.

Technical Context
^^^^^^^^^^^^^^^^^

The life cycle cluster is a set of components that work closely with each other to
define and implement the functionality required in the life cycle of a typical
IVI scope.

The functional scope of Life cycle is illustrated in this diagram:

.. image:: https://at.projects.genivi.org/wiki/download/attachments/11567160/LC-Scope.png?version=1&modificationDate=1455743777000&api=v2

Building Block View
-------------------

.. image:: https://at.projects.genivi.org/wiki/download/attachments/11567160/LC-StructureDefScope.png?version=1&modificationDate=1455743897000&api=v2

Node State Manager
^^^^^^^^^^^^^^^^^^

The Node State Manager (NSM) is the central functional component that gathers
information on the current running state of the embedded system. The NSM
component provides a common implementation framework for the system state machine.
It collates information from multiple sources and uses the data to determine the
current state(s).

Based on the given data, the NSM notifies registered consumers
(applications or other platform components) of relevant changes in system state.
Node state information can also be requested on-demand via provided D-Bus interfaces.
The node state manager also provides shutdown management including shutdown request
notification to consumers.

The node state management is the last/highest level of escalation on the node and will
issue the reset instruction and supply control logic. It is notified of errors and other
status signals from components that are responsible for monitoring system health.

Internally, node state management is made up of a common generic component, Node State
Manager (NSM), and a system-specific state machine (NSMC) that is plugged into the Node
State Manager. Through this architecture there can be a standardized solution with stable
interfaces towards the applications, which still allows for product-specific behavior
through the definition of the specific state machine. [2]_

Node State Machine
^^^^^^^^^^^^^^^^^^

In order to get a use of Node State Manager functionality, a state machine should be
implemented.

GENIVI project provides two examples of such a state machine:

- First one is part of the NSM package and located at NodeStateMachineStub folder and
  contains a simple stub for such a state machine;
- The second one can be found at https://github.com/GENIVI/simple-node-state-machine and
  is a an implementation of simple state machine which plugs into the GENIVI NSM and adds
  a simple DBus Shutdown interface which will shut down the machine. It is used within
  the GDP to provide an example of how to integrate a Node State Machine with the NSM.
  It is a nice and simple example of how to integrate a Node State Machine with the
  Node State Manager.

Risks and Technical Debt
------------------------

Risks
^^^^^

- Many packages are not being maintained for years: normally GENIVI contracts software
  companies to design and develop software without allocating any budget to pay for its
  maintenance

  Mitigation: PELUX team should try to fix found issues in GENIVI software and mainstream
  all the changes. PELUX team and/or Luxoft should also try to be an active member of the
  GENIVI Alliance to develop internal expertise in the GENIVI IVI ecosystem.

- Generally poor documentation

  Mitigation: PELUX team should obtain all the necessary knowledge about used GENIVI
  software and create own comprehensive know-how documentation.


.. [1] https://docs.projects.genivi.org/lifecycle/genivi-140814-1502-9.pdf
.. [2] https://at.projects.genivi.org/wiki/display/PROJ/Node+State+Manager
