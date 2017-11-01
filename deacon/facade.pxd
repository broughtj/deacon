from .option cimport Option
from .marketdata cimport MarketData
from .engine cimport PricingEngine

cdef class OptionFacade:
    cdef Option _option
    cdef MarketData _data
    cdef PricingEngine _engine

    cpdef price(self)
