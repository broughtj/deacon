cdef class MarketData:
    """A class to encapsulate market data for option pricing."""
    def __init__(self, spot, rate, vol, div):
        self._spot = spot
        self._rate = rate
        self._vol = vol
        self._div = div

    property spot:
        def __get__(self):
            return self._spot

        def __set__(self, spot):
            self._spot = spot

    property rate:
        def __get__(self):
            return self._rate

        def __set__(self, rate):
            self._rate = rate

    property vol:
        def __get__(self):
            return self._vol

        def __set__(self, vol):
            self._vol = vol

    property div:
        def __get__(self):
            return self._div

        def __set__(self, div):
            self._div = div
