Troubleshooting
***************

Services
########

Feast
=====

Wrong telemetry host
--------------------
PROBLEM: When interacting with a Client, following error occurs although the client was created with a different ``core_url``::

    ConnectionError: Connection timed out while attempting to connect to localhost:6566

SOLUTION: Disable telemetry by creating a Client with ``telemetry=False``.
