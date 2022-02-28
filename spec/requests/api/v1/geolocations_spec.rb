require 'rails_helper'

RSpec.describe "Api::V1::Geolocations", type: :request do
  include Dry::Monads::Result::Mixin

  before(:each) do
    @geolocation = create(:geolocation)
  end

  describe "GET /show_by_query" do
    context 'when passing invalid query params' do
      it 'should return error message when both' do
        get '/api/v1/geolocations', params: {
          url: 'https://www.stackoverflow.com',
          ip: '151.101.1.69'
        }

        expect(response.status).to eq(422)
        expect(json["error"]).to eq(["Params wrong number of them"])
      end

      it 'should return error message when none' do
        get '/api/v1/geolocations'

        expect(response.status).to eq(422)
        expect(json["error"]).to eq(["Params wrong number of them"])
      end
    end

    context 'when passing valid query params' do
      it 'should return geolocation object if exist in db' do
        get '/api/v1/geolocations', params: {
          url: 'https://www.stackoverflow.com'
        }

        expect(response.status).to eq(200)
        expect(json["geolocation"]).not_to be_nil
      end

      it 'should return geolocation object calling external api returning (200)' do
        geolocation = create(:geolocation, :'195.245.224.53')

        allow_any_instance_of(ExternalApiCaller).to receive(:call).with(geolocation.ip).and_return(Success(build(:geolocation).data))

        get "/api/v1/geolocations?ip=#{geolocation.ip}"

        expect(response.status).to eq(200)
        expect(json["geolocation"]).not_to be_nil
      end

      it 'should return failure message when calling external api returning (500)' do
        geolocation = build(:geolocation, :'195.245.224.53')

        allow_any_instance_of(ExternalApiCaller).to receive(:call).with(geolocation.ip).and_return(Failure('There was an error with connecting external API'))

        get "/api/v1/geolocations?ip=#{geolocation.ip}"

        expect(response.status).to eq(422)
        expect(json["error"]).to eq('There was an error with connecting external API')
      end


      it 'should return failure message when calling external api returning (101)' do
        geolocation = build(:geolocation, :'195.245.224.53')

        allow_any_instance_of(ExternalApiCaller).to receive(:call).with(geolocation.ip).and_return(Failure('Missing access key or key invalid'))

        get "/api/v1/geolocations?ip=#{geolocation.ip}"

        expect(response.status).to eq(422)
        expect(json["error"]).to eq('Missing access key or key invalid')
      end

      it 'should return failure message when calling external api returning (103)' do
        geolocation = build(:geolocation, :'195.245.224.53')

        allow_any_instance_of(ExternalApiCaller).to receive(:call).with(geolocation.ip).and_return(Failure('Invalid api function'))

        get "/api/v1/geolocations?ip=#{geolocation.ip}"

        expect(response.status).to eq(422)
        expect(json["error"]).to eq('Invalid api function')
      end

      it 'should return failure message when calling external api returning (104)' do
        geolocation = build(:geolocation, :'195.245.224.53')

        allow_any_instance_of(ExternalApiCaller).to receive(:call).with(geolocation.ip).and_return(Failure('Limit exceeded'))

        get "/api/v1/geolocations?ip=#{geolocation.ip}"

        expect(response.status).to eq(422)
        expect(json["error"]).to eq('Limit exceeded')
      end

      it 'should return failure message when calling external api returning (105)' do
        geolocation = build(:geolocation, :'195.245.224.53')

        allow_any_instance_of(ExternalApiCaller).to receive(:call).with(geolocation.ip).and_return(Failure('Access restricted'))

        get "/api/v1/geolocations?ip=#{geolocation.ip}"

        expect(response.status).to eq(422)
        expect(json["error"]).to eq('Access restricted')
      end

      it 'should return failure message when calling external api returning (106)' do
        geolocation = build(:geolocation, :'195.245.224.53')

        allow_any_instance_of(ExternalApiCaller).to receive(:call).with(geolocation.ip).and_return(Failure('IP Address is invalid'))

        get "/api/v1/geolocations?ip=#{geolocation.ip}"

        expect(response.status).to eq(422)
        expect(json["error"]).to eq('IP Address is invalid')
      end


      it 'should return failure message when calling external api returning (301)' do
        geolocation = build(:geolocation, :'195.245.224.53')

        allow_any_instance_of(ExternalApiCaller).to receive(:call).with(geolocation.ip).and_return(Failure('Invalid fields'))

        get "/api/v1/geolocations?ip=#{geolocation.ip}"

        expect(response.status).to eq(422)
        expect(json["error"]).to eq('Invalid fields')
      end

      it 'should return failure message when calling external api returning (302)' do
        geolocation = build(:geolocation, :'195.245.224.53')

        allow_any_instance_of(ExternalApiCaller).to receive(:call).with(geolocation.ip).and_return(Failure('Too many ips'))

        get "/api/v1/geolocations?ip=#{geolocation.ip}"

        expect(response.status).to eq(422)
        expect(json["error"]).to eq('Too many ips')
      end

      it 'should return failure message when calling external api returning (404)' do
        geolocation = build(:geolocation, :'195.245.224.53')

        allow_any_instance_of(ExternalApiCaller).to receive(:call).with(geolocation.ip).and_return(Failure('Not found'))

        get "/api/v1/geolocations?ip=#{geolocation.ip}"

        expect(response.status).to eq(422)
        expect(json["error"]).to eq('Not found')
      end
    end
  end

  describe "GET /geolocations/:id" do
    context 'when passing invalid nonexistent id' do
      it 'should respond with 404' do
        get "/api/v1/geolocations/12344"

        expect(response.status).to eq(404)
        expect(json["error"]).to eq("Not found")
      end
    end

    context 'when passing valid id' do
      it 'should return geolocation object' do
        get "/api/v1/geolocations/#{@geolocation.id}"

        expect(response.status).to eq(200)
        expect(json["geolocation"]).not_to be_nil
      end
    end

  end

  describe "POST /geolocations" do
    context 'when passing invalid body params' do
      it 'should respond with error message when both' do
        post '/api/v1/geolocations', params: {
          geolocation: {
            url: 'https://www.stackoverflow.com',
            ip: '151.101.1.69'
          }
        }

        expect(response.status).to eq(422)
        expect(json["error"]).to eq(["Params wrong number of them"])
      end

      it 'should respond with error message when none' do
        post '/api/v1/geolocations', params: {
          geolocation: {
            url: nil,
            ip: nil
          }
        }

        expect(response.status).to eq(422)
        expect(json["error"]).to eq(["Ip is in invalid format", "Url is in invalid format"])
      end
    end

    context 'when passing valid body params' do
      it 'should return save & return geolocation object when calling api returning (200)' do
        geolocation = build(:geolocation, :'151.101.1.69')

        allow_any_instance_of(ExternalApiCaller).to receive(:call).with(geolocation.ip).and_return(Success(build(:geolocation).data))

        post '/api/v1/geolocations', params: {
          geolocation: {
            ip: '151.101.1.69'
          }
        }

        expect(response.status).to eq(201)
        expect(json["geolocation"]).not_to be_nil
        expect(Geolocation.all.count).to eq 2
      end

      it 'should return failure message when calling external api returning (500)' do
        geolocation = build(:geolocation, :'195.245.224.53')

        allow_any_instance_of(ExternalApiCaller).to receive(:call).with(geolocation.ip).and_return(Failure('There was an error with connecting external API'))

        get "/api/v1/geolocations?ip=#{geolocation.ip}"

        expect(response.status).to eq(422)
        expect(json["error"]).to eq('There was an error with connecting external API')
      end


      it 'should return failure message when calling external api returning (101)' do
        geolocation = build(:geolocation, :'195.245.224.53')

        allow_any_instance_of(ExternalApiCaller).to receive(:call).with(geolocation.ip).and_return(Failure('Missing access key or key invalid'))

        get "/api/v1/geolocations?ip=#{geolocation.ip}"

        expect(response.status).to eq(422)
        expect(json["error"]).to eq('Missing access key or key invalid')
      end

      it 'should return failure message when calling external api returning (103)' do
        geolocation = build(:geolocation, :'195.245.224.53')

        allow_any_instance_of(ExternalApiCaller).to receive(:call).with(geolocation.ip).and_return(Failure('Invalid api function'))

        get "/api/v1/geolocations?ip=#{geolocation.ip}"

        expect(response.status).to eq(422)
        expect(json["error"]).to eq('Invalid api function')
      end

      it 'should return failure message when calling external api returning (104)' do
        geolocation = build(:geolocation, :'195.245.224.53')

        allow_any_instance_of(ExternalApiCaller).to receive(:call).with(geolocation.ip).and_return(Failure('Limit exceeded'))

        get "/api/v1/geolocations?ip=#{geolocation.ip}"

        expect(response.status).to eq(422)
        expect(json["error"]).to eq('Limit exceeded')
      end

      it 'should return failure message when calling external api returning (105)' do
        geolocation = build(:geolocation, :'195.245.224.53')

        allow_any_instance_of(ExternalApiCaller).to receive(:call).with(geolocation.ip).and_return(Failure('Access restricted'))

        get "/api/v1/geolocations?ip=#{geolocation.ip}"

        expect(response.status).to eq(422)
        expect(json["error"]).to eq('Access restricted')
      end

      it 'should return failure message when calling external api returning (106)' do
        geolocation = build(:geolocation, :'195.245.224.53')

        allow_any_instance_of(ExternalApiCaller).to receive(:call).with(geolocation.ip).and_return(Failure('IP Address is invalid'))

        get "/api/v1/geolocations?ip=#{geolocation.ip}"

        expect(response.status).to eq(422)
        expect(json["error"]).to eq('IP Address is invalid')
      end


      it 'should return failure message when calling external api returning (301)' do
        geolocation = build(:geolocation, :'195.245.224.53')

        allow_any_instance_of(ExternalApiCaller).to receive(:call).with(geolocation.ip).and_return(Failure('Invalid fields'))

        get "/api/v1/geolocations?ip=#{geolocation.ip}"

        expect(response.status).to eq(422)
        expect(json["error"]).to eq('Invalid fields')
      end

      it 'should return failure message when calling external api returning (302)' do
        geolocation = build(:geolocation, :'195.245.224.53')

        allow_any_instance_of(ExternalApiCaller).to receive(:call).with(geolocation.ip).and_return(Failure('Too many ips'))

        get "/api/v1/geolocations?ip=#{geolocation.ip}"

        expect(response.status).to eq(422)
        expect(json["error"]).to eq('Too many ips')
      end

      it 'should return failure message when calling external api returning (404)' do
        geolocation = build(:geolocation, :'195.245.224.53')

        allow_any_instance_of(ExternalApiCaller).to receive(:call).with(geolocation.ip).and_return(Failure('Not found'))

        get "/api/v1/geolocations?ip=#{geolocation.ip}"

        expect(response.status).to eq(422)
        expect(json["error"]).to eq('Not found')
      end
    end
  end

  describe "DELETE /geolocations/:id" do
    context 'when passing invalid nonexistent id' do
      it 'should respond with 404' do
        delete "/api/v1/geolocations/12344"

        expect(response.status).to eq(404)
        expect(json["error"]).to eq("Not found")
      end
    end

    context 'when passing valid id' do
      it 'should respond with 204' do
        delete "/api/v1/geolocations/#{@geolocation.id}"

        expect(response.status).to eq(204)
      end
    end
  end
end
