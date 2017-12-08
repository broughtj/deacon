cdef double choose(double n, double k):
    cdef int i
    cdef int mn
    cdef int mx
    cdef double value

    if k < n - k:
        mn = <int>(k)
        mx = <int>(n - k)
    else:
        mn = <int>(n - k)
        mx = <int>(k)

    if mn < 0:
        value = 0.0
    elif mn == 0:
        value = 1.0
    else:
        value = <double>(mx + 1)

        for i in range(2,mn+1):
            value = (value * <double>(mx + i)) / (<double>(i))

    return value


cdef double dbinom(double x, double n, double p):
    cdef double value

    if x < 0.0:
        value = 0.0
    elif x <= n:
        value = choose(n,x) * pow(p, x) * pow(1.0 - p, n - x)
    else:
        value = 0.0

    return value
