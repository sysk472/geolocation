require 'rails_helper'

RSpec.describe ExternalApiCaller, type: :transaction do
  include Dry::Monads::Result::Mixin
  subject { described_class.call(params) }

  before(:each) do
    stub_request(:get, /api.ipstack.com/).
      with(headers: {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(
        Success(build(:geolocation).data)
      )
  end

  let(:params) { '195.245.224.52' }

  context 'call external api with valid params' do
    it { is_expected.to be_success }
  end
end
