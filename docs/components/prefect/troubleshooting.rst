Prefect troubleshooting
=======================

Kubernetes agent is not able to spawn jobs with proper imagePullSecrets
-----------------------------------------------------------------------

Solution
    I track down the issue in the prefect core code, and found that the imagePullSecrets were being defined in a wrong level. I sent the issue to a contributor and he fixed. Next version will contain the fix.

Python versions mismatch
------------------------
Symptoms
    ``SystemError: unknown opcode``

Solution
    This is a mismatch of the python version of the client and server. Make sure both are running with same python version. Note that python server runs with python==3.6.


Limitations
-----------
The prefect UI current version (2020-12-18) does not yet support the project management page as well as authorization. The project management pages will  be shipped soon as per the `this PR <https://github.com/PrefectHQ/ui/pull/520>`_.

Source: https://prefect-community.slack.com/archives/C0192RWGJQH/p1608741030131200?thread_ts=1608734132.129300&cid=C0192RWGJQH