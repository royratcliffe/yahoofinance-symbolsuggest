# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "yahoofinance-symbolsuggest/version"

Gem::Specification.new do |s|
  s.name        = "yahoofinance-symbolsuggest"
  s.version     = YahooFinance::SymbolSuggest::VERSION
  s.authors     = ["Roy Ratcliffe"]
  s.email       = ["roy@pioneeringsoftware.co.uk"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "yahoofinance-symbolsuggest"
  s.add_runtime_dependency 'json'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
