# frozen_string_literal: true

RSpec.describe "rt" do
  def run_rt(*args, stdin_data: nil)
    run_tool("rt", *args, stdin_data: stdin_data)
  end

  describe "--version" do
    it "displays the version number" do
      result = run_rt("--version")

      expect(result.stdout).to match(/rt \d+\.\d+\.\d+/)
      expect(result).to be_success
    end
  end

  describe "--help" do
    it "displays usage information" do
      result = run_rt("--help")

      expect(result.stdout).to include("runs files through shell commands")
      expect(result.stdout).to include("--command")
      expect(result.stdout).to include("--bundle-exec")
      expect(result).to be_success
    end
  end

  describe "without commands" do
    it "displays an error" do
      result = run_rt("file.txt")

      expect(result.stderr).to include("no commands specified")
      expect(result.exit_code).to eq(1)
    end
  end

  describe "without files" do
    it "displays an error" do
      result = run_rt("-c", "echo")

      expect(result.stderr).to include("no files provided")
      expect(result.exit_code).to eq(1)
    end
  end

  describe "running commands" do
    # Note: When STDIN is not a tty (like in tests), rt reads files from STDIN
    # So we pass files via stdin_data

    it "runs a command with files from stdin" do
      with_temp_dir do |dir|
        output_file = File.join(dir, "output.txt")
        file1 = File.join(dir, "file1.txt")
        file2 = File.join(dir, "file2.txt")
        FileUtils.touch([file1, file2])

        stdin_input = "#{file1}\n#{file2}\n"
        result = run_rt("-c", "echo >> #{output_file}", stdin_data: stdin_input)

        expect(result).to be_success
        output = File.read(output_file)
        expect(output).to include(file1)
        expect(output).to include(file2)
      end
    end

    it "runs multiple commands" do
      with_temp_dir do |dir|
        output1 = File.join(dir, "output1.txt")
        output2 = File.join(dir, "output2.txt")
        file = File.join(dir, "test.txt")
        FileUtils.touch(file)

        stdin_input = "#{file}\n"
        result = run_rt("-c", "echo cmd1 >> #{output1}", "-c", "echo cmd2 >> #{output2}", stdin_data: stdin_input)

        expect(result).to be_success
        expect(File.read(output1)).to include("cmd1")
        expect(File.read(output2)).to include("cmd2")
      end
    end
  end

  describe "--individual" do
    it "runs command once per file" do
      with_temp_dir do |dir|
        output_file = File.join(dir, "output.txt")
        file1 = File.join(dir, "file1.txt")
        file2 = File.join(dir, "file2.txt")
        FileUtils.touch([file1, file2])

        stdin_input = "#{file1}\n#{file2}\n"
        result = run_rt("-i", "-c", "echo >> #{output_file}", stdin_data: stdin_input)

        expect(result).to be_success
        # Should have run twice (once per file)
        output_lines = File.read(output_file).lines
        expect(output_lines.length).to eq(2)
      end
    end
  end

  describe "--dry-run" do
    it "shows what would run without executing" do
      with_temp_dir do |dir|
        file = File.join(dir, "test.txt")
        FileUtils.touch(file)
        marker_file = File.join(dir, "marker.txt")

        stdin_input = "#{file}\n"
        result = run_rt("-n", "-c", "touch #{marker_file}", stdin_data: stdin_input)

        expect(result.stdout).to include("Would run:")
        expect(result.stdout).to include("touch")
        expect(result).to be_success
        # Marker file should NOT be created
        expect(File.exist?(marker_file)).to be false
      end
    end
  end

  describe "--verbose" do
    it "prints command before running" do
      with_temp_dir do |dir|
        file = File.join(dir, "test.txt")
        FileUtils.touch(file)

        stdin_input = "#{file}\n"
        result = run_rt("-V", "-c", "true", stdin_data: stdin_input)

        expect(result.stdout).to include("Running:")
        expect(result).to be_success
      end
    end
  end

  describe "command failure" do
    it "exits with non-zero status when command fails" do
      with_temp_dir do |dir|
        file = File.join(dir, "test.txt")
        FileUtils.touch(file)

        stdin_input = "#{file}\n"
        result = run_rt("-c", "false", stdin_data: stdin_input)

        expect(result.stderr).to include("command failed")
        expect(result.exit_code).to eq(1)
      end
    end
  end

  describe "file escaping" do
    it "properly escapes files with spaces" do
      with_temp_dir do |dir|
        file = File.join(dir, "file with spaces.txt")
        FileUtils.touch(file)
        output_file = File.join(dir, "output.txt")

        stdin_input = "#{file}\n"
        result = run_rt("-c", "echo >> #{Shellwords.shellescape(output_file)}", stdin_data: stdin_input)

        expect(result).to be_success
      end
    end
  end
end
