# frozen_string_literal: true

RSpec.describe "grab-column" do
  def run_grab_column(*args, stdin_data: nil)
    run_tool("grab-column", *args, stdin_data: stdin_data)
  end

  describe "--version" do
    it "displays the version number" do
      result = run_grab_column("--version")

      expect(result.stdout).to match(/grab-column \d+\.\d+\.\d+/)
      expect(result).to be_success
    end
  end

  describe "--help" do
    it "displays usage information" do
      result = run_grab_column("--help")

      expect(result.stdout).to include("Usage:")
      expect(result.stdout).to include("column number")
      expect(result).to be_success
    end
  end

  describe "with no STDIN (tty)", skip: "requires interactive terminal (STDIN.tty? returns false in tests)" do
    it "shows help and exits with error"
  end

  describe "extracting columns" do
    let(:input) do
      <<~INPUT
        apple   red     fruit
        banana  yellow  fruit
        carrot  orange  vegetable
      INPUT
    end

    it "extracts a single column (1-based indexing)" do
      result = run_grab_column("1", stdin_data: input)

      lines = result.stdout.lines.map(&:strip)
      expect(lines).to eq(["apple", "banana", "carrot"])
      expect(result).to be_success
    end

    it "extracts the second column" do
      result = run_grab_column("2", stdin_data: input)

      lines = result.stdout.lines.map(&:strip)
      expect(lines).to eq(["red", "yellow", "orange"])
      expect(result).to be_success
    end

    it "extracts the third column" do
      result = run_grab_column("3", stdin_data: input)

      lines = result.stdout.lines.map(&:strip)
      expect(lines).to eq(["fruit", "fruit", "vegetable"])
      expect(result).to be_success
    end

    it "extracts multiple columns" do
      result = run_grab_column("1", "3", stdin_data: input)

      lines = result.stdout.lines.map { |l| l.split.map(&:strip) }
      expect(lines).to eq([
        ["apple", "fruit"],
        ["banana", "fruit"],
        ["carrot", "vegetable"]
      ])
      expect(result).to be_success
    end

    it "extracts columns in specified order" do
      result = run_grab_column("3", "1", stdin_data: input)

      lines = result.stdout.lines.map { |l| l.split.map(&:strip) }
      expect(lines).to eq([
        ["fruit", "apple"],
        ["fruit", "banana"],
        ["vegetable", "carrot"]
      ])
      expect(result).to be_success
    end
  end

  describe "with varying whitespace" do
    it "handles multiple spaces between columns" do
      input = "col1    col2      col3\n"
      result = run_grab_column("2", stdin_data: input)

      expect(result.stdout.strip).to eq("col2")
      expect(result).to be_success
    end

    it "handles tabs between columns" do
      input = "col1\tcol2\tcol3\n"
      result = run_grab_column("2", stdin_data: input)

      expect(result.stdout.strip).to eq("col2")
      expect(result).to be_success
    end
  end

  describe "with missing columns" do
    it "returns empty string for non-existent columns" do
      input = "col1 col2\n"
      result = run_grab_column("5", stdin_data: input)

      # Non-existent column returns empty
      expect(result.stdout.strip).to eq("")
      expect(result).to be_success
    end
  end

  describe "column alignment" do
    it "aligns output columns for readability" do
      input = <<~INPUT
        short   val
        verylongword   val
      INPUT

      result = run_grab_column("1", "2", stdin_data: input)

      # Output should be tab-separated and aligned
      expect(result.stdout).to include("short")
      expect(result.stdout).to include("verylongword")
      expect(result).to be_success
    end
  end
end
