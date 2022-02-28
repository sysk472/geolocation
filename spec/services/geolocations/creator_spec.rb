require 'rails_helper'
RSpec.describe Geolocations::Creator, type: :transaction do
  include Dry::Monads::Result::Mixin
  include Exceptions::AccessRestricted

  subject { described_class.call(params) }

  let(:params) { { ip: '195.245.224.52' } }

  context 'when passing valid body params' do
    let(:external_api_caller) do
      geolocation = build(:geolocation)
      allow_any_instance_of(ExternalApiCaller).to receive(:call).with(geolocation.ip)
    end

    context 'when no error is raised from external API' do
      before(:each) do
        allow_any_instance_of(ExternalApiCaller).to receive(:call).with(params[:ip]).and_return(Success(build(:geolocation).data))
      end

      it { is_expected.to be_success }

      it 'return Geolocation object' do
        expect(subject.success).to be_a(Geolocation)
      end
    end

    context 'when error is raised from external API' do
      it 'should return failure message when calling external api returning (500)' do
        external_api_caller.and_return(Failure(Exceptions::ConnectionError.message))

        is_expected.to be_failure
        expect(subject.failure).to eq(Exceptions::ConnectionError.message)
      end


      it 'should return failure message when calling external api returning (101)' do
        external_api_caller.and_return(Failure(Exceptions::AccessKey.message))

        is_expected.to be_failure
        expect(subject.failure).to eq(Exceptions::AccessKey.message)
      end

      it 'should return failure message when calling external api returning (103)' do
        external_api_caller.and_return(Failure(Exceptions::InvalidApiFunction.message))

        is_expected.to be_failure
        expect(subject.failure).to eq(Exceptions::AccessKey.message)
      end

      it 'should return failure message when calling external api returning (104)' do
        external_api_caller.and_return(Failure(Exceptions::LimitExceeded.message))

        is_expected.to be_failure
        expect(subject.failure).to eq(Exceptions::AccessKey.message)
      end

      it 'should return failure message when calling external api returning (105)' do
        external_api_caller.and_return(Failure(Exceptions::AccessRestricted.message))

        is_expected.to be_failure
        expect(subject.failure).to eq(Exceptions::AccessKey.message)
      end

      it 'should return failure message when calling external api returning (106)' do
        external_api_caller.and_return(Failure(Exceptions::AddressIpInvalid.message))

        is_expected.to be_failure
        expect(subject.failure).to eq(Exceptions::AccessKey.message)
      end


      it 'should return failure message when calling external api returning (301)' do
        external_api_caller.and_return(Failure(Exceptions::InvalidFields.message))

        is_expected.to be_failure
        expect(subject.failure).to eq(Exceptions::AccessKey.message)
      end

      it 'should return failure message when calling external api returning (302)' do
        external_api_caller.and_return(Failure(Exceptions::TooManyIps.message))

        is_expected.to be_failure
        expect(subject.failure).to eq(Exceptions::AccessKey.message)
      end

      it 'should return failure message when calling external api returning (404)' do
        external_api_caller.and_return(Failure(Exceptions::NotFound.message))

        is_expected.to be_failure
        expect(subject.failure).to eq(Exceptions::AccessKey.message)
      end
    end
  end

  context 'when passing invalid body params' do
    context 'a new geolocation is not created with invalid ip' do
      let(:params) { { ip: nil } }

      it { is_expected.to be_failure }
    end

    context 'a new geolocation is not created with invalid ip' do
      let(:params) { { url: nil } }

      it { is_expected.to be_failure }
    end
  end
end
