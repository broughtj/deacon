# payoff.pyx

import numpy as np
cimport numpy as np


cdef class Payoff:
    """A base class for option payoffs."""
    def __init__(self, strike):
        self._strike = strike

    property strike:
        def __get__(self):
            return self._strike

        def __set__(self, strike):
            self._strike = strike


cdef class VanillaCallPayoff(Payoff):
    """A concrete class for vanilla call option payoff."""
    cpdef payoff(self, double spot):
        return np.maximum(spot - self._strike, 0.0)


cdef class VanillaPutPayoff(Payoff):
    """A concrete class for vanilla put option payoff."""
    cpdef payoff(self, double spot):
        return np.maximum(self._strike - spot, 0.0)


