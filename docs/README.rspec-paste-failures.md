# rspec-paste-failures

Converts RSpec failure output into a runnable rspec command with file:line references.

## Options

| Option | Description |
|--------|-------------|
| `-h`, `--help` | Show help |

## Quick Start

Requires the `term-ansicolor` gem:

```bash
gem install term-ansicolor
```

## Examples

```bash
# Copy RSpec failure output to clipboard, then:
pbpaste | rspec-paste-failures

# The output can be run directly:
rspec spec/models/user_spec.rb:42 spec/models/account_spec.rb:87
```

## How it works

- Parses RSpec's "Failed examples:" output section
- Extracts file paths and line numbers
- Formats them as a runnable rspec command
- Uses term-ansicolor for colored output

## See Also

- [rspec-json](README.rspec-json.md) - Parse JSON format output
- RSpec's built-in `--only-failures` option

## Last analyzed

2025-02-07 | d8e1687
