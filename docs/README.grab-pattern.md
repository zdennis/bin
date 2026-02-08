# grab-pattern

Extracts text matching regex patterns from each line of stdin. Each pattern's first match is extracted and output in aligned columns.

## Options

| Option | Description |
|--------|-------------|
| `-v`, `--version` | Show version |
| `-h`, `--help` | Show help |

## Examples

```bash
# Extract first number from each line
echo "Order 123 costs \$45" | grab-pattern '\d+'
# Output: 123

# Extract multiple patterns (outputs aligned columns)
echo "192.168.1.1 GET /api 200" | grab-pattern '\d+\.\d+\.\d+\.\d+' '\d+$'
# Output: 192.168.1.1    200

# Extract email addresses from a file
cat contacts.txt | grab-pattern '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'

# Use capture groups to extract specific parts
echo "name=John age=30" | grab-pattern 'name=(\w+)' 'age=(\d+)'
# Output: John    30

# Extract from log files
cat access.log | grab-pattern '^\S+' 'HTTP/\d\.\d" (\d+)'
# Extracts: IP address and HTTP status code
```

## How it works

- Patterns are Ruby regular expressions
- For each line, the first match of each pattern is extracted
- If a pattern has capture groups, the first captured group is used
- Multiple patterns produce tab-separated, column-aligned output
- Lines with no match output empty strings (preserving row alignment)
- Invalid regex patterns produce a clear error message

## See Also

- [grab-column](README.grab-column.md) - Extract by column number instead of pattern
- [strscan](README.strscan.md) - Extract all matches (not just first)
- `grep -oE` - Extract matching parts with extended regex

## Last analyzed

2025-02-07 | a28c5ee
