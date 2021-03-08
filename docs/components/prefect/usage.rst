Usage of Prefect
================

How Prefect works
-----------------

1. You write your pipeline as a set of Prefect *Tasks*.
2. You connect the Tasks into a graph called a *Flow*.
3. You register the Flow in Prefect *Server*.
4. Prefect *Agent* runs your Flow at a given schedule or when you request it.

