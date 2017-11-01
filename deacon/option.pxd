from .payoff cimport Payoff

cdef class Option:
    cdef double _expiry
    cdef Payoff _payoff

    cpdef payoff(self, double spot)
