# bin

Personal bin scripts for zdennis.

## Tools

| Tool | README | Description |
|------|--------|-------------|
| alias-directory | [README](docs/README.alias-directory.md) | Creates and manages shell directory aliases stored in `~/.alias-directoryrc` for quick `cd` navigation. |
| ascii-banner | [README](docs/README.ascii-banner.md) | Creates ASCII art banners from text with color, rainbow effects, auto-scaling, margins, and watch mode for terminal resize. |
| brew-upgrade-with-logs | [README](docs/README.brew-upgrade-with-logs.md) | Runs `brew update && brew upgrade` while logging output to timestamped files in `~/.brew-upgrades/`. |
| codep | [README](docs/README.codep.md) | Creates a file (with parent directories) and opens it in VS Code. Combines `touchp` and `code`. |
| codex | [README](docs/README.codex.md) | Creates an executable file (with parent directories) and opens it in VS Code. Combines `touchp`, `chmod +x`, and `code`. |
| grab-column | [README](docs/README.grab-column.md) | Extracts specific columns from stdin by column number. Like `awk '{print $N}'` but simpler. |
| grab-pattern | [README](docs/README.grab-pattern.md) | Extracts text matching regex patterns from stdin. Supports multiple patterns and capture groups. |
| group-by | [README](docs/README.group-by.md) | Groups stdin lines by regex pattern matches, with optional multiline support and summary output. |
| reverse | [README](docs/README.reverse.md) | Reverses the order of lines from stdin. |
| rspec-paste-failures | [README](docs/README.rspec-paste-failures.md) | Converts RSpec failure output into a runnable rspec command with file:line references. |
| rt | [README](docs/README.rt.md) | Alias for `run-through`. Pipes files through one or more shell commands. |
| run-through | [README](docs/README.run-through.md) | Pipes files through one or more shell commands. Supports bundle exec, dry-run mode, and per-file execution. |
| set-random-background-color | [README](docs/README.set-random-background-color.md) | Sets iTerm2 background to a random dark color from a palette of 256 options. |
| touchp | [README](docs/README.touchp.md) | Creates a file and all parent directories in its path. Combines `mkdir -p` and `touch`. |

## How to install (Homebrew)

Some tools are available via Homebrew. See [zdennis/homebrew-bin](https://github.com/zdennis/homebrew-bin) for available tools and installation instructions.

Not all tools may be available. If there's a tool you'd like to install via Homebrew, [open a GitHub issue](https://github.com/zdennis/homebrew-bin/issues/new) and let me know.
