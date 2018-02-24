# crypto-exchange

An easy way to check the most up-to-date exchange rates between popular cryptocurrencies and real-world currency. crypo-exchange uses the CryptoCompare API to get the exchange rates for over 5 commonly used cryptocurrencies, and stores them in a custom cache. crypo-exchange also shows historical exchange rate data for cryptocurrencies, going back up to a year. Below are some screenshots of the app in action. You can also 3D touch anywhere on the app screen to view some statistics for a given cryptocurrency. 

<p align="center">
<img src="https://github.com/jyoo980/crypto-exchange/blob/master/CryptoExchange/Assets.xcassets/v1.2-p1.imageset/v1.2-p1.png" width="327" height="561" style="float: left; width: 30%; margin-right: 1%; margin-bottom: 0.5em;">
<img src="https://github.com/jyoo980/crypto-exchange/blob/master/CryptoExchange/Assets.xcassets/v1.3-p1.imageset/v1.3-p1.png" width="327" height="561" style="float: left; width: 30%; margin-right: 1%; margin-bottom: 0.5em;">
<img src="https://github.com/jyoo980/crypto-exchange/blob/master/CryptoExchange/Assets.xcassets/v1.3-p2.imageset/v1.3-p2.png" width="327" height="561" style="float: left; width: 30%; margin-right: 1%; margin-bottom: 0.5em;">
</p>

## Development Requirements
* To use Charts for iOS, you need to install `Cocoapods` via `Ruby`. Luckily, macOS ships with Ruby in the base installation,  so all you need to do after cloning this repo is to `cd` into `crypto-exchange` and run `sudo gem install cocoapods`, then run `pod install`.

## Features and Tech Stack
* CryptoCompare API (for most up-to-date exchange rates)
* Coinbin API (for historical exchange rates)
* CoinMarketCap API (for 3D Touch data)
* Charts for iOS
* Custom Caching - `ExchangeRateCache.swift`, `GraphDataCache.swift`
* 3D Touch integration

## Current facts
* Currently supports: BCH, BTC, BTG, DOGE, ETH, LTC, and XRP
* Conversion rate data available for: CAD, EUR, GBP, JPY, and USD
* 3D Touch data includes % changes per hour, day, and week for all crypocurrencies

## Todos
* Refactor into MVC architecture - <strong>Tentatively Complete</strong>
* Introduce caching for API calls (workaround for 100 requests/24hr limit) - <strong>Complete</strong>
* Refactor to use with API which has unlimited calls - <strong>Complete</strong>
* Introduce caching for historical data graphs - <strong>Complete</strong>

<strong>Note:</strong> new TODOs can be seen in the [projects](https://github.com/jyoo980/crypto-exchange/projects/1) section of this repository.
