# frozen_string_literal: true

RSpec.describe "retry-command" do
  def run_retry_command(*args)
    run_tool("retry-command", *args)
  end

  describe "--version" do
    it "displays the version number" do
      result = run_retry_command("--version")

      expect(result.stdout).to match(/retry-command \d+\.\d+\.\d+/)
      expect(result).to be_success
    end
  end

  describe "--help" do
    it "displays usage information" do
      result = run_retry_command("--help")

      expect(result.stdout).to include("Usage:")
      expect(result.stdout).to include("--delay")
      expect(result.stdout).to include("--max-retries")
      expect(result.stdout).to include("--stop-on-success")
      expect(result.stdout).to include("Examples:")
      expect(result).to be_success
    end
  end

  describe "without a command" do
    it "displays an error" do
      result = run_retry_command

      expect(result.stderr).to include("No command specified")
      expect(result.exit_code).to eq(1)
    end
  end

  describe "with invalid options" do
    it "rejects unknown options" do
      result = run_retry_command("--unknown")

      expect(result.stderr).to include("Unknown option")
      expect(result.exit_code).to eq(1)
    end

    it "rejects non-numeric delay" do
      result = run_retry_command("-d", "abc", "--", "true")

      expect(result.stderr).to include("positive integer")
      expect(result.exit_code).to eq(1)
    end

    it "rejects non-numeric max-retries" do
      result = run_retry_command("-m", "abc", "--", "true")

      expect(result.stderr).to include("non-negative integer")
      expect(result.exit_code).to eq(1)
    end
  end

  describe "--stop-on-success" do
    it "exits after command succeeds" do
      result = run_retry_command("-s", "-d", "0", "--", "true")

      expect(result.stdout).to include("succeeded")
      expect(result).to be_success
    end
  end

  describe "--max-retries" do
    it "stops after max retries on failure" do
      result = run_retry_command("-m", "2", "-d", "0", "-s", "--", "false")

      expect(result.stdout).to include("failed after 2 attempt")
      expect(result.stdout).to include("Giving up")
      expect(result.exit_code).to eq(1)
    end
  end

  describe "--quiet" do
    it "suppresses status messages" do
      result = run_retry_command("-q", "-s", "-m", "1", "-d", "0", "--", "false")

      # Should have no output (or minimal output)
      expect(result.stdout.strip).to eq("")
      expect(result.exit_code).to eq(1)
    end

    it "still runs the command successfully" do
      with_temp_dir do |dir|
        output_file = File.join(dir, "output.txt")
        result = run_retry_command("-q", "-s", "-d", "0", "--", "sh", "-c", "echo done > #{output_file}")

        expect(result).to be_success
        expect(File.read(output_file).strip).to eq("done")
      end
    end
  end

  describe "--delay" do
    it "accepts custom delay value" do
      # Just verify it parses correctly, actual delay tested with 0
      result = run_retry_command("-d", "5", "-s", "--", "true")

      expect(result).to be_success
    end
  end

  describe "retrying until success" do
    it "retries a failing command until it succeeds" do
      with_temp_dir do |dir|
        counter_file = File.join(dir, "counter")
        File.write(counter_file, "0")

        # Script that fails twice then succeeds
        script = <<~SCRIPT
          count=$(cat #{counter_file})
          count=$((count + 1))
          echo $count > #{counter_file}
          if [ $count -lt 3 ]; then exit 1; fi
          exit 0
        SCRIPT

        script_file = File.join(dir, "test-script.sh")
        File.write(script_file, script)
        File.chmod(0755, script_file)

        result = run_retry_command("-s", "-d", "0", "--", script_file)

        expect(result).to be_success
        expect(File.read(counter_file).strip).to eq("3")
      end
    end
  end

  describe "supervisor mode", skip: "runs indefinitely without --stop-on-success" do
    it "reruns command after success"
  end

  describe "command with arguments in a single string" do
    it "executes the command correctly when passed as a single quoted string" do
      with_temp_dir do |dir|
        output_file = File.join(dir, "output.txt")
        # Simulate: retry-command -s -d 0 -- 'echo hello world > output.txt'
        # The command is passed as a single string argument
        result = run_retry_command("-s", "-d", "0", "-m", "1", "--", "echo hello world > #{output_file}")

        expect(result).to be_success
        expect(File.exist?(output_file)).to be true
        expect(File.read(output_file).strip).to eq("hello world")
      end
    end
  end
end
