# code+x

Creates an executable file (with parent directories) and opens it in VS Code. Combines `touchp`, `chmod +x`, and `code`.

Renamed from `codex` to `code+x` to avoid conflict with OpenAI's codex CLI.

## Examples

```bash
# Create and edit a new executable script
code+x bin/my-script

# Create multiple executable files
code+x bin/tool1 bin/tool2
```

## Migration

If you were using the old name:

```bash
# Old usage
codex script.sh

# New usage
code+x script.sh
```

## See Also

- [touchp](README.touchp.md) - Creates file with parent directories
- [codep](README.codep.md) - Creates file and opens in VS Code (without making executable)
- [code](https://code.visualstudio.com/docs/editor/command-line) - VS Code command line interface
