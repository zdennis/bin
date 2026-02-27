# frozen_string_literal: true

RSpec.describe "ascii-banner" do
  def run_ascii_banner(*args)
    run_tool("ascii-banner", *args)
  end

  describe "--version" do
    it "displays the version number" do
      result = run_ascii_banner("--version")

      expect(result.stdout).to match(/ascii-banner \d+\.\d+\.\d+/)
      expect(result).to be_success
    end
  end

  describe "--help" do
    it "displays usage information" do
      result = run_ascii_banner("--help")

      expect(result.stdout).to include("Usage:")
      expect(result.stdout).to include("--color")
      expect(result.stdout).to include("--rainbow")
      expect(result.stdout).to include("--size")
      expect(result).to be_success
    end
  end

  describe "with no text" do
    it "displays an error and exits with non-zero status" do
      result = run_ascii_banner

      expect(result.stderr).to include("No text provided")
      expect(result.exit_code).to eq(1)
    end
  end

  describe "basic text rendering" do
    it "renders text as ASCII art" do
      result = run_ascii_banner("--no-auto-scale", "HI")

      expect(result.stdout).to include("█")
      expect(result).to be_success
    end

    it "renders multiple words as a single banner" do
      result = run_ascii_banner("--no-auto-scale", "HELLO", "WORLD")

      # Should render as "HELLO WORLD" with space between
      expect(result.stdout).to include("█")
      expect(result).to be_success
    end
  end

  describe "--list-colors" do
    it "lists available colors with categories" do
      result = run_ascii_banner("--list-colors")

      expect(result.stdout).to include("Available colors")
      expect(result.stdout).to include("Basic colors")
      expect(result.stdout).to include("Bright colors")
      expect(result.stdout).to include("Extended colors")
      expect(result.stdout).to include("Grayscale")
      expect(result.stdout).to include("red")
      expect(result.stdout).to include("blue")
      expect(result).to be_success
    end
  end

  describe "--color" do
    it "applies a named color to the output" do
      result = run_ascii_banner("--no-auto-scale", "--color", "red", "HI")

      # ANSI escape code for 256 color (red = 1)
      expect(result.stdout).to include("\e[38;5;1m")
      expect(result).to be_success
    end

    it "warns on unknown color names" do
      result = run_ascii_banner("--no-auto-scale", "--color", "not_a_color", "HI")

      expect(result.stderr).to include("Unknown color")
      expect(result).to be_success  # Still renders, just without color
    end
  end

  describe "--rainbow" do
    it "applies rainbow colors to the output" do
      result = run_ascii_banner("--no-auto-scale", "--rainbow", "HI")

      # Rainbow uses multiple color codes
      expect(result.stdout).to include("\e[38;5;")
      expect(result).to be_success
    end

    it "can be combined with --color for tinting" do
      result = run_ascii_banner("--no-auto-scale", "--rainbow", "--color", "cyan", "HI")

      expect(result.stdout).to include("\e[38;5;")
      expect(result).to be_success
    end
  end

  describe "--random" do
    it "picks a random color" do
      result = run_ascii_banner("--no-auto-scale", "--random", "HI")

      expect(result.stdout).to include("\e[38;5;")
      expect(result).to be_success
    end
  end

  describe "--max-lines" do
    it "strips trailing blank lines from characters with empty bottom rows" do
      without = run_ascii_banner("--no-auto-scale", "'")
      with_max = run_ascii_banner("--no-auto-scale", "--max-lines", "'")

      without_lines = without.stdout.lines
      with_lines = with_max.stdout.lines

      expect(with_lines.length).to be < without_lines.length
      expect(with_lines.last.strip).not_to be_empty
      expect(with_max).to be_success
    end

    it "strips trailing blank lines added by bottom margin" do
      without = run_ascii_banner("--no-auto-scale", "--margin", "2", "HI")
      with_max = run_ascii_banner("--no-auto-scale", "--margin", "2", "--max-lines", "HI")

      without_lines = without.stdout.lines
      with_lines = with_max.stdout.lines

      expect(with_lines.length).to be < without_lines.length
      expect(with_max).to be_success
    end

    it "preserves all lines when there are no trailing blank lines" do
      without = run_ascii_banner("--no-auto-scale", "HI")
      with_max = run_ascii_banner("--no-auto-scale", "--max-lines", "HI")

      expect(with_max.stdout.lines.length).to eq(without.stdout.lines.length)
      expect(with_max).to be_success
    end
  end
end
