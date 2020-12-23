# 6510 3wire simplex

simple serial data sending and receiving

sender:
this short routine is useful for debugging simple 6510 systems, since not much
hardware is required.  the 6510 has a IO-port on the processor-chip.  so no
other IO port is required.  With only a ROM/EPROM, a reset and a clock a
computer-system can be built.

receiver:
the Userport of a commodore-computer (e.g. C64, VIC20, C128, etc) can be used
to receive debug-information from the sender.

Oliver K.
