# alias-directory

Creates and manages shell directory aliases stored in `~/.alias-directoryrc`. These aliases allow quick `cd` navigation to frequently used directories.

## Commands

| Command | Description |
|---------|-------------|
| `config` | Show configuration information (RC file location) |
| `list` | List all directory aliases alphabetically |
| `create <name> [path]` | Add or update a directory alias. Defaults to current directory if path omitted |

## Options

| Option | Description |
|--------|-------------|
| `-h`, `--help` | Show usage information |
| `-v`, `--version` | Show version |

## Examples

```bash
# Show where aliases are stored
alias-directory config

# List all aliases
alias-directory list

# Create an alias for current directory
alias-directory create myproject

# Create an alias for a specific path
alias-directory create code ~/Code
```

## How it works

- Aliases are stored in `~/.alias-directoryrc`
- The RC file contains shell alias commands in the format: `alias name='cd /path/to/dir'`
- Paths with spaces are automatically escaped with backslashes
- Invalid shell characters in names or paths are rejected
- Source the RC file in your shell profile to enable the aliases:
  ```bash
  # Add to ~/.bashrc or ~/.zshrc
  source ~/.alias-directoryrc
  ```

## See Also

- [ad](README.ad.md) - Shorter alias for this command
- [autojump](https://github.com/wting/autojump) - Similar tool with automatic frecency-based jumping
- [zoxide](https://github.com/ajeetdsouza/zoxide) - Modern alternative to autojump

## Last analyzed

2025-02-07 | 6074699
