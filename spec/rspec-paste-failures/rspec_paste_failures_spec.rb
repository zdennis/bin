# frozen_string_literal: true

RSpec.describe "rspec-paste-failures" do
  def run_rspec_paste_failures(*args, stdin_data: nil)
    run_tool("rspec-paste-failures", *args, stdin_data: stdin_data)
  end

  describe "--version" do
    it "displays the version number" do
      result = run_rspec_paste_failures("--version")

      expect(result.stdout).to match(/rspec-paste-failures \d+\.\d+\.\d+/)
      expect(result).to be_success
    end
  end

  describe "--help" do
    it "displays usage information" do
      result = run_rspec_paste_failures("--help")

      expect(result.stdout).to include("rspec failure output")
      expect(result.stdout).to include("Failed examples")
      expect(result).to be_success
    end
  end

  describe "--stdin mode" do
    let(:rspec_output) do
      <<~OUTPUT
        4992 examples, 3 failures

        Failed examples:

        rspec ./spec/bar_spec.rb:23 # failed for a reason
        rspec ./spec/baz_spec.rb:32 # failed for another reason
        rspec ./spec/foo_spec.rb:78 # failed for a third reason
      OUTPUT
    end

    it "extracts runnable commands with line numbers" do
      result = run_rspec_paste_failures("--stdin", stdin_data: rspec_output)

      expect(result.stdout).to include("Runnable command with line numbers")
      expect(result.stdout).to include("./spec/bar_spec.rb:23")
      expect(result.stdout).to include("./spec/baz_spec.rb:32")
      expect(result.stdout).to include("./spec/foo_spec.rb:78")
      expect(result).to be_success
    end

    it "extracts runnable commands by file only" do
      result = run_rspec_paste_failures("--stdin", stdin_data: rspec_output)

      expect(result.stdout).to include("Runnable command by file")
      # Should have file paths without line numbers
      expect(result.stdout).to match(/rspec.*\.\/spec\/bar_spec\.rb[^:]/)
      expect(result).to be_success
    end

    it "sorts and deduplicates file paths" do
      input = <<~OUTPUT
        rspec ./spec/z_spec.rb:10 # first
        rspec ./spec/a_spec.rb:20 # second
        rspec ./spec/a_spec.rb:30 # duplicate file
      OUTPUT

      result = run_rspec_paste_failures("--stdin", stdin_data: input)

      # Files should be sorted and deduplicated in the "by file" output
      lines_output = result.stdout.lines.find { |l| l.include?("rspec ./spec/a_spec.rb") }
      expect(result.stdout).to include("./spec/a_spec.rb")
      expect(result.stdout).to include("./spec/z_spec.rb")
      expect(result).to be_success
    end

    it "handles empty input" do
      result = run_rspec_paste_failures("--stdin", stdin_data: "no failures here\n")

      expect(result.stdout).to include("Runnable command")
      # Command should be just "rspec" with no arguments
      expect(result.stdout).to include("rspec")
      expect(result).to be_success
    end
  end

  describe "interactive mode", skip: "requires interactive terminal with Ctrl-C" do
    it "waits for input and outputs on Ctrl-C"
  end
end
