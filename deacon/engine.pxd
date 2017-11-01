from libc.math cimport exp as cexp
from libc.math cimport sqrt as csqrt

import numpy as np
cimport numpy as np

from .option cimport Option
from .marketdata cimport MarketData
from .utils cimport dbinom

cdef class PricingEngine:
    cdef double calculate(self, Option option, MarketData data)


cdef class BinomialEngine(PricingEngine):
    cdef unsigned long _nsteps

    cdef double calculate(self, Option option, MarketData data)

cdef class EuropeanBinomialEngine(BinomialEngine):
    cdef double calculate(self, Option option, MarketData data)




