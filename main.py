from deacon.option import Option
from deacon.payoff import VanillaCallPayoff, VanillaPutPayoff 
from deacon.engine import EuropeanBinomialEngine
from deacon.marketdata import MarketData
from deacon.facade import OptionFacade

## Build the options
strike = 40.0
theCall = Option(1.0, VanillaCallPayoff(strike))
thePut = Option(1.0, VanillaPutPayoff(strike))

## Setup up the binomial pricing engine
steps = 500
theEngine = EuropeanBinomialEngine(steps)

## Setup the market data
spot = 41.0
rate = 0.08
vol = 0.30
div = 0.0
theData = MarketData(spot, rate, vol, div)

## Setup up the option facade
opt1 = OptionFacade(theCall, theEngine, theData)
opt2 = OptionFacade(thePut, theEngine, theData)

## Price the options
print("The call price is: {0:0.3f}".format(opt1.price()))
print("The put price is: {0:0.3f}".format(opt2.price()))


