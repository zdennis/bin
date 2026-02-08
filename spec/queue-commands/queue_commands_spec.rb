# frozen_string_literal: true

RSpec.describe "queue-commands" do
  def run_queue_commands(*args)
    run_tool("queue-commands", *args)
  end

  describe "--version" do
    it "displays the version number" do
      result = run_queue_commands("--version")

      expect(result.stdout).to match(/queue-commands \d+\.\d+\.\d+/)
      expect(result).to be_success
    end
  end

  describe "--help" do
    it "displays usage information" do
      result = run_queue_commands("--help")

      expect(result.stdout).to include("Usage:")
      expect(result.stdout).to include("--file")
      expect(result.stdout).to include("--wait")
      expect(result.stdout).to include("--continue")
      expect(result).to be_success
    end
  end

  describe "without required -f option" do
    it "displays an error" do
      result = run_queue_commands

      expect(result.stderr).to include("Missing required option")
      expect(result.exit_code).to eq(1)
    end
  end

  describe "with non-existent file" do
    it "displays an error" do
      result = run_queue_commands("-f", "/nonexistent/file.txt")

      expect(result.stderr).to include("File not found")
      expect(result.exit_code).to eq(1)
    end
  end

  describe "executing commands" do
    it "runs commands from a file in sequence" do
      with_temp_dir do |dir|
        commands_file = File.join(dir, "commands.txt")
        output_file = File.join(dir, "output.txt")

        File.write(commands_file, <<~COMMANDS)
          echo first >> #{output_file}
          echo second >> #{output_file}
          echo third >> #{output_file}
        COMMANDS

        result = run_queue_commands("-f", commands_file)

        expect(result).to be_success
        output = File.read(output_file)
        expect(output).to eq("first\nsecond\nthird\n")
      end
    end

    it "skips comment lines" do
      with_temp_dir do |dir|
        commands_file = File.join(dir, "commands.txt")
        output_file = File.join(dir, "output.txt")

        File.write(commands_file, <<~COMMANDS)
          # This is a comment
          echo included >> #{output_file}
          # Another comment
        COMMANDS

        result = run_queue_commands("-f", commands_file)

        expect(result).to be_success
        output = File.read(output_file)
        expect(output).to eq("included\n")
      end
    end

    it "skips empty lines" do
      with_temp_dir do |dir|
        commands_file = File.join(dir, "commands.txt")
        output_file = File.join(dir, "output.txt")

        File.write(commands_file, <<~COMMANDS)
          echo first >> #{output_file}

          echo second >> #{output_file}
        COMMANDS

        result = run_queue_commands("-f", commands_file)

        expect(result).to be_success
        output = File.read(output_file)
        expect(output).to eq("first\nsecond\n")
      end
    end
  end

  describe "--continue" do
    it "continues on error without pausing" do
      with_temp_dir do |dir|
        commands_file = File.join(dir, "commands.txt")
        output_file = File.join(dir, "output.txt")

        File.write(commands_file, <<~COMMANDS)
          echo first >> #{output_file}
          false
          echo third >> #{output_file}
        COMMANDS

        result = run_queue_commands("-f", commands_file, "--continue")

        # Should have non-zero exit due to failure
        expect(result.exit_code).to eq(1)
        # But should have continued to run third command
        output = File.read(output_file)
        expect(output).to eq("first\nthird\n")
      end
    end
  end

  describe "--verbose" do
    it "shows additional execution information" do
      with_temp_dir do |dir|
        commands_file = File.join(dir, "commands.txt")

        File.write(commands_file, "echo hello\n")

        result = run_queue_commands("-f", commands_file, "--verbose")

        expect(result.stdout).to include("Loaded 1 command")
        expect(result.stdout).to include("[1/1] Running:")
        expect(result.stdout).to include("Completed:")
        expect(result).to be_success
      end
    end
  end

  describe "--wait mode", skip: "requires interactive terminal" do
    it "pauses before each command for confirmation"
  end

  describe "error handling pause", skip: "requires interactive terminal" do
    it "pauses on error when --continue is not specified"
  end
end
