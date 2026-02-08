# frozen_string_literal: true

RSpec.describe "touchp" do
  def run_touchp(*args)
    run_tool("touchp", *args)
  end

  describe "--version" do
    it "displays the version number" do
      result = run_touchp("--version")

      expect(result.stdout).to match(/touchp \d+\.\d+\.\d+/)
      expect(result).to be_success
    end
  end

  describe "--help" do
    it "displays usage information" do
      result = run_touchp("--help")

      expect(result.stdout).to include("touches a file")
      expect(result.stdout).to include("mkdir -p")
      expect(result.stdout).to include("Example")
      expect(result).to be_success
    end
  end

  describe "creating files" do
    it "creates a file in an existing directory" do
      with_temp_dir do |dir|
        file_path = File.join(dir, "newfile.txt")
        result = run_touchp(file_path)

        expect(result).to be_success
        expect(File.exist?(file_path)).to be true
      end
    end

    it "creates parent directories that don't exist" do
      with_temp_dir do |dir|
        file_path = File.join(dir, "nested", "deep", "path", "file.txt")
        result = run_touchp(file_path)

        expect(result).to be_success
        expect(File.exist?(file_path)).to be true
        expect(File.directory?(File.join(dir, "nested", "deep", "path"))).to be true
      end
    end

    it "creates multiple files" do
      with_temp_dir do |dir|
        file1 = File.join(dir, "file1.txt")
        file2 = File.join(dir, "subdir", "file2.txt")
        result = run_touchp(file1, file2)

        expect(result).to be_success
        expect(File.exist?(file1)).to be true
        expect(File.exist?(file2)).to be true
      end
    end

    it "handles files with spaces in the path" do
      with_temp_dir do |dir|
        file_path = File.join(dir, "path with spaces", "my file.txt")
        result = run_touchp(file_path)

        expect(result).to be_success
        expect(File.exist?(file_path)).to be true
      end
    end

    it "updates timestamp of existing file" do
      with_temp_dir do |dir|
        file_path = File.join(dir, "existing.txt")
        File.write(file_path, "content")
        old_mtime = File.mtime(file_path)

        sleep 0.1  # Ensure time difference
        result = run_touchp(file_path)

        expect(result).to be_success
        expect(File.mtime(file_path)).to be > old_mtime
      end
    end

    it "does not modify content of existing file" do
      with_temp_dir do |dir|
        file_path = File.join(dir, "existing.txt")
        File.write(file_path, "original content")

        result = run_touchp(file_path)

        expect(result).to be_success
        expect(File.read(file_path)).to eq("original content")
      end
    end
  end

  describe "with no arguments" do
    it "exits successfully (no-op)" do
      result = run_touchp

      expect(result).to be_success
    end
  end
end
