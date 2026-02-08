# frozen_string_literal: true

RSpec.describe "grab-pattern" do
  def run_grab_pattern(*args, stdin_data: nil)
    run_tool("grab-pattern", *args, stdin_data: stdin_data)
  end

  describe "--version" do
    it "displays the version number" do
      result = run_grab_pattern("--version")

      expect(result.stdout).to match(/grab-pattern \d+\.\d+\.\d+/)
      expect(result).to be_success
    end
  end

  describe "--help" do
    it "displays usage information" do
      result = run_grab_pattern("--help")

      expect(result.stdout).to include("Usage:")
      expect(result.stdout).to include("pattern")
      expect(result.stdout).to include("Examples:")
      expect(result).to be_success
    end
  end

  describe "with no patterns and STDIN" do
    it "displays an error" do
      result = run_grab_pattern(stdin_data: "some input\n")

      expect(result.stderr).to include("no patterns specified")
      expect(result.exit_code).to eq(1)
    end
  end

  describe "extracting patterns" do
    it "extracts numbers from text" do
      input = "Order 123 costs $45\nOrder 456 costs $78\n"
      result = run_grab_pattern('\d+', stdin_data: input)

      lines = result.stdout.lines.map(&:strip)
      expect(lines).to eq(["123", "456"])
      expect(result).to be_success
    end

    it "extracts email addresses" do
      input = "Contact: john@example.com\nAlso: jane@test.org\n"
      result = run_grab_pattern('[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}', stdin_data: input)

      lines = result.stdout.lines.map(&:strip)
      expect(lines).to eq(["john@example.com", "jane@test.org"])
      expect(result).to be_success
    end

    it "extracts multiple patterns into columns" do
      input = "192.168.1.1 GET /api 200\n10.0.0.1 POST /login 201\n"
      # Extract IP and status code
      result = run_grab_pattern('\d+\.\d+\.\d+\.\d+', '\d+$', stdin_data: input)

      lines = result.stdout.lines.map { |l| l.split.map(&:strip) }
      expect(lines).to eq([
        ["192.168.1.1", "200"],
        ["10.0.0.1", "201"]
      ])
      expect(result).to be_success
    end
  end

  describe "capture groups" do
    it "extracts captured content from patterns with groups" do
      input = "name=John age=30\nname=Jane age=25\n"
      result = run_grab_pattern('name=(\w+)', 'age=(\d+)', stdin_data: input)

      lines = result.stdout.lines.map { |l| l.split.map(&:strip) }
      expect(lines).to eq([
        ["John", "30"],
        ["Jane", "25"]
      ])
      expect(result).to be_success
    end
  end

  describe "non-matching lines" do
    it "outputs empty string for non-matching patterns" do
      input = "has number 123\nno numbers here\nmore 456 numbers\n"
      result = run_grab_pattern('\d+', stdin_data: input)

      lines = result.stdout.lines.map(&:strip)
      expect(lines).to eq(["123", "", "456"])
      expect(result).to be_success
    end
  end

  describe "invalid patterns" do
    it "displays error for invalid regex" do
      result = run_grab_pattern('[invalid', stdin_data: "some input\n")

      expect(result.stderr).to include("invalid pattern")
      expect(result.exit_code).to eq(1)
    end
  end

  describe "column alignment" do
    it "aligns columns by max width" do
      input = "short 123\nverylongword 456\n"
      result = run_grab_pattern('\w+', '\d+', stdin_data: input)

      # Output should be tab-separated
      expect(result.stdout).to include("short")
      expect(result.stdout).to include("verylongword")
      expect(result).to be_success
    end
  end
end
