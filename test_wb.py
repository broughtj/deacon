from deacon.paths import WienerBridge
import numpy as np

z = np.random.normal(size=1)[0]

steps = 2 ** 4
path = WienerBridge(1.0, steps, z)

for i in range(steps):
    print(path[i])
