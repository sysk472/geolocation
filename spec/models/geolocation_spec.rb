require 'rails_helper'

RSpec.describe Geolocation, type: :model do
  it 'is not valid withoud url and ip' do
    expect(Geolocation.new(data: 'json')).to_not be_valid
  end

  it 'is not valid withoud data' do
    expect(Geolocation.new(url: 'www.stackoverflow.com')).to_not be_valid
  end

  it 'is valid with proper data' do
    expect(build(:geolocation)).to be_valid
  end
end
