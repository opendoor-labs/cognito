# frozen_string_literal: true

require 'spec_helper'
require 'httparty'
require 'json'

RSpec.describe Cognito::Client do
  let(:api_key) { 'abc123' }
  let(:client) { described_class.new(api_key: api_key) }
  let(:response_struct) { Struct.new(:body, :code) }
  let(:headers) do
    {
      'Accept' => 'application/vnd.api+json',
      'Content-Type' => 'application/vnd.api+json',
      'Cognito-Version' => '2016-09-01'
    }
  end

  let(:response) { response_struct.new(response_body, 201) }
  let(:options) { { headers: headers, body: JSON.generate(expected_json) } }

  describe '#initialize' do
    it 'requires an :api_key' do
      expect {
        described_class.new
      }.to raise_exception(ArgumentError, 'missing keyword: api_key')

      expect {
        described_class.new(api_key: api_key)
      }.not_to raise_exception
    end
  end

  describe '#base_uri=' do
    let(:uri) { 'opendoor.com' }
    let(:normalized_uri) { HTTParty.normalize_base_uri(uri) }

    it 'sets the base_uri for the client' do
      client.base_uri = uri

      # Unable to test this behavior without violating encapsulation.
      expect(client.class.default_options[:base_uri]).to eq(normalized_uri)
    end
  end

  describe '#create_profile!' do
    let(:response_body) { FileHelper.read_file(:profile) }
    let(:response_json) { JSON.parse(response_body, symbolize_names: true) }
    let(:expected_json) do
      { data: { type: 'profile' } }
    end

    it 'makes the correct API call' do
      expect(client.class).to receive(:post)
        .with('/profiles', options)
        .and_return(response)
      expect(Cognito::Resource::Profile).to receive(:create)
        .and_call_original

      profile = client.create_profile!

      # Ensure the object is well-formed.
      expect(profile.id).to eq(response_json[:data][:id])
      expect(profile.attributes).to eq(response_json[:data][:attributes])
    end

    context 'when 4xx error' do
      let(:response_body) { FileHelper.read_file(:not_found) }
      let(:response) { response_struct.new(response_body, 404) }

      it 'raises a ClientError' do
        expect(client.class).to receive(:post)
          .with('/profiles', options)
          .and_return(response)
        expect(Cognito::Resource::Profile).not_to receive(:create)

        expect {
          client.create_profile!
        }.to raise_exception(Cognito::ClientError,
                             'The requested resource could not be found.')
      end
    end
  end

  describe '#search!' do
    let(:response_body) { FileHelper.read_file(:identity_search) }
    let(:phone_number) { '+12223334444' }
    let(:profile) do
      Cognito::Resource::IdentitySearch.create(FileHelper.load_json(:profile))
    end

    let(:expected_json) do
      {
        data: {
          type: 'identity_search',
          attributes: {
            phone: {
              number: phone_number
            }
          },
          relationships: {
            profile: {
              data: {
                type: 'profile',
                id:   profile.id
              }
            }
          }
        }
      }
    end

    it 'makes the correct API call' do
      expect(client.class).to receive(:post)
        .with('/identity_searches', options)
        .and_return(response)
      expect(Cognito::Resource::IdentitySearch).to receive(:create)
        .and_call_original

      client.search!(profile.id, phone_number)
    end

    context 'when response is 201' do
      it 'returns an IdentitySearch' do
        expect(client.class).to receive(:post)
          .with('/identity_searches', options)
          .and_return(response)
        expect(Cognito::Resource::IdentitySearch).to receive(:create)
          .and_call_original

        response = client.search!(profile.id, phone_number)

        # Ensure the object is well-formed.
        expect(response.type).to eq('identity_search')
        expect(response.attributes.dig(:phone, :number)).to eq(phone_number)
      end
    end

    context 'when response is 202' do
      let(:response_body) { FileHelper.read_file(:identity_search_job) }
      let(:response) { response_struct.new(response_body, 202) }

      it 'returns an IdentitySearchJob' do
        expect(client.class).to receive(:post)
          .with('/identity_searches', options)
          .and_return(response)
        expect(Cognito::Resource::IdentitySearchJob).to receive(:create)
          .and_call_original

        response = client.search!(profile.id, phone_number)

        # Ensure the object is well-formed.
        expect(response.type).to eq('identity_search_job')
        expect(response.attributes[:status]).to eq('processing')
        expect(response.attributes[:identity_search]).to eq(nil)
      end
    end

    context 'when 4xx error' do
      let(:response_body) { FileHelper.read_file(:invalid_request_body) }
      let(:response) { response_struct.new(response_body, 400) }

      it 'raises a ClientError' do
        expect(client.class).to receive(:post)
          .with('/identity_searches', options)
          .and_return(response)
        expect(Cognito::Resource::IdentitySearch).not_to receive(:create)

        expect {
          client.search!(profile.id, phone_number)
        }.to raise_exception(Cognito::ClientError)
      end
    end
  end

  describe '#search_status!' do
    let(:options) { { headers: headers } }
    let(:job_id) { 'foi2uoiaf' }

    context 'when the search has completed' do
      let(:response_body) do
        FileHelper.read_file(:identity_search_job_completed)
      end
      let(:response) { response_struct.new(response_body, 303) }

      it 'returns the ID of the search' do
        expect(client.class).to receive(:get)
          .with("/identity_searches/jobs/#{job_id}", options)
          .and_return(response)
        expect(Cognito::Resource::IdentitySearchJob).to receive(:create)
          .and_call_original

        search_job = client.search_status!(job_id)

        # Ensure the object is well-formed.
        expect(search_job.attributes[:status]).to eq('completed')
      end
    end

    context 'when the search is still processing' do
      let(:response_body) { FileHelper.read_file(:identity_search_job) }
      let(:response) { response_struct.new(response_body, 200) }

      it 'has status `processing`' do
        expect(client.class).to receive(:get)
          .with("/identity_searches/jobs/#{job_id}", options)
          .and_return(response)
        expect(Cognito::Resource::IdentitySearchJob).to receive(:create)
          .and_call_original

        search_job = client.search_status!(job_id)

        # Ensure the object is well-formed.
        expect(search_job.attributes[:status]).to eq('processing')
      end
    end

    context 'when 4xx error' do
      let(:response_body) { FileHelper.read_file(:invalid_request_body) }
      let(:response) { response_struct.new(response_body, 400) }

      it 'raises a ClientError' do
        expect(client.class).to receive(:get)
          .with("/identity_searches/jobs/#{job_id}", options)
          .and_return(response)
        expect(Cognito::Resource::IdentitySearchJob).not_to receive(:create)

        expect {
          client.search_status!(job_id)
        }.to raise_exception(Cognito::ClientError)
      end
    end
  end
end
