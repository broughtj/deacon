import numpy as np
cimport numpy as np

cdef extern from "<random>" namespace "std":
    cdef cppclass mt19937:
        mt19937()
        mt19937(unsigned int seed)

    cdef cppclass normal_distribution[T]:
        normal_distribution()
        normal_distribution(T mean, T stddev)
        T operator()(mt19937 gen)

    cdef cppclass uniform_real_distribution[T]:
        uniform_real_distribution()
        uniform_real_distribution(T a, T b)
        T operator()(mt19937 gen)


cpdef double[::1] rnorm(unsigned long nreps, unsigned long seed, double mean, double sd):
    cdef double[::1] values = np.empty(nreps, dtype=np.float64)
    cdef mt19937 gen = mt19937(seed)
    cdef normal_distribution[double] dist = normal_distribution[double](mean, sd)
    cdef unsigned long i

    for i in range(nreps):
        values[i] = dist(gen)

    return values


cpdef double[::1] runif(unsigned long nreps, unsigned long seed, double a, double b):
    cdef double[::1] values = np.empty(nreps, dtype=np.float64)
    cdef mt19937 gen = mt19937(seed)
    cdef uniform_real_distribution[double] dist = uniform_real_distribution[double](a, b)
    cdef unsigned long i

    for i in range(nreps):
        values[i] = dist(gen)

    return values

cpdef double[::1] StratifiedSample(unsigned long nreps, unsigned long seed, double a, double b):
    cdef double[::1] uhat = np.empty(nreps, dtype=np.float64)
    cdef mt19937 gen = mt19937(seed)
    cdef uniform_real_distribution[double] dist = uniform_real_distribution[double](a, b)
    cdef double u 
    cdef unsigned long i

    for i in range(nreps):
        u = dist(gen)
        uhat[i] = (u + i) / nreps

    return uhat



    
