# cython: nonecheck=False
# cython: boundscheck=False
# cython: wraparound=False
# cython: language_level=3
# cython: cdivision=True

import numpy as np
cimport numpy as c
from scipy.stats import norm

cdef class PricingEngine:
    """A base class for option pricing engines."""
    cdef double calculate(self, Option option, MarketData data):
        pass


cdef class BinomialEngine(PricingEngine):
    """An interface class for binomial pricing engines."""
    def __init__(self, nsteps, nreps):
        self._nsteps = nsteps
        self._nreps = nreps

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
    """
    A concrete class for the American Binomial Option Pricing model.
    """

    cdef double calculate(self, Option option, MarketData data):
        cdef double dt = option.expiry / self._nsteps
        cdef double u = cexp((data.rate - data.div) * dt + data.vol * csqrt(dt))
        cdef double d = cexp((data.rate - data.div) * dt - data.vol * csqrt(dt))
        cdef double pu = (cexp((data.rate - data.div) * dt) - d)/ (u - d)
        cdef double pd = 1.0 - pu
        cdef double disc = cexp(-data.rate * dt)
        cdef double dpu = disc * pu
        cdef double dpd = disc * pd
        cdef unsigned long num_nodes = self._nsteps + 1
        cdef double[::1] spot_t = np.empty(num_nodes, dtype=np.float64)
        cdef double[::1] call_t = np.empty(num_nodes, dtype=np.float64)
        cdef unsigned long i, j

        for i in range(num_nodes):
            spot_t[i] = data.spot * cpow(u, self._nsteps - i) * cpow(d, i)
            call_t[i] = option.payoff(spot_t[i])

        for i in range(self._nsteps - 1, -1, -1):
            for j in range(i + 1):
                call_t[j] = dpu * call_t[j] + dpd * call_t[j+1]
                spot_t[j] = spot_t[j] / u
                call_t[j] = np.maximum(call_t[j], option.payoff(spot_t[j]))

        return call_t[0]


cdef class MonteCarloEngine(PricingEngine):
    """
    An interface class for Monte Carlo pricing engines.
    """

    def __init__(self, nsteps, nreps):
        self._nsteps = nsteps
        self._nreps = nreps
    cdef double calculate(self, Option option, MarketData data):
        pass


cdef class NaiveMonteCarloEngine(MonteCarloEngine):
    """
    A concrete class for a Naive Monte Carlo pricing engine.
    """


    cdef double calculate(self, Option option, MarketData data):
        cdef double dt = option.expiry
        cdef double rate = data.rate
        cdef double spot = data.spot
        cdef double vol = data.vol
        cdef double div = data.div
        cdef unsigned int seed = np.random.randint(low=1, high=100000, size=1)[0]
        cdef double[::1] z = rnorm(self._nreps, seed, 0.0, 1.0)
        cdef double[::1] spot_t = np.empty(self._nreps, dtype=np.float64)
        cdef double[::1] payoff_t = np.empty(self._nreps, dtype=np.float64)
        cdef double disc = cexp(-(rate - div) * dt)
        cdef double nudt = (rate - div - 0.5 * vol * vol) * dt
        cdef double sigdt = vol * csqrt(dt)

        for i in range(self._nreps):
            spot_t[i] = spot * cexp(nudt + sigdt * z[i])
            payoff_t[i] = option.payoff(spot_t[i])
        cdef double price = np.mean(payoff_t) * disc

        return price

cdef class BlackScholesControlVariateEngine(MonteCarloEngine):
    cdef double BSdelta(self, double St,double tau,double K,double sig,double r,double div):
        cdef double d1 = (np.log((St/K))+(r - div + (sig*sig*0.5)*(tau))) / (sig * csqrt(tau))
        cdef double delta = cexp(-div*tau) * norm.cdf(d1)
        return delta

    cdef double calculate(self, Option option, MarketData data):
        cdef double dt = option.expiry/self._nsteps
        cdef unsigned int seed = np.random.randint(low=1, high=100000, size=1)[0]
        cdef long int N = self._nsteps
        cdef long int M = self._nreps
        cdef double r = data.rate
        cdef double div = data.div
        cdef double sig = data.vol
        cdef double beta1 = -1
        cdef double nudt = (r - div - 0.5 *sig*sig) *dt
        cdef double sigsdt = sig*csqrt(dt)
        cdef double erddt = cexp((r-div)*dt)
        cdef double[::1] St = np.empty(self._nreps, dtype=np.float64)
        cdef double[::1] cv = np.empty(self._nreps, dtype=np.float64)
        cdef double[::1] maxes = np.empty(self._nsteps, dtype=np.float64)
        cdef long int i 
        cdef long int j
        cdef double[::1] z = np.empty(self._nreps, dtype=np.float64)
        cdef double Stn
        cdef double tau
        cdef double delta
        for j in range(M):
            z = rnorm(self._nreps, seed, 0.0, 1.0)
            St[0] = data.spot
            cv[0] = 0.0
        										
    											
            for i in range(2, N):
                tau = (i-1)*dt
                delta = self.BSdelta(St[0],tau,option.strike, sig, r, div)
                Stn = St[i-1]*cexp(nudt + sigsdt * z[i])
                cv[i] = cv[i-1] + delta*(Stn - St[i-1]* erddt)
                St[i] = Stn
            maxes[j] = option.payoff(np.max(St)) + beta1*np.mean(cv)
        cdef double callprc = np.mean(maxes)*cexp(-r * option.expiry)  				  
        cdef double sterr = maxes.std()/(csqrt(M))
        return (callprc, sterr)

