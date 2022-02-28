require 'rails_helper'

RSpec.describe Geolocations::Presenter, type: :transaction do
  include Dry::Monads::Result::Mixin
  subject { described_class.call(params) }

  let(:params) { { ip: '195.245.224.52' } }

  before(:each) do
    allow_any_instance_of(ExternalApiCaller).to receive(:call).with(params[:ip]).and_return(Success(build(:geolocation).data))
  end

  context 'geolocation is retured if it is not found by url in db' do
    let(:params) { { url: 'https://www.google.com/woho' } }

    it { is_expected.to be_success }
    it 'has proper geolocation attribute' do
      expect(subject.success).to be([url: "google.com"])
    end
  end

  context 'when passing valid body params' do
    let(:params) { { ip: '195.245.224.52' } }
    let(:external_api_caller) do
      geolocation = build(:geolocation)
      allow_any_instance_of(ExternalApiCaller).to receive(:call).with(geolocation.ip)
    end

    context 'when geolocalization is in db' do
      context 'geolocation is retured if it is found by ip in db' do
        it { is_expected.to be_success }
      end


      context 'geolocation is retured if it is found by url in db' do
        let(:params) { { url: 'https://www.stackoverflow.com' } }

        it { is_expected.to be_success }
      end
    end

    context 'when no error is raised from external API' do
      context 'geolocation is retured if it is not found by ip in db' do
        let(:params) { { ip: '0.0.0.12' } }

        it { is_expected.to be_success }
      end
    end

    context 'when error is raised from external API' do
      it 'should return failure message when calling external api returning (500)' do
        external_api_caller.and_return(Failure('There was an error with connecting external API'))

        is_expected.to be_failure
        expect(subject.failure).to eq('There was an error with connecting external API')
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

    context 'when passing invalid body params' do
      context 'failure is returned with invalid url' do
        let(:params) { { url: nil } }

        it { is_expected.to be_failure }
      end

      context 'failure is returned with invalid ip' do
        let(:params) { { ip: nil } }

        it { is_expected.to be_failure }
      end
    end
  end
end
