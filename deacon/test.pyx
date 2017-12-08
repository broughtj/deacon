from .utils.rand import StratifiedSample
cimport numpy as np
import numpy as np

def TestSampler(nreps):
    seed = np.random.randint(1,100000)

    u = StratifiedSample(nreps, seed, 0.0, 1.0)

    for i in range(nreps):
        print(u[i])



