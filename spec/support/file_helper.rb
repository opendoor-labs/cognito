# frozen_string_literal: true

module FileHelper
  # Maps file names to relative file position
  FILES = {
    identity_assessment: '/files/identity_assessment.json',
    identity_search: '/files/identity_search.json',
    identity_search_job: '/files/identity_search_job.json',
    identity_search_job_completed: '/files/completed_identity_search_job.json',
    profile: '/files/profile.json'
  }.freeze

  def self.read_file(name)
    path = FILES.fetch(name) { raise ArgumentError, 'unknown file' }
    File.open(File.join(File.dirname(__FILE__), path), 'rb+').read
  end

  def self.load_json(name)
    JSON.parse(read_file(name), symbolize_names: true)
  end
end
