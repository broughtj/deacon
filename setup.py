from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize
import numpy as np

extensions = [
    Extension("*", ["**/*.pyx"],
        include_dirs=[np.get_include(), "."],
        language="c++")
]

setup(
    name='Deacon',
    version='0.1',
    ext_modules=cythonize(extensions),
)
