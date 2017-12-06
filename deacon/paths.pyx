import numpy as np
cimport numpy as np

cpdef double[::1] WienerBridge(double expiry, unsigned long steps, double endval):
    cdef unsigned long numbisect = <unsigned long>(log2(steps))
    cdef unsigned long tjump = <unsigned long>(expiry)
    cdef unsigned long ijump = <unsigned long>(steps - 1)

    if endval == 0.0:
        endval = np.random.normal(loc = 0.0, scale = sqrt(expiry), size = 1)[0]

    cdef double[::1] z = np.random.normal(size=steps + 1)
    cdef double[::1] w = np.zeros(steps + 1, dtype=np.float64)
    w[steps] = endval

    cdef unsigned long i, j, k
    cdef unsigned long left, right
    cdef double a, b

    for k in range(numbisect):
        left = 0
        i = ijump // 2 + 1
        right = ijump + 1
        limit = <unsigned long>(pow(2, k))

        for j in range(limit):
            a = 0.5 * (w[left] + w[right])
            b = 0.5 * sqrt(tjump)
            w[i] = a + b * z[i] 
            right += ijump + 1
            left += ijump + 1
            i += ijump + 1

        ijump /= 2
        tjump /= 2

    return np.diff(w)
