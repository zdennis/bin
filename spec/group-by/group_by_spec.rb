# frozen_string_literal: true

RSpec.describe "group-by" do
  def run_group_by(*args, stdin_data: nil)
    run_tool("group-by", *args, stdin_data: stdin_data)
  end

  describe "--version" do
    it "displays the version number" do
      result = run_group_by("--version")

      expect(result.stdout).to match(/group-by \d+\.\d+\.\d+/)
      expect(result).to be_success
    end
  end

  describe "--help" do
    it "displays usage information" do
      result = run_group_by("--help")

      expect(result.stdout).to include("--pattern")
      expect(result.stdout).to include("--multiline")
      expect(result.stdout).to include("EXAMPLE")
      expect(result).to be_success
    end
  end

  describe "without a pattern" do
    it "fails with an error" do
      result = run_group_by(stdin_data: "some input\n")

      expect(result.stderr).to include("Must provide a pattern")
      expect(result.exit_code).not_to eq(0)
    end
  end

  describe "grouping single lines" do
    let(:input) do
      <<~INPUT
        foo: apple
        bar: banana
        foo: cherry
        baz: date
        bar: elderberry
        foo: fig
      INPUT
    end

    it "groups lines by pattern matches" do
      result = run_group_by("-p", '^\w+:', stdin_data: input)

      expect(result.stdout).to include("foo: has 3 matches")
      expect(result.stdout).to include("bar: has 2 matches")
      expect(result.stdout).to include("baz: has 1 matches")
      expect(result.stdout).to include("foo: apple")
      expect(result.stdout).to include("foo: cherry")
      expect(result.stdout).to include("foo: fig")
      expect(result).to be_success
    end

    it "outputs groups sorted by match count" do
      result = run_group_by("-p", '^\w+:', stdin_data: input)

      # Groups should appear in order of match count (ascending)
      baz_pos = result.stdout.index("baz:")
      bar_pos = result.stdout.index("bar:")
      foo_pos = result.stdout.index("foo:")

      expect(baz_pos).to be < bar_pos
      expect(bar_pos).to be < foo_pos
      expect(result).to be_success
    end
  end

  describe "--summary" do
    let(:input) do
      <<~INPUT
        error: something broke
        warn: might be an issue
        error: another problem
      INPUT
    end

    it "displays only summary information" do
      result = run_group_by("-p", '^\w+:', "--summary", stdin_data: input)

      expect(result.stdout).to include("In summary there were 2 groups found")
      expect(result.stdout).to include("warn: has 1 match")
      expect(result.stdout).to include("error: has 2 matches")
      # Summary should not include the actual lines
      expect(result.stdout).not_to include("something broke")
      expect(result).to be_success
    end
  end

  describe "--multiline" do
    let(:input) do
      <<~INPUT
        foo: first
          detail 1
          detail 2
        bar: second
          detail 3
        foo: third
      INPUT
    end

    it "groups lines with their following content until next match" do
      result = run_group_by("-p", '^\w+:', "-m", stdin_data: input)

      # foo group should contain details that follow it
      expect(result.stdout).to include("foo: has 2 matches")
      expect(result.stdout).to include("detail 1")
      expect(result.stdout).to include("detail 2")
      expect(result).to be_success
    end
  end

  describe "--terminus-pattern" do
    let(:input) do
      <<~INPUT
        START section A
        content for A
        more A content
        END section A
        START section B
        content for B
        END section B
        START section A again
        extra A
        END section A
      INPUT
    end

    it "uses custom terminus pattern to end multiline matches" do
      result = run_group_by("-p", "START", "-m", "-t", "END", stdin_data: input)

      # Should group by START but terminate at END
      expect(result.stdout).to include("START has")
      expect(result.stdout).to include("content for A")
      expect(result).to be_success
    end
  end

  describe "pattern matching" do
    it "uses the matched portion as the group key" do
      input = "INFO: message1\nWARN: message2\nINFO: message3\n"
      result = run_group_by("-p", '^\w+:', stdin_data: input)

      expect(result.stdout).to include("INFO: has 2 matches")
      expect(result.stdout).to include("WARN: has 1 matches")
      expect(result).to be_success
    end
  end
end
