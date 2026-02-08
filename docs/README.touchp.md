# touchp

Creates a file and all parent directories in its path. A combination of `mkdir -p` and `touch`.

## Options

| Option | Description |
|--------|-------------|
| `-v`, `--version` | Show version |
| `-h`, `--help` | Show help |

## Examples

```bash
# Create file and all directories in path
touchp foo/bar/baz/wibble

# Create multiple files
touchp src/lib/utils.rb src/lib/helpers.rb
```

## See Also

- [codep](README.codep.md) - Creates file with directories and opens in VS Code
- [codex](README.codex.md) - Creates executable file with directories and opens in VS Code
- `mkdir -p` - Create directories
- `touch` - Create files

## Last analyzed

2025-02-07 | 85e771b
