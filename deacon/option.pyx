cdef class Option:
    def __init__(self, expiry, payoff):
        self._expiry = expiry
        self._payoff = payoff

    property expiry:
        def __get__(self):
            return self._expiry

        def __set__(self, expiry):
            self._expiry = expiry

    property strike:
        def __get__(self):
            return self._payoff.strike

        def __set__(self, strike):
            self._payoff.strike = strike

    cpdef payoff(self, double spot):
        return self._payoff.payoff(spot)
