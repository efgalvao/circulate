ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "spy/integration"
require "minitest/mock"

require "helpers/return_values"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include FactoryBot::Syntax::Methods

  def assert_size(expected, subject)
    assert_equal expected, subject.size, "wrong size; got #{subject.size} instead of #{expected}"
  end

  class << self
    def env_tags
      @env_tags ||= ENV.fetch("TAGS", "").split
    end

    def test(subject, *tags, &block)
      if tags.include?(:remote) && !env_tags.include?("remote")
        super subject do
          skip "Skipping remote test"
        end
      else
        super(subject, &block)
      end
    end
  end
end
