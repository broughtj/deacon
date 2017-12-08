from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize
import numpy as np
#import os

#os.environ["CC"] = "clang"
#os.environ["CXX"] = "clang++"

compile_args = ['-O3', '-g', '-std=c++14']

extensions = [
    Extension("*", ["**/*.pyx"],
        include_dirs=[np.get_include(), "."],
        extra_compile_args=compile_args,
        language="c++")
]

setup(
    name='Deacon',
    version='0.1',
    ext_modules=cythonize(extensions),
)
