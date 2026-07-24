# System Info Modules

The `SysInfo` singleton reads data from many different sources, and I
don't want to predict which of the tools on my system are going to be
on everyone else's systems. 

The `base` directory contains the base definitions that determine what 
properties the UI is expecting; "concrete" modules are then defined here
for obtaining this data in whatever way makes sense for them.

I'm considering how to implement some kind of "fallback" system into
this, so that users could define a "preferred" module and then use
something else if that happens to not be working.
