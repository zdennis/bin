# frozen_string_literal: true

RSpec.describe "set-random-background-color" do
  def run_set_random_bg(*args)
    run_tool("set-random-background-color", *args)
  end

  describe "--version" do
    it "displays the version number" do
      result = run_set_random_bg("--version")

      expect(result.stdout).to match(/set-random-background-color \d+\.\d+\.\d+/)
      expect(result).to be_success
    end
  end

  describe "--help" do
    it "displays usage information" do
      result = run_set_random_bg("--help")

      expect(result.stdout).to include("Usage:")
      expect(result.stdout).to include("iTerm2")
      expect(result.stdout).to include("--dry-run")
      expect(result).to be_success
    end
  end

  describe "--dry-run" do
    it "shows the color without applying it" do
      result = run_set_random_bg("--dry-run")

      expect(result.stdout).to include("Would set background color to:")
      expect(result.stdout).to match(/#[0-9a-f]{6}/)  # Hex color format
      expect(result.stdout).to include("RGB:")
      expect(result).to be_success
    end

    it "generates valid dark colors" do
      # Run multiple times to check various colors
      10.times do
        result = run_set_random_bg("--dry-run")

        # Extract RGB values
        match = result.stdout.match(/RGB: (\d+), (\d+), (\d+)/)
        expect(match).not_to be_nil

        r, g, b = match[1..3].map(&:to_i)

        # Verify dark color constraints
        # R and G should be in [0, 11, 22, 33, 44, 55, 66, 77]
        expect([0, 11, 22, 33, 44, 55, 66, 77]).to include(r)
        expect([0, 11, 22, 33, 44, 55, 66, 77]).to include(g)
        # B should be in [0, 25, 50, 75]
        expect([0, 25, 50, 75]).to include(b)
      end
    end
  end

  describe "normal mode" do
    it "outputs iTerm2 escape sequence" do
      result = run_set_random_bg

      # Should output escape sequence for iTerm2
      expect(result.stdout).to include("SetColors=bg=")
      expect(result).to be_success
    end
  end
end
