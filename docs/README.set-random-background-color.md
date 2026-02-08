# set-random-background-color

Sets iTerm2 background to a random dark color from a palette of 256 options.

## Options

| Option | Description |
|--------|-------------|
| `-v`, `--version` | Show version |

## Examples

```bash
# Set a random dark background
set-random-background-color

# Use in shell startup for unique terminal colors
# Add to ~/.zshrc or ~/.bashrc:
set-random-background-color
```

## How it works

- Uses iTerm2's proprietary escape sequence to set background color
- Picks from 256 dark color combinations:
  - 8 red levels (0-77)
  - 8 green levels (0-77)
  - 4 blue levels (0-75)
- Colors are kept dark by limiting RGB values to max 77

## See Also

- [iTerm2 Proprietary Escape Codes](https://iterm2.com/documentation-escape-codes.html)

## Last analyzed

2025-02-07 | ccd7008
