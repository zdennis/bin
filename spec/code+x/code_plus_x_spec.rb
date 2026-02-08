# frozen_string_literal: true

RSpec.describe "code+x" do
  # Ensure bin/ is in PATH so touchp is available
  def run_code_plus_x(*args)
    env = { "PATH" => "#{bin_path}:#{ENV['PATH']}" }
    run_tool("code+x", *args, env: env)
  end

  describe "--version" do
    it "displays the version number" do
      result = run_code_plus_x("--version")

      expect(result.stdout).to match(/code\+x \d+\.\d+\.\d+/)
      expect(result).to be_success
    end
  end

  describe "--help" do
    it "displays usage information" do
      result = run_code_plus_x("--help")

      expect(result.stdout).to include("Usage:")
      expect(result.stdout).to include("--no-edit")
      expect(result).to be_success
    end
  end

  describe "with no arguments" do
    it "displays an error" do
      result = run_code_plus_x

      expect(result.stderr).to include("No files specified")
      expect(result.exit_code).to eq(1)
    end
  end

  describe "creating files" do
    it "creates a file and makes it executable" do
      with_temp_dir do |dir|
        file_path = File.join(dir, "test-script")
        result = run_code_plus_x("--no-edit", file_path)

        expect(result).to be_success
        expect(File.exist?(file_path)).to be true
        expect(File.executable?(file_path)).to be true
      end
    end

    it "creates parent directories" do
      with_temp_dir do |dir|
        file_path = File.join(dir, "nested", "deep", "script")
        result = run_code_plus_x("--no-edit", file_path)

        expect(result).to be_success
        expect(File.exist?(file_path)).to be true
        expect(File.directory?(File.join(dir, "nested", "deep"))).to be true
      end
    end

    it "creates multiple files" do
      with_temp_dir do |dir|
        file1 = File.join(dir, "script1")
        file2 = File.join(dir, "script2")
        result = run_code_plus_x("--no-edit", file1, file2)

        expect(result).to be_success
        expect(File.exist?(file1)).to be true
        expect(File.exist?(file2)).to be true
        expect(File.executable?(file1)).to be true
        expect(File.executable?(file2)).to be true
      end
    end

    it "handles files with spaces in the name" do
      with_temp_dir do |dir|
        file_path = File.join(dir, "my script")
        result = run_code_plus_x("--no-edit", file_path)

        expect(result).to be_success
        expect(File.exist?(file_path)).to be true
        expect(File.executable?(file_path)).to be true
      end
    end
  end

  describe "--no-edit" do
    it "does not open VS Code" do
      with_temp_dir do |dir|
        file_path = File.join(dir, "test-script")
        result = run_code_plus_x("--no-edit", file_path)

        # If VS Code tried to open, this would likely fail or hang
        # Success here implies VS Code was not invoked
        expect(result).to be_success
        expect(File.exist?(file_path)).to be true
      end
    end
  end
end
