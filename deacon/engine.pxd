from libc.math cimport exp as cexp
from libc.math cimport sqrt as csqrt
from libc.math cimport pow as cpow

import numpy as np
cimport numpy as np

from .option cimport Option
from .marketdata cimport MarketData
from .utils.utils cimport dbinom
from .utils.rand cimport rnorm

cdef class PricingEngine:
    cdef double calculate(self, Option option, MarketData data)


cdef class BinomialEngine(PricingEngine):
    cdef unsigned long _nsteps

    cdef double calculate(self, Option option, MarketData data)

cdef class EuropeanBinomialEngine(BinomialEngine):
    cdef double calculate(self, Option option, MarketData data)


cdef class MonteCarloEngine(PricingEngine):
    cdef unsigned long _nreps
    cdef unsigned long _nsteps
    cdef double calculate(self, Option option, MarketData data)


cdef class NaiveMonteCarloEngine(MonteCarloEngine):
    cdef double calculate(self, Option option, MarketData data)


cdef class BlackScholesControlVariateEngine(MonteCarloEngine):
    cdef double BSdelta(self, double St, double K, double tau, double sig, double r, double div)
    cdef double calculate(self, Option option, MarketData data)


