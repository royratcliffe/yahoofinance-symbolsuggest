require 'spec_helper'

class Array
  def has_all_of?(klass)
    all? { |element| klass === element }
  end
end

describe YahooFinance::SymbolSuggest do
  it 'queries AAPL' do
    suggestions = YahooFinance::SymbolSuggest.query("aapl")
    expect(suggestions).to be_an(Array)
    expect(suggestions).not_to be_empty
    expect(suggestions).to have_all_of(Hash)
  end
end
