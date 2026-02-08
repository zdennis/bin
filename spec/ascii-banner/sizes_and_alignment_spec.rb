# frozen_string_literal: true

RSpec.describe "ascii-banner sizes and alignment" do
  def run_ascii_banner(*args)
    run_tool("ascii-banner", *args)
  end

  describe "--size" do
    it "renders tiny size with 't' shortcut" do
      result = run_ascii_banner("-s", "t", "HI")

      # Tiny font uses half-block characters
      expect(result.stdout).to match(/[▀▄█]/)
      expect(result).to be_success
    end

    it "renders tiny size with 'tiny'" do
      result = run_ascii_banner("-s", "tiny", "HI")

      expect(result.stdout).to match(/[▀▄█]/)
      expect(result).to be_success
    end

    it "renders small size with 's' shortcut" do
      result = run_ascii_banner("-s", "s", "HI")

      expect(result.stdout).to include("█")
      expect(result).to be_success
    end

    it "renders medium size with 'm' shortcut" do
      result = run_ascii_banner("-s", "m", "HI")

      expect(result.stdout).to include("█")
      expect(result).to be_success
    end

    it "renders large size with 'l' shortcut" do
      result = run_ascii_banner("-s", "l", "HI")

      # Large is 2x scaled, should have more output
      expect(result.stdout).to include("██")
      expect(result).to be_success
    end

    it "renders extra-large size with 'xl' shortcut" do
      result = run_ascii_banner("-s", "xl", "HI")

      # Extra-large is 3x scaled
      expect(result.stdout).to include("███")
      expect(result).to be_success
    end
  end

  describe "alignment" do
    it "left-aligns text by default" do
      result = run_ascii_banner("--no-auto-scale", "-w", "80", "A")

      # First non-empty line should start near the beginning
      first_line = result.stdout.lines.find { |l| l.include?("█") }
      expect(first_line).to start_with(" ") | start_with("█")
      expect(result).to be_success
    end

    it "right-aligns text with --right" do
      result = run_ascii_banner("--no-auto-scale", "-w", "80", "--right", "A")

      # Lines should have leading spaces for right alignment
      first_line = result.stdout.lines.find { |l| l.include?("█") }
      expect(first_line).to match(/^\s{10,}/)  # Should have significant leading space
      expect(result).to be_success
    end

    it "center-aligns text with --center" do
      result = run_ascii_banner("--no-auto-scale", "-w", "80", "--center", "A")

      # Lines should have leading spaces for centering
      first_line = result.stdout.lines.find { |l| l.include?("█") }
      expect(first_line).to match(/^\s+/)  # Should have some leading space
      expect(result).to be_success
    end
  end

  describe "--margin" do
    it "adds default margin of 2 when no value specified" do
      result = run_ascii_banner("--no-auto-scale", "--margin", "HI")

      lines = result.stdout.lines
      # Should have empty lines at top for margin
      expect(lines[0]).to eq("\n")
      expect(lines[1]).to eq("\n")
      expect(result).to be_success
    end

    it "adds uniform margin with single value" do
      result = run_ascii_banner("--no-auto-scale", "--margin=3", "HI")

      lines = result.stdout.lines
      # Should have 3 empty lines at top
      expect(lines[0]).to eq("\n")
      expect(lines[1]).to eq("\n")
      expect(lines[2]).to eq("\n")
      # Content lines should have 3-space indent
      content_line = lines.find { |l| l.include?("█") }
      expect(content_line).to start_with("   ")
      expect(result).to be_success
    end

    it "adds row,col margin with two values" do
      result = run_ascii_banner("--no-auto-scale", "--margin", "2,4", "HI")

      lines = result.stdout.lines
      # Should have 2 empty lines at top
      expect(lines[0]).to eq("\n")
      expect(lines[1]).to eq("\n")
      # Content lines should have 4-space indent
      content_line = lines.find { |l| l.include?("█") }
      expect(content_line).to start_with("    ")
      expect(result).to be_success
    end
  end

  describe "--width" do
    it "limits the width of output" do
      result = run_ascii_banner("--no-auto-scale", "-w", "40", "HELLO")

      lines = result.stdout.lines.map(&:rstrip)
      max_width = lines.map(&:length).max
      # Should truncate or wrap to fit within width
      expect(max_width).to be <= 40
      expect(result).to be_success
    end
  end

  describe "--no-auto-scale" do
    it "uses medium size without auto-scaling" do
      result = run_ascii_banner("--no-auto-scale", "HI")

      # Medium font has 6 rows
      content_lines = result.stdout.lines.select { |l| l.include?("█") }
      expect(content_lines.length).to eq(6)
      expect(result).to be_success
    end
  end

  describe "interactive modes" do
    # These modes require a TTY and are difficult to test automatically
    describe "--watch mode", skip: "requires interactive terminal" do
      it "re-renders on terminal resize"
    end

    describe "-s r (rotate) mode", skip: "requires interactive terminal" do
      it "rotates through sizes"
    end
  end
end
