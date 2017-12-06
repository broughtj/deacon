from libc.math cimport pow, log2, sqrt
from .utils.rand cimport rnorm

import numpy as np
cimport numpy as np


cpdef double[::1] WienerBridge(double expiry, unsigned long steps, double endval)
