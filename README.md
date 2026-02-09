# bin

[![Tests](https://github.com/zdennis/bin/actions/workflows/test.yml/badge.svg)](https://github.com/zdennis/bin/actions/workflows/test.yml)

Personal bin scripts for zdennis.

## Directory Structure

```
bin/          # Published tools (add this to your $PATH)
script/       # Project-internal scripts (binstubs, dev helpers)
spec/         # Tests for the tools
docs/         # Documentation for each tool
```

**Note:** `bin/` contains the tools meant for external use. `script/` contains development helpers like RSpec binstubs that should not be added to your `$PATH`.

## Tools

| Tool | README | Description |
|------|--------|-------------|
| alias-directory | [README](docs/README.alias-directory.md) | Creates and manages shell directory aliases stored in `~/.alias-directoryrc` for quick `cd` navigation. |
| ascii-banner | [README](docs/README.ascii-banner.md) | Creates ASCII art banners from text with color, rainbow effects, auto-scaling, margins, and watch mode for terminal resize. |
| brew-upgrade-with-logs | [README](docs/README.brew-upgrade-with-logs.md) | Runs `brew update && brew upgrade` while logging output to timestamped files in `~/.brew-upgrades/`. |
| codep | [README](docs/README.codep.md) | Creates a file (with parent directories) and opens it in VS Code. Combines `touchp` and `code`. |
| code+x | [README](docs/README.code+x.md) | Creates an executable file (with parent directories) and opens it in VS Code. Combines `touchp`, `chmod +x`, and `code`. |
| grab-column | [README](docs/README.grab-column.md) | Extracts specific columns from stdin by column number. Like `awk '{print $N}'` but simpler. |
| grab-pattern | [README](docs/README.grab-pattern.md) | Extracts text matching regex patterns from stdin. Supports multiple patterns and capture groups. |
| group-by | [README](docs/README.group-by.md) | Groups stdin lines by regex pattern matches, with optional multiline support and summary output. |
| queue-commands | [README](docs/README.queue-commands.md) | Runs commands from a file sequentially, pausing on failures for interactive fixing. |
| retry-command | [README](docs/README.retry-command.md) | Retries a command until it succeeds, with configurable delay and retry limits. |
| reverse | [README](docs/README.reverse.md) | Reverses the order of lines from stdin. |
| rspec-paste-failures | [README](docs/README.rspec-paste-failures.md) | Converts RSpec failure output into a runnable rspec command with file:line references. |
| rt | [README](docs/README.rt.md) | Alias for `run-through`. Pipes files through one or more shell commands. |
| run-through | [README](docs/README.run-through.md) | Pipes files through one or more shell commands. Supports bundle exec, dry-run mode, and per-file execution. |
| set-random-background-color | [README](docs/README.set-random-background-color.md) | Sets iTerm2 background to a random dark color from a palette of 256 options. |
| touchp | [README](docs/README.touchp.md) | Creates a file and all parent directories in its path. Combines `mkdir -p` and `touch`. |

## Installation

Clone the repository and add `bin/` to your PATH:

```bash
git clone https://github.com/zdennis/bin.git ~/bin-zdennis
export PATH="$HOME/bin-zdennis/bin:$PATH"
```

To make it permanent, add the export line to your shell profile (`~/.bashrc`, `~/.zshrc`, etc.).

### Homebrew

Some tools are also available via Homebrew. See [zdennis/homebrew-bin](https://github.com/zdennis/homebrew-bin) for available tools and installation instructions.

Not all tools may be available. If there's a tool you'd like to install via Homebrew, [open a GitHub issue](https://github.com/zdennis/homebrew-bin/issues/new) and let me know.

## Developing

### Setup

Install dependencies:

```bash
bundle install
```

### Running Tests

Tests are written in RSpec and located in `spec/`. Each tool has its own spec directory.

```bash
# Run all tests
script/rspec spec/

# Run tests for a specific tool
script/rspec spec/touchp/

# Run with documentation format
script/rspec spec/ --format documentation
```

### Test Philosophy

The tests are **black-box, end-to-end tests** that verify tool behavior by:

- Executing the actual tool as a subprocess
- Providing input (arguments, stdin, files)
- Verifying output (stdout, stderr, exit codes, file changes)

Tests do **not** load tool internals or test implementation details. This ensures:

1. **Confidence in real-world usage** — Tests exercise the same code paths users encounter
2. **Refactoring safety** — Internal changes don't break tests as long as behavior is preserved
3. **Documentation by example** — Tests serve as executable usage examples

### Test Isolation

Tests are designed to be idempotent and isolated:

- Temporary directories are created for file operations
- Configuration files use `--rc-file` or similar options to avoid touching real configs
- Tools that would open GUIs or run destructive commands have `--dry-run` or `--no-edit` options

### Adding Tests for a New Tool

1. Create a spec directory: `spec/<tool-name>/`
2. Add spec files: `spec/<tool-name>/<tool_name>_spec.rb`
3. Use the `run_tool` helper to execute the tool
4. Test `--version`, `--help`, core functionality, and edge cases
5. For tools with config files, add a CLI option for custom config paths
