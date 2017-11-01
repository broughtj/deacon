cdef class Payoff:
    cdef double _strike


cdef class VanillaCallPayoff(Payoff):
    cpdef payoff(self, double spot)


cdef class VanillaPutPayoff(Payoff):
    cpdef payoff(self, double spot)
