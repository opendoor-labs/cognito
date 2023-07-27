# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cognito::Client::Connection do
  subject(:connection) do
    described_class.parse(
      uri:         uri_string,
      api_key:     api_key,
      api_secret:  api_secret,
      api_version: api_version
    )
  end

  let(:uri_string)  { 'http://localhost:2001' }
  let(:api_key)     { 'full_of_stars'         }
  let(:api_secret)  { 'Hal9000CanFeel'        }
  let(:api_version) { '2016-09-01'            }

  its(:uri)         { is_expected.to eql(Addressable::URI.parse(uri_string)) }
  its(:api_key)     { is_expected.to eql(api_key) }
  its(:api_secret)  { is_expected.to eql(api_secret) }
  its(:api_version) { is_expected.to eql(api_version) }

  context 'when running a request' do
    let(:request)        { instance_double(Cognito::Client::Request) }
    let(:endpoint)       { '/profiles'                                 }
    let(:signed_headers) { headers.merge('Some_Auth' => 'thingamajig') }

    let(:data)  do
      { data: { type: 'profile' } }
    end

    let(:headers) do
      { 'Some_Header' => 'anything' }
    end

    let(:signed_request) do
      instance_double(Cognito::Client::Request, request_hash.merge(headers: signed_headers))
    end

    let(:request_hash) do
      {
        headers:  headers,
        verb:     :post,
        endpoint: endpoint,
        data:     data
      }
    end

    before do
      stub_const('HTTP', class_double(HTTP).as_null_object)
      allow(request).to receive(:to_h).and_return(request_hash)
    end

    def assert_chain(name, *arguments)
      expect(HTTP).to have_received(name).with(*arguments)
    end

    it 'builds the correct request' do
      allow(request).to receive(:sign).and_return(signed_request)

      connection.run(request)

      expect(request).to have_received(:sign).with(
        api_key:    api_key,
        api_secret: api_secret,
        date:       satisfy('A date in RFC2822 format', &Time.method(:httpdate))
      )

      # HTTP uses a chainable interface
      assert_chain(:headers, signed_headers.merge('Cognito-Version' => api_version))
      assert_chain(
        :request, :post, 'http://localhost:2001/profiles', json: data
      )
    end
  end
end
