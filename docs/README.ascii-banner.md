# ascii-banner

Creates ASCII art banners from text with color and alignment options. Supports rainbow effects, auto-scaling to terminal size, margins, and watch mode for dynamic resizing.

## Options

| Option | Description |
|--------|-------------|
| `--color COLOR` | Set text color (red, green, blue, cyan, magenta, yellow, white) |
| `--rainbow` | Apply rainbow color effect |
| `--random` | Use a random color |
| `--center` | Center horizontally and vertically (respects margin) |
| `--watch` | Re-render on terminal resize |
| `--rotate` | Rotate through different sizes |
| `--margin [N]` | Add margin (default: 2). Formats: `N`, `rows,cols`, `top,bottom,left,right` |
| `-s SIZE` | Font size: `t` (tiny), `s` (small), `m` (medium), `l` (large), `xl` (extra large), `r` (rotate) |
| `--no-auto-scale` | Disable auto-scaling to terminal |
| `--list-colors` | List available colors |
| `--minimal` | Hide footer in interactive modes |
| `-v`, `--version` | Show version |
| `-h`, `--help` | Show help |

## Examples

```bash
# Simple banner
ascii-banner "Hello"

# Colored banner
ascii-banner --color red "Error"

# Rainbow effect
ascii-banner --rainbow "Success"

# Tinted rainbow (rainbow with base color)
ascii-banner --rainbow --color cyan "Tinted"

# Random color
ascii-banner --random "Surprise"

# Centered with watch mode (re-renders on resize)
ascii-banner --watch --center "Hello"

# Custom margins
ascii-banner --margin 4 "Hello"           # 4 row/column margin
ascii-banner --margin 4,3 "Hello"         # 4 row, 3 column margin
ascii-banner --margin 4,2,1,3 "Hello"     # top, bottom, left, right

# Different sizes
ascii-banner -s l "Hello"   # Large (2x)
ascii-banner -s xl "Hello"  # Extra large (3x)
ascii-banner -s t "Hello"   # Tiny

# Auto-scales to fit terminal by default
ascii-banner "This will fit"
```

## See Also

- [figlet](http://www.figlet.org/) - Classic ASCII art generator
- [toilet](http://caca.zoy.org/wiki/toilet) - Figlet-compatible with more effects
- [lolcat](https://github.com/busyloop/lolcat) - Rainbow coloring for terminal output

## Last analyzed

2025-02-07 | 35a8c84
