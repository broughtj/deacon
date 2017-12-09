from deacon.option import Option
from deacon.payoff import VanillaCallPayoff, VanillaPutPayoff 
from deacon.engine import BlackScholesControlVariateEngine
from deacon.marketdata import MarketData
from deacon.facade import OptionFacade

## Build the options
strike = 40.0
theCall = Option(1.0, VanillaCallPayoff(strike))
thePut = Option(1.0, VanillaPutPayoff(strike))

## Setup up the Black Scholes Control Variate pricing engine
steps = 52
reps = 10000
theEngine = BlackScholesControlVariateEngine(steps, reps)

## Setup the market data
spot = 41.0
rate = 0.08
vol = 0.30
div = 0.0
theData = MarketData(spot, rate, vol, div)

## Setup up the option facade
opt1 = OptionFacade(theCall, theEngine, theData)

## Price the options
print("The call price is: {0:0.3f}".format(opt1.price[0]()))
print("The standard error is: {0:0.3f}".format(opt1.price[1]()))
