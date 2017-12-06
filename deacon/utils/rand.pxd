cdef extern from "<random>" namespace "std":
    cdef cppclass mt19937

    cdef cppclass normal_distribution[T]

    cdef cppclass uniform_real_distribution[T]


cpdef double[::1] rnorm(unsigned long nreps, unsigned long seed, double mean, double sd)

cpdef double[::1] runif(unsigned long nreps, unsigned long seed, double a, double b)

cpdef double[::1] StratifiedSample(unsigned long nreps, unsigned long seed, double a, double b)
