cdef class OptionFacade:
    """A facade class to price an option."""
    def __init__(self, option, engine, data):
        self._option = option
        self._engine = engine
        self._data = data

    cpdef price(self):
        return self._engine.calculate(self._option, self._data)
