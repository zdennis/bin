# frozen_string_literal: true

RSpec.describe "alias-directory" do
  # Use a temporary HOME to isolate the .alias-directoryrc file
  around(:each) do |example|
    with_temp_dir do |dir|
      @temp_home = dir
      example.run
    end
  end

  def run_alias_directory(*args)
    run_tool("alias-directory", *args, env: { "HOME" => @temp_home })
  end

  def rc_file_path
    File.join(@temp_home, ".alias-directoryrc")
  end

  describe "--version" do
    it "displays the version number" do
      result = run_alias_directory("--version")

      expect(result.stdout).to match(/alias-directory \d+\.\d+\.\d+/)
      expect(result).to be_success
    end
  end

  describe "--help" do
    it "displays usage information" do
      result = run_alias_directory("--help")

      expect(result.stdout).to include("Usage:")
      expect(result.stdout).to include("Commands:")
      expect(result.stdout).to include("config")
      expect(result.stdout).to include("list")
      expect(result.stdout).to include("create")
      expect(result).to be_success
    end
  end

  describe "with no arguments" do
    it "displays usage and exits with error" do
      result = run_alias_directory

      expect(result.stdout).to include("Usage:")
      expect(result.exit_code).to eq(1)
    end
  end

  describe "with invalid command" do
    it "displays usage and exits with error" do
      result = run_alias_directory("invalid-command")

      expect(result.stdout).to include("Usage:")
      expect(result.exit_code).to eq(1)
    end
  end

  describe "config" do
    it "displays the RC file path" do
      result = run_alias_directory("config")

      expect(result.stdout).to include("RC file:")
      expect(result.stdout).to include(".alias-directoryrc")
      expect(result).to be_success
    end
  end

  describe "list" do
    context "when no aliases exist" do
      it "reports that no aliases are defined" do
        result = run_alias_directory("list")

        expect(result.stdout).to include("No aliases defined")
        expect(result).to be_success
      end
    end

    context "when aliases exist" do
      before do
        run_alias_directory("create", "proj1", "/path/to/proj1")
        run_alias_directory("create", "proj2", "/path/to/proj2")
      end

      it "lists all aliases alphabetically" do
        result = run_alias_directory("list")

        expect(result.stdout).to include("proj1 -> /path/to/proj1")
        expect(result.stdout).to include("proj2 -> /path/to/proj2")
        expect(result).to be_success
      end

      it "displays aliases in alphabetical order" do
        # Add an alias that comes first alphabetically
        run_alias_directory("create", "aaa", "/path/to/aaa")

        result = run_alias_directory("list")
        lines = result.stdout.lines.map(&:strip).reject(&:empty?)

        expect(lines.first).to start_with("aaa")
      end
    end
  end

  describe "create" do
    it "creates an alias with an explicit path" do
      result = run_alias_directory("create", "myproject", "/home/user/projects/myproject")

      expect(result.stdout).to include("Alias 'myproject' set to: cd /home/user/projects/myproject")
      expect(result).to be_success

      # Verify the alias was persisted
      list_result = run_alias_directory("list")
      expect(list_result.stdout).to include("myproject -> /home/user/projects/myproject")
    end

    it "creates an alias using current directory when path is omitted" do
      with_temp_dir do |project_dir|
        Dir.chdir(project_dir) do
          result = run_alias_directory("create", "current")

          expect(result.stdout).to include("Alias 'current' set to: cd #{project_dir}")
          expect(result).to be_success
        end
      end
    end

    it "updates an existing alias" do
      run_alias_directory("create", "myproject", "/old/path")
      result = run_alias_directory("create", "myproject", "/new/path")

      expect(result.stdout).to include("Alias 'myproject' set to: cd /new/path")
      expect(result).to be_success

      list_result = run_alias_directory("list")
      expect(list_result.stdout).to include("myproject -> /new/path")
      expect(list_result.stdout).not_to include("/old/path")
    end

    it "handles paths with spaces" do
      result = run_alias_directory("create", "spacey", "/path/with spaces/in it")

      expect(result).to be_success

      list_result = run_alias_directory("list")
      expect(list_result.stdout).to include("spacey -> /path/with spaces/in it")
    end

    context "with invalid alias names" do
      %w[& ; | < > ` $ ( ) { } ! # * ?].each do |char|
        it "rejects alias names containing '#{char}'" do
          result = run_alias_directory("create", "bad#{char}name", "/some/path")

          expect(result.stderr).to include("Invalid alias name")
          expect(result.exit_code).to eq(1)
        end
      end
    end

    context "with invalid paths" do
      %w[& ; | < > ` $ ( ) { } ! # * ?].each do |char|
        it "rejects paths containing '#{char}'" do
          result = run_alias_directory("create", "goodname", "/bad#{char}path")

          expect(result.stderr).to include("Invalid path")
          expect(result.exit_code).to eq(1)
        end
      end
    end

    it "displays usage when arguments are missing" do
      result = run_alias_directory("create")

      expect(result.stdout).to include("Usage:")
      expect(result.exit_code).to eq(1)
    end

    it "displays usage when too many arguments are provided" do
      result = run_alias_directory("create", "name", "path", "extra")

      expect(result.stdout).to include("Usage:")
      expect(result.exit_code).to eq(1)
    end
  end

  describe "RC file format" do
    it "writes aliases in shell-sourceable format" do
      run_alias_directory("create", "myproj", "/home/user/myproj")

      rc_content = File.read(rc_file_path)

      expect(rc_content).to include("alias myproj='cd /home/user/myproj'")
    end

    it "escapes spaces in paths with backslashes" do
      run_alias_directory("create", "spacey", "/path/with spaces")

      rc_content = File.read(rc_file_path)

      expect(rc_content).to include("alias spacey='cd /path/with\\ spaces'")
    end
  end
end
