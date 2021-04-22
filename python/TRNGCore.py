# TRNG Core Module for Pynq + TRNG IP Core 2021.04.22 Naoki F., AIT
# See COPYING file for licensing information.

from pynq import DefaultIP

class TRNGCore(DefaultIP):
    ADDR_GO         = 0x00
    ADDR_STOP       = 0x00
    ADDR_RUN        = 0x00
    ADDR_OVER       = 0x00
    MASK_RUN        = 0x1
    MASK_OVER       = 0x2
    ADDR_SEND_BYTES = 0x04
    ADDR_SENT_BYTES = 0x04
    ADDR_DMA_BYTES  = 0x08
    ADDR_SUM_DATA   = 0x08
    ADDR_PARAMETER  = 0x0c
    ADDR_STATS      = 0x0c
    send_bytes = 0
    
    def __init__(self, description):
        super().__init__(description=description)
        self.stop()
        
    bindto = ['xilinx.com:user:TRNG_IP:1.0']
    
    def start (self, total, dma_size = 4096):
        self.write(self.ADDR_SEND_BYTES, total)
        self.write(self.ADDR_DMA_BYTES, dma_size)
        self.write(self.ADDR_GO, 1)
        self.send_bytes = total
    
    def wait (self):
        if self.send_bytes != 0:
            while True:
                if (self.read(self.ADDR_RUN) & self.MASK_RUN) == 0:
                    break
        if (self.read(self.ADDR_OVER) & self.MASK_OVER) != 0:
            raise OSError("TRNG Buffer Overflow")
        
    def stop (self):
        self.write(self.ADDR_STOP, 0)
    
    parameter = property()
    @parameter.setter
    def parameter(self, value):
        self.write(self.ADDR_PARAMETER, value)
    
    @property
    def sent_bytes(self):
        return self.read(self.ADDR_SENT_BYTES)
    
    @property
    def sum_data(self):
        return self.read(self.ADDR_SUM_DATA)
    
    @property
    def user_stats(self):
        return self.read(self.ADDR_STATS)
