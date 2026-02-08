# frozen_string_literal: true

require "fileutils"
require "tmpdir"
require "open3"
require "ostruct"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = "spec/.rspec_status"
  config.disable_monkey_patching!
  config.warnings = true

  config.default_formatter = "doc" if config.files_to_run.one?

  config.order = :random
  Kernel.srand config.seed
end

# Helper module for running CLI commands in tests
module CLIHelper
  # Path to the bin directory
  def bin_path
    File.expand_path("../../bin", __FILE__)
  end

  # Run a command and return stdout, stderr, and exit status
  # Accepts either a string command or an array of arguments
  def run_command(command, stdin_data: nil, env: {})
    full_env = ENV.to_h.merge(env)
    stdout, stderr, status = Open3.capture3(full_env, *Array(command), stdin_data: stdin_data)
    OpenStruct.new(
      stdout: stdout,
      stderr: stderr,
      status: status,
      success?: status.success?,
      exit_code: status.exitstatus
    )
  end

  # Run a tool from bin/ directory
  # Uses array-based execution to properly handle special characters
  def run_tool(tool_name, *args, stdin_data: nil, env: {})
    tool_path = File.join(bin_path, tool_name)
    command = [tool_path, *args.map(&:to_s)]
    run_command(command, stdin_data: stdin_data, env: env)
  end

  # Create a temporary directory for test isolation
  # Returns the real path (resolving symlinks like /var -> /private/var on macOS)
  def with_temp_dir
    Dir.mktmpdir do |dir|
      real_dir = File.realpath(dir)
      yield real_dir
    end
  end

  # Create a temporary git repository
  def with_temp_git_repo
    with_temp_dir do |dir|
      Dir.chdir(dir) do
        system("git init --quiet")
        system("git config user.email 'test@test.com'")
        system("git config user.name 'Test User'")
        yield dir
      end
    end
  end
end

RSpec.configure do |config|
  config.include CLIHelper
end
