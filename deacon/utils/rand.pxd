cdef extern from "<random>" namespace "std":
    cdef cppclass mt19937

    cdef cppclass normal_distribution[T]

cpdef double[::1] rnorm(unsigned int nreps, unsigned int seed, double mean, double sd)
