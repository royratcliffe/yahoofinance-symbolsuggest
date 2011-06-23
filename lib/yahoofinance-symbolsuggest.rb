require "yahoofinance-symbolsuggest/version"

# Both net/http, uri and cgi belong to the Ruby standard library.
require 'net/http'
require 'uri'
require 'cgi'

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
    
    # Answers an URL given a ticker symbol or company name; Yahoo Finance
    # matches both simultaneously. Send an HTTP GET request to this URL and
    # Yahoo will reply with a padded JSON response containing some useful
    # suggestions for matching companies. Use suggestions_from_jsonp to decode the
    # response.
    def self.url_from_symbol(symbol)
      # Escape the query string using CGI rather than URI because URI fails to
      # encode ampersands.
      URI.parse("http://d.yimg.com/aq/autoc?query=#{CGI.escape(symbol)}&callback=#{Callback}")
    end
    
    # Parses JSONP and extracts the encoded set of results. Answers a hash
    # comprising two keys: +Query+ and +Result+. The +Query+ value is the
    # original query string. The +Result+ value is an array of hashes, the
    # results proper. Each hash has keys describing the symbol suggestion,
    # including +symbol+ for the ticker symbol, +name+ for the name of the
    # company, etc. See query method.
    def self.results_from_jsonp(jsonp)
      # The answer from the GET request to Yahoo Finance's symbol-suggest
      # service is a piece of JSONP: JSON with padding, where the padding is the
      # callback function. The following padding parser utilises Ruby 1.9 String
      # methods. Is that a good thing? It makes the implementation dependent on
      # 1.9.
      prefix = Callback + '('
      suffix = ')'
      if jsonp.start_with?(prefix) && jsonp.end_with?(suffix)
        JSON.parse(jsonp[prefix.length, jsonp.length - prefix.length - suffix.length])["ResultSet"]
      else
        nil
      end
    end
    
    # Answers an array of hashes representing symbol suggestions given a set of
    # results; in other words, discards the +Query+ key. The results argument
    # typically comes from the results_from_jsonp method.
    def self.suggestions_from_results(results)
      results["Result"]
    end
    
    # Answers an array of symbol suggestions given some JSONP sent by the Yahoo
    # Finance symbol-suggestion service.
    def self.suggestions_from_jsonp(jsonp)
      suggestions_from_results(results_from_jsonp(jsonp))
    end
    
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
    # == Design Notes
    #
    # The design uses a module-scoped method to wrap the GET request sent to
    # Yahoo Finance, though this may need refactoring at some point in the
    # future. The +query+ method handles the query synchronously, meaning that
    # the caller waits for the response. Future implementations may abstract
    # away the response handling as well as the request handling, in order to
    # support other caller-callee paradigms, including asynchronous ones.
    #
    # To facilitate alternative approaches, including asynchronous loading, the
    # design refactors URL-from-symbol and suggestions-from-JSONP behaviour as
    # separate module methods. Hence +query+ is just a convenience method that
    # sends a synchronous HTTP GET request using the Ruby standard library.
    def self.query(symbol)
      suggestions_from_jsonp(Net::HTTP.get(url_from_symbol(symbol)))
    end
  end
end
