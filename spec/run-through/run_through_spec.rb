# frozen_string_literal: true

RSpec.describe "run-through" do
  def run_run_through(*args, stdin_data: nil)
    run_tool("run-through", *args, stdin_data: stdin_data)
  end

  describe "--version" do
    it "displays the version number" do
      result = run_run_through("--version")

      expect(result.stdout).to match(/run-through \d+\.\d+\.\d+/)
      expect(result).to be_success
    end
  end

  describe "--help" do
    it "displays usage information" do
      result = run_run_through("--help")

      expect(result.stdout).to include("runs files through shell commands")
      expect(result.stdout).to include("--command")
      expect(result.stdout).to include("--bundle-exec")
      expect(result).to be_success
    end
  end

  describe "without commands" do
    it "displays an error" do
      result = run_run_through(stdin_data: "file.txt\n")

      expect(result.stderr).to include("no commands specified")
      expect(result.exit_code).to eq(1)
    end
  end

  describe "without files" do
    it "displays an error" do
      result = run_run_through("-c", "echo", stdin_data: "")

      expect(result.stderr).to include("no files provided")
      expect(result.exit_code).to eq(1)
    end
  end

  describe "running commands" do
    it "runs a command with files from stdin" do
      with_temp_dir do |dir|
        output_file = File.join(dir, "output.txt")
        file1 = File.join(dir, "file1.txt")
        FileUtils.touch(file1)

        stdin_input = "#{file1}\n"
        result = run_run_through("-c", "echo >> #{output_file}", stdin_data: stdin_input)

        expect(result).to be_success
        output = File.read(output_file)
        expect(output).to include(file1)
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
        result = run_run_through("-n", "-c", "touch #{marker_file}", stdin_data: stdin_input)

        expect(result.stdout).to include("Would run:")
        expect(result).to be_success
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
        result = run_run_through("-V", "-c", "true", stdin_data: stdin_input)

        expect(result.stdout).to include("Running:")
        expect(result).to be_success
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
        result = run_run_through("-i", "-c", "echo >> #{output_file}", stdin_data: stdin_input)

        expect(result).to be_success
        output_lines = File.read(output_file).lines
        expect(output_lines.length).to eq(2)
      end
    end
  end
end
