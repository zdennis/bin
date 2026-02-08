# frozen_string_literal: true

RSpec.describe "codep" do
  # Ensure bin/ is in PATH so touchp is available
  def run_codep(*args)
    env = { "PATH" => "#{bin_path}:#{ENV['PATH']}" }
    run_tool("codep", *args, env: env)
  end

  describe "--version" do
    it "displays the version number" do
      result = run_codep("--version")

      expect(result.stdout).to match(/codep \d+\.\d+\.\d+/)
      expect(result).to be_success
    end
  end

  describe "--help" do
    it "displays usage information" do
      result = run_codep("--help")

      expect(result.stdout).to include("Usage:")
      expect(result.stdout).to include("--no-edit")
      expect(result.stdout).to include("Unlike code+x")
      expect(result).to be_success
    end
  end

  describe "with no arguments" do
    it "displays an error" do
      result = run_codep

      expect(result.stderr).to include("No files specified")
      expect(result.exit_code).to eq(1)
    end
  end

  describe "creating files" do
    it "creates a file (not executable by default)" do
      with_temp_dir do |dir|
        file_path = File.join(dir, "test-file.txt")
        result = run_codep("--no-edit", file_path)

        expect(result).to be_success
        expect(File.exist?(file_path)).to be true
        # Unlike code+x, codep does NOT make files executable
        expect(File.executable?(file_path)).to be false
      end
    end

    it "creates parent directories" do
      with_temp_dir do |dir|
        file_path = File.join(dir, "nested", "deep", "file.txt")
        result = run_codep("--no-edit", file_path)

        expect(result).to be_success
        expect(File.exist?(file_path)).to be true
        expect(File.directory?(File.join(dir, "nested", "deep"))).to be true
      end
    end

    it "creates multiple files" do
      with_temp_dir do |dir|
        file1 = File.join(dir, "file1.txt")
        file2 = File.join(dir, "file2.txt")
        result = run_codep("--no-edit", file1, file2)

        expect(result).to be_success
        expect(File.exist?(file1)).to be true
        expect(File.exist?(file2)).to be true
      end
    end

    it "handles files with spaces in the name" do
      with_temp_dir do |dir|
        file_path = File.join(dir, "my document.txt")
        result = run_codep("--no-edit", file_path)

        expect(result).to be_success
        expect(File.exist?(file_path)).to be true
      end
    end
  end

  describe "--no-edit" do
    it "does not open VS Code" do
      with_temp_dir do |dir|
        file_path = File.join(dir, "test-file")
        result = run_codep("--no-edit", file_path)

        # If VS Code tried to open, this would likely fail or hang
        expect(result).to be_success
        expect(File.exist?(file_path)).to be true
      end
    end
  end
end
