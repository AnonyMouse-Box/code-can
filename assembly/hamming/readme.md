**Hamming**

In this folder I'd like to explore building disassembling/reassembling of hamming codes in ARM assembly. To set a few ground rules it ought to be done in binary should be no shorter than 1 data bit i.e. 3-bit code [3,1,3] as little point if not carrying data, and no longer than 128-bit as CPUs only directly handle 64-bit computation and the same principles just carry on for higher numbers this means adding on the hamming code would make the maximum 136-bit code [136,128,2]. Imperfect code is acceptable but it should always adhere to the hamming standard and perfect divisions 3,7,15,31,63,127 should be the default. Assembly is chosen due to it being bit level operations and to improve speed it is better to operate at the lowest level possible.

To achieve this there are a number of logical steps, some of which may require knowledge I don't currently have, and others may even require stepping outside of assembly to pull in the necessary operations to achieve the goals:
* The program must read in from a stream of binary digits.
* It must read from the stream and take only the required number of digits without damaging or obfuscating any of them taken or not taken.
* To know how many digits to take it must first take some form of input and have a sensible default process to calculate the ideal number.
* Once taken the program must then perform an operation on the code to break it up where necessary and insert the parity codes at the powers of 2.
* These parity codes must correctly recognise what value they need to be to provide an odd or even number of 1s, which it is doesn't matter, but it must be consistent and it must be specified.
* Once constructed this set of digits including hamming code should be presented up in the form of a packet that can be sent to the TCP/UDP stack for sending.
* Finally the biggest step of all, it also needs to be able to perform this entire process in reverse, take an unwrapped packet of binary data, read the parity checks, correct any errors, remove the hamming code, reconstruct the original string and output so it can be picked up by a program.
