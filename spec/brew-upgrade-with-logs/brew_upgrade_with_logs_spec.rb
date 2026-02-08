# frozen_string_literal: true

RSpec.describe "brew-upgrade-with-logs" do
  def run_brew_upgrade(*args)
    run_tool("brew-upgrade-with-logs", *args)
  end

  describe "--version" do
    it "displays the version number" do
      result = run_brew_upgrade("--version")

      expect(result.stdout).to match(/brew-upgrade-with-logs \d+\.\d+\.\d+/)
      expect(result).to be_success
    end
  end

  describe "--help" do
    it "displays usage information" do
      result = run_brew_upgrade("--help")

      expect(result.stdout).to include("Usage:")
      expect(result.stdout).to include("--log-dir")
      expect(result.stdout).to include("--dry-run")
      expect(result).to be_success
    end
  end

  describe "--dry-run" do
    it "shows the command without executing it" do
      result = run_brew_upgrade("--dry-run")

      expect(result.stdout).to include("Upgrading brew with command:")
      expect(result.stdout).to include("brew update && brew upgrade")
      expect(result.stdout).to include("tee -a")
      expect(result.stdout).to include("(dry-run: command not executed)")
      expect(result).to be_success
    end

    it "does not create the log directory" do
      with_temp_dir do |dir|
        log_dir = File.join(dir, "brew-logs")
        result = run_brew_upgrade("--log-dir", log_dir, "--dry-run")

        expect(File.exist?(log_dir)).to be false
        expect(result).to be_success
      end
    end
  end

  describe "--log-dir" do
    it "uses custom log directory in the command" do
      with_temp_dir do |dir|
        log_dir = File.join(dir, "custom-logs")
        result = run_brew_upgrade("--log-dir", log_dir, "--dry-run")

        expect(result.stdout).to include(log_dir)
        expect(result).to be_success
      end
    end
  end

  describe "log file naming" do
    it "creates timestamped log files" do
      result = run_brew_upgrade("--dry-run")

      # Log file should contain timestamp pattern
      expect(result.stdout).to match(/\d{4}-\d{2}-\d{2}_\d{2}h\d{2}m\d{2}s\.log/)
      expect(result).to be_success
    end
  end
end
