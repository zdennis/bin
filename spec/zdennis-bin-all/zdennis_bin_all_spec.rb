# frozen_string_literal: true

RSpec.describe "zdennis-bin-all" do
  def run_zdennis_bin_all(*args)
    run_tool("zdennis-bin-all", *args)
  end

  describe "--version" do
    it "displays the version number" do
      result = run_zdennis_bin_all("--version")

      expect(result.stdout).to match(/zdennis-bin-all \d+\.\d+\.\d+/)
      expect(result).to be_success
    end
  end

  describe "--help" do
    it "displays usage information" do
      result = run_zdennis_bin_all("--help")

      expect(result.stdout).to include("Usage:")
      expect(result.stdout).to include("zdennis/bin tools")
      expect(result).to be_success
    end
  end

  describe "listing tools" do
    it "lists available tools" do
      result = run_zdennis_bin_all

      expect(result.stdout).to include("zdennis/bin tools")
      expect(result.stdout).to include("alias-directory")
      expect(result.stdout).to include("ascii-banner")
      expect(result.stdout).to include("touchp")
      expect(result).to be_success
    end

    it "shows version information for each tool" do
      result = run_zdennis_bin_all

      # Format should include version numbers in parentheses
      expect(result.stdout).to match(/\(\d+\.\d+\.\d+\)/)
      expect(result).to be_success
    end

    it "provides helpful usage instructions" do
      result = run_zdennis_bin_all

      expect(result.stdout).to include("--help")
      expect(result.stdout).to include("--version")
      expect(result).to be_success
    end
  end
end
