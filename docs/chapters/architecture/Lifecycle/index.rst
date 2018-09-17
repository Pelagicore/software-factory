:orphan:

.. _Life cycle-Management:

Life cycle management
=====================

Introduction and goals
----------------------

The life cycle cluster is a set of components that work closely with each other
to define and implement the functionality required in the life cycle of a typical
IVI scope.

Stakeholders
^^^^^^^^^^^^

+-----------------------+--------------------------+---------------------------+
| Role                  | Description              | Goal, Intention           |
+=======================+==========================+===========================+
| PELUX Developer       | Maintains the            | Wants to configure the    |
|                       | distribution             | GENIVI Life cycle         |
|                       |                          | Management components     |
|                       |                          | for base case scenarios   |
+-----------------------+--------------------------+---------------------------+
| BSP Developer         | Adapts PELUX to new      | Wants to integrate the    |
|                       | platforms, builds        | GENIVI Life cycle         |
|                       | systems based on PELUX   | Management components     |
|                       |                          | on new platforms          |
+-----------------------+--------------------------+---------------------------+

Constraints
-----------

The Life cycle management system should:

- work on a typical embedded Linux context
- be open source software

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
through the definition of the specific state machine. [1]_

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


.. [1] https://at.projects.genivi.org/wiki/display/PROJ/Node+State+Manager
