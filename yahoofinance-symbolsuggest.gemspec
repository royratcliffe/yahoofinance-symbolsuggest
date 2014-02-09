# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'yahoofinance-symbolsuggest/version'

Gem::Specification.new do |s|
  s.name        = 'yahoofinance-symbolsuggest'
  s.version     = YahooFinance::SymbolSuggest::VERSION
  s.authors     = ['Roy Ratcliffe']
  s.email       = ['roy@pioneeringsoftware.co.uk']
  s.homepage    = 'https://github.com/royratcliffe/yahoofinance-symbolsuggest'
  s.summary     = %q{Sends a Symbol Suggest request to Yahoo Finance web services}
  s.description = %q{Wraps a very straightforward piece of functionality: sending a HTTP GET request to Yahoo Finance web service, answering a prioritised array of stock symbol suggestions.}

  s.rubyforge_project = 'yahoofinance-symbolsuggest'
  s.add_runtime_dependency 'json'
  s.add_development_dependency 'rspec'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
