Specifications of Versatile TRNG IP Core
========================================

Basic Specs
-----------

- 2 AXI Interfaces: AXI Lite for control, AXI Stream for data
  - The AXI stream interface is connected to AXI DMA IP

- Interface with internal random number generator circuit
  - RNG_EN  : circuit enable input  =  1 bit
  - PARAM   : parameter input       = 32 bit (max.)
  - DATA_OUT: data output           = 16 bit (max.)
  - DATA_EN : data enable output    =  1 bit                 

- Data transform circuit
  - LSB of data output is serial-to-parallel converted to 32-bit words
    and sent to the FIFO
  - The sum of data output is output as a statistic
 
- FIFO
  - 32 bit x 1024 word (BRAM x 1)
  - The output is sent out as AXI Stream interface signals
  - Overflow of the FIFO is recorded

- メモリマップ
  - 0x00
    - W -> 1 to start generating random numbers, 0 to stop it
              `RNG_GO`, `RNG_STOP`
    - R -> +1 if random numbers are being generated, +2 when the FIFO has been overflown
              `RNG_RUN`, `RNG_OVER`
  - 0x04
    - W -> the number of bytes to send (0 = infinite)
              `RNG_SEND_BYTES`
    - R -> the number of bytes sent
              `RNG_SENT_BYTES`
  - 0x08
    - W -> the number of bytes per DMA transfer
              `RNG_DMA_BYTES`
    - R -> the sum of data output
              `RNG_SUM_DATA`
  - 0x0C
    - W -> user defined parameter
              `RNG_PARAMETER`
    - R -> user defined statistics
              `RNG_STATS`

Use cases
---------

- Use Case 1: check if a parameter of TRNG is appropriate
  1. set the number of bytes to send
  2. set the parameter
  3. start the random number generation
  4. start the DMA receive channel
  5. wait for the core to finish the generation
  6. check the statistics
  7. finalize the generation

- Use Case 2: generate random numbers continuously using double buffering
  1. set the number of bytes to send
  2. set the parameter
  3. start the random number generation
  4. start the DMA receive channel
  5. save the contents of the previous buffer (exc. the first time)
  6. wait for the DMA core to finish
  7. repeat 4-6 for some times
  8. finalize the random number generation
  9. save the contents of the last buffer
  
Notice
------

The same amount of data as the specified number of bytes to send must
be received by DMA. Otherwise, an error will occur in the AXI DMA core.

You can generate random numbers continuously by writing 0 as the number
of bytes to send; however, due to the above limitation, once you stop
random number generation, you cannot start it again.
You will have to write the overlay again to recover.