Yahoo Finance Symbol-Suggest Gem
================================

This gem wraps a very straightforward function: sending a HTTP GET request to Yahoo Finance web service, answering a prioritised array of stock symbol suggestions.

For example, Ruby statements:

	require 'rubygems'
	require 'yahoofinance-symbolsuggest'
	require 'yaml'
	y YahooFinance::SymbolSuggest.query("aapl")

output an array of hashes, in YAML:

	---
	- symbol: AAPL
	  name: Apple Inc.
	  exch: NMS
	  type: S
	  exchDisp: NASDAQ
	  typeDisp: Equity
	- symbol: ^AVSPY
	  name: NASDAQ OMX Alpha AAPL vs. SPY I
	  exch: NAS
	  type: I
	  exchDisp: NASDAQ
	  typeDisp: Index
	- symbol: AAPL.MX
	  name: Apple Inc.
	  exch: MEX
	  type: S
	  exchDisp: Mexico
	  typeDisp: Equity
	- symbol: AAPL11BF.SA
	  name: APPLE       -DRN     MB
	  exch: SAO
	  type: S
	  exchDisp: Sao Paolo
	  typeDisp: Equity

As a gem, the main purpose is to encapsulate all the requirements, assumptions and dependencies in one place: with a Ruby gem. Change the gem __only__ to update all other higher-level software which requires access to Yahoo Finance's symbol suggestions. Hence, the gem fulfils an architectural purpose as much as a functional one. Its simple purpose is to distance Yahoo dependencies from any clients that might want to access symbol-suggestion services. The gem might come to live in the open-source community and be maintained by it, possibly even by Yahoo themselves.

Installation
------------

Install from the Git repository to your local collection of Ruby gems using:

	rake install

