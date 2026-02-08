# frozen_string_literal: true

RSpec.describe "reverse" do
  def run_reverse(*args, stdin_data: nil)
    run_tool("reverse", *args, stdin_data: stdin_data)
  end

  describe "--version" do
    it "displays the version number" do
      result = run_reverse("--version")

      expect(result.stdout).to match(/reverse \d+\.\d+\.\d+/)
      expect(result).to be_success
    end
  end

  describe "--help" do
    it "displays usage information" do
      result = run_reverse("--help")

      expect(result.stdout).to include("Usage:")
      expect(result.stdout).to include("Reverses the order of lines")
      expect(result).to be_success
    end
  end

  describe "reversing lines" do
    it "reverses multiple lines" do
      input = "line1\nline2\nline3\n"
      result = run_reverse(stdin_data: input)

      lines = result.stdout.lines.map(&:strip)
      expect(lines).to eq(["line3", "line2", "line1"])
      expect(result).to be_success
    end

    it "handles a single line" do
      result = run_reverse(stdin_data: "only line\n")

      expect(result.stdout.strip).to eq("only line")
      expect(result).to be_success
    end

    it "handles empty input" do
      result = run_reverse(stdin_data: "")

      expect(result.stdout).to eq("")
      expect(result).to be_success
    end

    it "preserves blank lines" do
      input = "first\n\nsecond\n\nthird\n"
      result = run_reverse(stdin_data: input)

      lines = result.stdout.lines.map(&:chomp)
      expect(lines).to eq(["third", "", "second", "", "first"])
      expect(result).to be_success
    end

    it "handles lines with whitespace" do
      input = "  indented\nnormal\n  also indented  \n"
      result = run_reverse(stdin_data: input)

      lines = result.stdout.lines.map(&:chomp)
      expect(lines).to eq(["  also indented  ", "normal", "  indented"])
      expect(result).to be_success
    end
  end
end
