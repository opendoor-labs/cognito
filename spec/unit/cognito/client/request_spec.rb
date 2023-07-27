# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cognito::Client::Request do
  let(:api_key)    { 'sandbox_key_1234abcXYZ'        }
  let(:api_secret) { 'itsfullofstars'                }
  let(:http_date)  { 'Wed, 07 Sep 2016 22:14:27 GMT' }

  let(:authorization_header) do
    [
      "Signature keyId=\"#{api_key}\"",
      'algorithm="hmac-sha256"',
      'headers="date digest (request-target)"',
      "signature=\"#{signature}\""
    ].join(',')
  end

  context 'when posting a request' do
    subject(:request) { described_class.post(endpoint, data) }

    let(:endpoint)      { '/profiles'                                            }
    let(:digest_header) { 'SHA-256=KOhYVr+tP63sRKbk2/FQMknfG1CRhCsW4CAN8EKTyA0=' }
    let(:signature)     { 'sehJ0sSpBT2I4F0q0aFO5lH7u8EiCF2P1FZum1nCYow='         }

    let(:data) do
      { data: { type: 'profile' } }
    end

    it 'has the correct request attributes' do
      is_expected.to have_attributes(
        verb:     :post,
        endpoint: endpoint,
        headers:  { 'Content-Type' => 'application/vnd.api+json' },
        data:     data
      )
    end

    it 'signs with the correct headers' do
      expect(
        request.sign(api_key: api_key, api_secret: api_secret, date: http_date)
      ).to have_attributes(
        headers: {
          'Content-Type'  => 'application/vnd.api+json',
          'Authorization' => authorization_header,
          'Digest'        => digest_header,
          'Date'          => http_date
        }
      )
    end
  end

  context 'when making a GET request' do
    subject(:request) { described_class.get(endpoint) }

    let(:endpoint)      { '/profiles'                                            }
    let(:digest_header) { 'SHA-256=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=' }
    let(:signature)     { 'q9hGtIG2vIKigLxEVJ4eQdK0N0suu2+t8DxSQh9wVIg='         }

    it 'has the correct request attributes' do
      is_expected.to have_attributes(
        verb:     :get,
        endpoint: endpoint,
        headers:  { 'Content-Type' => 'application/vnd.api+json' },
        data:     nil
      )
    end

    it 'signs with the correct headers' do
      expect(
        request.sign(api_key: api_key, api_secret: api_secret, date: http_date)
      ).to have_attributes(
        headers: {
          'Content-Type'  => 'application/vnd.api+json',
          'Authorization' => authorization_header,
          'Digest'        => digest_header,
          'Date'          => http_date
        }
      )
    end
  end
end
