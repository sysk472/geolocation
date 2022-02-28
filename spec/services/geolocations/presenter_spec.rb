require 'rails_helper'

RSpec.describe Geolocations::Presenter, type: :transaction do
  include Dry::Monads::Result::Mixin
  subject { described_class.call(params) }

  context 'if it is not found by url in db' do
    let(:params) { { url: 'https://www.google.com/woho' } }

    it 'should return geolocation form external API' do
      allow_any_instance_of(ExternalApiCaller).to receive(:call).with('google.com').and_return(Success(build(:geolocation, :google).data))
      is_expected.to be_success
    end
  end

  context 'when passing valid params' do
    let(:params) { { ip: '195.245.224.52' } }
    let(:geolocation) { create(:geolocation) }

    before(:each) do
      allow_any_instance_of(ExternalApiCaller).to receive(:call).with(geolocation.ip)
    end

    context 'and ip geolocalization is in db' do
      it 'should return geolocation' do
        is_expected.to be_success
        expect(subject.success).to be_a(Geolocation)
      end

      context 'and url geolocalization is in db' do
        let(:params) { { url: 'https://www.stackoverflow.com' } }
        it 'should return geolocation' do
          geolocation
          is_expected.to be_success
          expect(subject.success).to be_a(Geolocation)
        end
      end
    end

    context 'when no error is raised from external API' do
      context 'and ip geolocalization is not in db' do
        let(:params) { { ip: '0.0.0.12' } }
        before(:each) do
          allow_any_instance_of(ExternalApiCaller).to receive(:call).with(params[:ip]).and_return(Success(build(:geolocation).data))
        end

        it 'should return geolocation' do
          is_expected.to be_success
        end
      end
    end

    context 'when error is raised from external API' do
      let(:params) { { ip: '195.245.0.0' } }
      let(:external_api_caller) do
        allow_any_instance_of(ExternalApiCaller).to receive(:call).with('195.245.0.0')
      end

      it 'should return failure message when calling external api returning (500)' do
        external_api_caller.and_return(Failure('There was an error with connecting external API'))

        is_expected.to be_failure
        expect(subject.failure).to eq({ error: 'There was an error with connecting external API' })
      end

      it 'should return failure message when calling external api returning (101)' do
        external_api_caller.and_return(Failure('Missing access key or key invalid'))

        is_expected.to be_failure
        expect(subject.failure).to eq({ error: 'Missing access key or key invalid' })
      end

      it 'should return failure message when calling external api returning (103)' do
        external_api_caller.and_return(Failure('Invalid api function'))

        is_expected.to be_failure
        expect(subject.failure).to eq({ error: 'Invalid api function' })
      end

      it 'should return failure message when calling external api returning (104)' do
        external_api_caller.and_return(Failure('Limit exceeded'))

        is_expected.to be_failure
        expect(subject.failure).to eq({ error: 'Limit exceeded' })
      end

      it 'should return failure message when calling external api returning (105)' do
        external_api_caller.and_return(Failure('Access restricted'))

        is_expected.to be_failure
        expect(subject.failure).to eq({ error: 'Access restricted' })
      end

      it 'should return failure message when calling external api returning (106)' do
        external_api_caller.and_return(Failure('IP Address is invalid'))

        is_expected.to be_failure
        expect(subject.failure).to eq({ error: 'IP Address is invalid' })
      end

      it 'should return failure message when calling external api returning (301)' do
        external_api_caller.and_return(Failure('Invalid fields'))

        is_expected.to be_failure
        expect(subject.failure).to eq({ error: 'Invalid fields' })
      end

      it 'should return failure message when calling external api returning (302)' do
        external_api_caller.and_return(Failure('Too many ips'))

        is_expected.to be_failure
        expect(subject.failure).to eq({ error: 'Too many ips' })
      end

      it 'should return failure message when calling external api returning (404)' do
        external_api_caller.and_return(Failure('Not found'))

        is_expected.to be_failure
        expect(subject.failure).to eq({ error: 'Not found' })
      end
    end
  end

  context 'when passing invalid params' do
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
