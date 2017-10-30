cimport numpy as np

cdef class Payoff:
    """An abstract base class for option payoffs."""
    def __init__(self, strike):
        self._strike = strike


cdef class VanillaCallPayoff(Payoff):
    """A concrete class for plain vanilla call option payoff."""
    cpdef payoff(self, double spot):
        return np.maximum(spot - self._strike, 0.0)


cdef class Option:
    def __init__(self, expiry, payoff):
        self._expiry = expiry
        self._payoff = payoff

    cpdef payoff(self, double spot):
        return self._payoff.payoff(spot)


cdef class PricingEngine:
    """An abstract base class for option pricing engines."""
    cdef double calculate(self, Option option, MarketData data):
        pass


cdef class BinomialEngine(PricingEngine):
    """An interface class for binomial pricing engines."""
    def __init__(self, nsteps):
        self._nsteps = nsteps

    cdef double calculate(self, Option option, MarketData data):
        pass

cdef class AmericanBinomialEngine(BinomialEngine):
    """A concrete class for the American Binomial Option Pricing model."""
    cdef double calculate(self, Option option, MarketData data):
        cdef double dt = option.expiry / self._nsteps
        cdef double u = np.exp((data.rate - data.div) * dt + data.vol * np.sqrt(dt))
        cdef double d = np.exp((data.rate - data.div) * dt - data.vol * np.sqrt(dt))
        cdef double pu = (np.exp((data.rate - data.div) * dt) - d)/ (u - d)
        cdef double pd = 1.0 - pu
        cdef double disc = np.exp(-data.rate * dt)
        cdef double dpu = disc * pu
        cdef double dpd = disc * pd
        cdef long numNodes = self._nsteps + 1

        cdef double[:] spot_t = np.empty(numNodes, dtype=np.float64)
        cdef double[:] call_t = np.empty(numNodes, dtype=np.float64)




        
 
 





