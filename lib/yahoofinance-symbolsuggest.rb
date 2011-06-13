require "yahoofinance-symbolsuggest/version"

# Both net/http and uri belong to the Ruby standard library.
require 'net/http'
require 'uri'

# http://flori.github.com/json
require 'json'

module YahooFinance
  module SymbolSuggest
    # This constant is important for two reasons:
    # 1. it appears in the URL query;
    # 2. it appears in the JSONP response.
    #
    # The URL query string is everything after the question mark. The
    # undocumented non-public interface to Yahoo's symbol-suggest
    # auto-completion services requires two query fields: query and callback,
    # where “query” specifies the symbol on which to base the suggestions,
    # and where “callback” specifies the JavaScript callback function. But
    # note, this callback function cannot have just any name for the Yahoo
    # service to accept the request. It must match this string.
    Callback = "YAHOO.Finance.SymbolSuggest.ssCallback"
    
    # Queries the given ticker symbol or company name against Yahoo Finance's
    # symbol suggest web service. Answers an array of prioritised suggestions in
    # the form of hashes where each hash has the following keys.
    #
    # [exch]      symbol of the exchange, e.g. NYQ for NYSE
    # [exchDisp]  display name for the exchange, e.g. “NYSE”
    # [name]      name of the company
    # [symbol]    ticker symbol
    # [type]      type of stock, e.g. S for “Equity”
    # [typeDisp]  display type for stock
    #
    # == Implementation Notes
    #
    # The implementation uses a module-scoped method to wrap the GET request
    # sent to Yahoo Finance, though this may need refactoring at some point in
    # the future.
    def SymbolSuggest.query(symbol)
      jsonp = Net::HTTP.get(URI.parse("http://d.yimg.com/aq/autoc?query=#{symbol}&callback=#{Callback}"))
      # The answer is a piece of JSONP: JSON with padding, where the padding is
      # the callback function. The following padding parser utilises Ruby 1.9
      # String methods. Is that a good thing? It makes the implementation
      # dependent on 1.9.
      prefix = Callback + '('
      suffix = ')'
      if jsonp.start_with?(prefix) && jsonp.end_with?(suffix)
        JSON.parse(jsonp[prefix.length, jsonp.length - prefix.length - suffix.length])["ResultSet"]["Result"]
      else
        nil
      end
    end
  end
end
