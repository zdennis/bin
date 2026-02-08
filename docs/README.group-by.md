# group-by

Groups stdin lines by regex pattern matches. Useful for aggregating log entries or grouping similar lines together.

## Options

| Option | Description |
|--------|-------------|
| `-p`, `--pattern=PATTERN` | Regex pattern to match lines |
| `-m`, `--multiline` | Enable multiline matching |
| `-t`, `--terminus-pattern=PATTERN` | Pattern to end a multiline match |
| `--summary` | Show summary of grouped results |
| `-h`, `--help` | Show help |

## Examples

```bash
# Group log entries by error type
cat error.log | group-by -p 'ERROR: \w+'

# Group with summary counts
cat access.log | group-by -p '/api/\w+' --summary

# Multiline grouping (group stack traces)
cat app.log | group-by -m -p 'Exception' -t '^\s*$'
```

## See Also

- [grab-pattern](README.grab-pattern.md) - Extract matching patterns
- `sort | uniq -c` - Simple grouping by exact match

## Last analyzed

2025-02-07 | 5165a62
