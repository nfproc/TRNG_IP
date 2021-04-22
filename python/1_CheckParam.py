# Sample Script to Check Some Parameters 2021.04.22 Naoki F., AIT
# See COPYING file for licensing information.

from . import TRNGCore
from pynq import Overlay
from pynq import allocate
import numpy as np

pl = Overlay("trng_ip.bit")
rng = pl.TRNG_IP_0
dma = pl.axi_dma_0
buffer = allocate(shape=(1024,), dtype=np.uint32)

for i in range(16):
    rng.parameter = i
    rng.start(4096)
    dma.recvchannel.transfer(buffer)
    rng.wait()
    dma.recvchannel.wait()
    print("ID: {0}, Avg: {1:.5f}, Data: {2:08x}".format(i, rng.sum_data/32768, buffer[0]))
    rng.stop()
    
buffer.freebuffer()