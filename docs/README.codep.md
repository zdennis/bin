# codep

Creates a file (with parent directories) and opens it in VS Code. Combines `touchp` and `code`.

## Options

| Option | Description |
|--------|-------------|
| `-v`, `--version` | Show version |

## Examples

```bash
# Create and edit a new file
codep src/lib/new_feature.rb

# Create multiple files and open them
codep app/models/user.rb app/models/account.rb
```

## See Also

- [touchp](README.touchp.md) - Creates file with parent directories
- [codex](README.codex.md) - Creates executable file and opens in VS Code
- [code](https://code.visualstudio.com/docs/editor/command-line) - VS Code command line interface

## Last analyzed

2025-02-07 | 295b72b
