# grab-column

Extracts specific columns from stdin by column number. A simpler alternative to `awk '{print $N}'`.

## Options

| Option | Description |
|--------|-------------|
| `-h`, `--help` | Show help |

## Examples

```bash
# Grab the filename (column 9) from ls -l
ls -l | grab-column 9

# Grab modified file names from git status
git status | grep modified: | grab-column 3

# Grab multiple columns
ls -l | grab-column 1 9
```

## How it works

- Column numbers are 1-based (not 0-based)
- Columns are whitespace-separated
- Multiple column numbers can be specified

## See Also

- [grab-pattern](README.grab-pattern.md) - Extract text by regex pattern
- `awk` - More powerful text processing
- `cut` - Extract columns by delimiter

## Last analyzed

2025-02-07 | 236cfcf
