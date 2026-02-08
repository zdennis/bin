# brew-upgrade-with-logs

Runs `brew update && brew upgrade` while logging output to timestamped files.

## Examples

```bash
# Upgrade Homebrew packages with logging
brew-upgrade-with-logs
```

## How it works

- Creates log directory at `~/.brew-upgrades/` if it doesn't exist
- Generates timestamped log file (e.g., `2025-02-07_14h30m00s.log`)
- Runs `brew update && brew upgrade` with output teed to the log file
- Useful for tracking what was upgraded and when

## See Also

- [Homebrew](https://brew.sh/) - The missing package manager for macOS
- `brew upgrade --dry-run` - Preview what would be upgraded

## Last analyzed

2025-02-07 | 14e069d
