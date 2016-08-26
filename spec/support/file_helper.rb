# frozen_string_literal: true

module FileHelper
  # Maps file names to relative file position
  FILES = {
    profile: '/files/profile.json',
    identity_search: '/files/identity_search.json',
    identity_assessment: '/files/identity_assessment.json'
  }.freeze

  def self.read_file(name)
    path = FILES.fetch(name) { raise ArgumentError, 'unknown file' }
    File.open(File.join(File.dirname(__FILE__), path), 'rb+').read
  end

  def self.load_json(name)
    JSON.parse(load_file(name), symbolize_names: true)
  end
end
