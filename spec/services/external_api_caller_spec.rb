require 'rails_helper'

RSpec.describe ExternalApiCaller, type: :transaction do
  include Dry::Monads::Result::Mixin
  subject { described_class.call(params) }

  let(:params) { '195.245.224.52' }

  context 'call external api with valid params' do
    before(:each) do
        stub_request(:get, /api.ipstack.com/).
          to_return({ body: build(:geolocation).data, status: 200 })
    end

    it 'subject' do
      is_expected.to be_success
    end
  end
end
