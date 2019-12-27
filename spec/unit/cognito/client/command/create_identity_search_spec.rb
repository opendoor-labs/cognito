# frozen_string_literal: true

RSpec.describe Cognito::Client::Command::CreateIdentitySearch do
  include_context 'null connection'

  subject(:response) do
    described_class.call(connection: connection, profile_id: instance_double(String))
  end

  let(:status_code) { 202 }
  let(:body)        { ''  }
  let(:headers)     { {}  }

  context 'when name and phone are omitted' do
    let(:request) do
      Cognito::Client::Request.post(
        '/identity_searches',
        data: {
          type:          'identity_search',
          relationships: {
            profile: {
              data: {
                type: 'profile',
                id:   'oi13uaiof2qoi'
              }
            }
          }
        }
      )
    end

    it 'omits them from the attributes object' do
      described_class.call(connection: connection, profile_id: 'oi13uaiof2qoi')

      expect(connection).to have_received(:run).with(request)
    end
  end

  context 'when name and phone are provided' do
    let(:request) do
      Cognito::Client::Request.post(
        '/identity_searches',
        data: {
          type:          'identity_search',
          attributes:    {
            phone: {
              number: '+12223334444'
            },
            name:  {
              first:  'Delmer',
              middle: 'Loves',
              last:   'Pokemon'
            }
          },
          relationships: {
            profile: {
              data: {
                type: 'profile',
                id:   'oi13uaiof2qoi'
              }
            }
          }
        }
      )
    end

    it 'passes phone and name along to the attributes object' do
      described_class.call(
        connection:   connection,
        profile_id:   'oi13uaiof2qoi',
        phone_number: '+12223334444',
        name:         {
          first:  'Delmer',
          middle: 'Loves',
          last:   'Pokemon'
        }
      )

      expect(connection).to have_received(:run).with(request)
    end
  end

  context 'when name, phone, dob, ssn, address are provided' do
    let(:request) do
      Cognito::Client::Request.post(
        '/identity_searches',
        data: {
          type:          'identity_search',
          attributes:    {
            phone:      {
              number: '+12223334444'
            },
            name:       {
              first:  'Delmer',
              middle: 'Loves',
              last:   'Pokemon'
            },
            ssn:        {
              area:   '123',
              group:  '45',
              serial: '6789'
            },
            birth:      {
              day:   23,
              month: 8,
              year:  1993
            },
            us_address: {
              street:      '123 Main St',
              city:        'Mountain View',
              subdivision: 'CA',
              postal_code: '94041'
            }
          },
          relationships: {
            profile: {
              data: {
                type: 'profile',
                id:   'oi13uaiof2qoi'
              }
            }
          }
        }
      )
    end

    it 'passes phone, name, dob, ssn along to the attributes object' do
      described_class.call(
        connection:   connection,
        profile_id:   'oi13uaiof2qoi',
        phone_number: '+12223334444',
        name:         {
          first:  'Delmer',
          middle: 'Loves',
          last:   'Pokemon'
        },
        ssn:          {
          area:   '123',
          group:  '45',
          serial: '6789'
        },
        birth:        {
          day:   23,
          month: 8,
          year:  1993
        },
        us_address:   {
          street:      '123 Main St',
          city:        'Mountain View',
          subdivision: 'CA',
          postal_code: '94041'
        }
      )

      expect(connection).to have_received(:run).with(request)
    end
  end

  context 'when request is ACCEPTED 202' do
    let(:headers) do
      { 'Content-Location' => location }
    end
    let(:location) { '/identity_searches/jobs/o3irufoai3o' }

    it 'returns a processing identity response' do
      is_expected.to eql(
        Cognito::Client::Response::IdentitySearchJob.build(http_response, connection, location)
      )
    end
  end

  context 'when request is CREATED, 201' do
    let(:status_code) { 201 }

    let(:body) do
      <<-JSON
        {
          "data": {
            "type": "identity_search",
            "id": "o3irufoai3o",
            "attributes": {
              "created_at": "2016-06-27T19:37:18Z",
              "phone": {
                "number": "+16508007985"
              }
            },
            "relationships": {
              "profile": {
                "data": {
                  "type": "profile",
                  "id": "oi13uaiof2qoi"
                }
              },
              "identity_records": {
                "data": []
              }
            }
          },
          "included": []
        }
      JSON
    end

    it 'build the identity_search response' do
      is_expected.to eql(Cognito::Client::Response::IdentitySearch.build(http_response, connection))
    end
  end

  it_behaves_like 'a command with an unexpected response code' do
    let(:status_code)   { 204          }
    let(:status_reason) { 'No Content' }
  end

  it_behaves_like 'a properly failing command'
end
