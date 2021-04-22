# Sample Script to Write Random BitStream to File 2021.04.22 Naoki F., AIT
# See COPYING file for licensing information.

from . import TRNGCore
from pynq import Overlay
from pynq import allocate
import numpy as np

NUM_BLOCKS = 16

pl = Overlay("trng_ip.bit")
rng = pl.TRNG_IP_0
dma = pl.axi_dma_0
buffer_r = allocate(shape=(1024,), dtype=np.uint32)
buffer_w = allocate(shape=(1024,), dtype=np.uint32)
file = open("random.dat", "wb")

rng.parameter = 1
rng.start(NUM_BLOCKS * 4096)

for i in range(NUM_BLOCKS):
    dma.recvchannel.transfer(buffer_r)
    if i != 0:
        buffer_w.tofile(file)
    dma.recvchannel.wait()
    if i == 0:
        print("Head: {0:08x}".format(buffer_r[0]))
    buffer_r, buffer_w = buffer_w, buffer_r
    
rng.stop()
buffer_w.tofile(file)
file.close()
buffer_r.freebuffer()
buffer_w.freebuffer()