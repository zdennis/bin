# run-through

Pipes files through one or more shell commands. Useful for running linters, formatters, or other tools on a set of files.

## Options

| Option | Description |
|--------|-------------|
| `-b`, `--bundle-exec-commands=CMD` | Run command with `bundle exec`. Can be specified multiple times |
| `-c`, `--command=CMD` | Command to execute on files. Can be specified multiple times |
| `-i`, `--individual` | Run each command once per file instead of once with all files |
| `-n`, `--dry-run` | Print commands that would run without executing them |
| `-V`, `--verbose` | Print each command before running it |
| `-v`, `--version` | Show version |
| `-h`, `--help` | Show help |

## Examples

```bash
# Run rubocop on all changed Ruby files
git changed-files | grep ".rb" | run-through -c rubocop

# Run multiple commands
find spec -name "*.rb" | run-through -c rubocop -c reek

# Use bundle exec
find app -name "*.rb" | run-through -b rubocop -b reek

# Run each file individually
echo -e "file1.rb\nfile2.rb" | run-through -i -c "echo Processing"

# Dry run to see what would happen
git changed-files | run-through -n -c rubocop

# Verbose mode to see commands as they run
git changed-files | run-through -V -c rubocop -c reek
```

## How it works

- Files can be passed via stdin (one per line) or as arguments
- Commands are executed in order with all files as arguments
- With `-i`, each command runs once per file instead of once with all files
- Filenames with spaces are properly shell-escaped
- Exit status is non-zero if any command fails
- Failed commands are reported to stderr

## See Also

- [rt](README.rt.md) - Shorter alias for this command
- [xargs](https://man7.org/linux/man-pages/man1/xargs.1.html) - Similar Unix utility

## Last analyzed

2025-02-07 | 6262cbc
