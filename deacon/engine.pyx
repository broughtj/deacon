cdef class PricingEngine:
    """A base class for option pricing engines."""
    cdef double calculate(self, Option option, MarketData data):
        pass


cdef class BinomialEngine(PricingEngine):
    """An interface class for binomial pricing engines."""
    def __init__(self, nsteps):
        self._nsteps = nsteps

    cdef double calculate(self, Option option, MarketData data):
        pass


cdef class EuropeanBinomialEngine(BinomialEngine):
    """A concrete class for the European binomial option pricing model."""

    cdef double calculate(self, Option option, MarketData data):
        cdef double expiry = option.expiry
        cdef double strike = option.strike
        cdef double spot = data.spot
        cdef double rate = data.rate
        cdef double vol = data.vol
        cdef double div = data.div
        cdef double dt = expiry / self._nsteps
        cdef double u = cexp(((rate - div) * dt) + vol * csqrt(dt))
        cdef double d = cexp(((rate - div) * dt) - vol * csqrt(dt))
        cdef double pu = (cexp((rate - div) * dt) - d) / (u - d)
        cdef double pd = 1.0 - pu
        cdef double df = cexp(-rate * expiry)
        cdef double spot_t = 0.0
        cdef double payoff_t = 0.0
        cdef unsigned long nodes = self._nsteps + 1
        cdef unsigned long i

        for i in range(nodes):
            spot_t = spot * (u ** (self._nsteps - i)) * (d ** i)
            payoff_t += option.payoff(spot_t) * dbinom(self._nsteps - i, self._nsteps, pu)

        return df * payoff_t


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
        cdef unsigned long i
        cdef unsigned long j
        cdef double[:] spot_t = np.empty(numNodes, dtype=np.float64)
        cdef double[:] call_t = np.empty(numNodes, dtype=np.float64)
        for i in range(numNodes):
            spot_t[i] = S * (u ** (self._nsteps - i)) * (d ** (i))
		    call_t[i] = option.payoff(spot_price[i])
        for i in range((self._nsteps-1), -1, -1):
		    for j in range(i+1):
                call_t[j] = dpu * call_t[j] + dpd * call_t[j+1]
			    spot_t[j] = spot_t[j] / u
		        call_t[j] = np.maximum(call_t[j], option.payoff(spot_t[j]))
        return call_t[0]
 





