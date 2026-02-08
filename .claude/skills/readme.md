---
name: readme
description: Create and update README documentation for tools
arguments: command [tool-name]
---

# README Skill

Create and update README documentation for tools in this repository.

## Usage

```
/readme create [tool-name]
/readme update [tool-name]
```

If `tool-name` is omitted, operates on all **committed** tools in `bin/`.

**Important:** Only tools that are committed to git will be documented. Uncommitted tools are ignored.

## Commands

### create

Creates missing README documentation:

1. **Top-level README.md** - If it doesn't exist, create it with:
   - Introduction: "Personal bin scripts for zdennis"
   - Tools section with a table (Tool, README, Description)
   - "How to install (Homebrew)" section

2. **docs/README.\<tool\>.md** - For each tool in `bin/` that's missing a README:
   - Create using the template below
   - Analyze the tool's source code to populate sections

### update

Updates existing README documentation:

1. Read the "Last analyzed" section from `docs/README.<tool>.md`
2. Check git history for changes to the tool since that date/SHA
3. If changes exist, re-analyze the tool and update the README
4. Update the "Last analyzed" section with current date/time and SHA

## Top-level README.md Structure

```markdown
# bin

Personal bin scripts for zdennis.

## Tools

| Tool | README | Description |
|------|--------|-------------|
| tool-name | [README](docs/README.tool-name.md) | 1-5 sentence description |

## How to install (Homebrew)

Some tools are available via Homebrew. See [zdennis/homebrew-bin](https://github.com/zdennis/homebrew-bin) for available tools and installation instructions.

Not all tools may be available. If there's a tool you'd like to install via Homebrew, [open a GitHub issue](https://github.com/zdennis/homebrew-bin/issues/new) and let me know.
```

## Tool README Template (docs/README.\<tool\>.md)

```markdown
# <tool>

<1-5 sentence description of what the tool does>

## Quick Start

<Quick start guide if there are setup steps required, otherwise omit this section>

## Commands

<If the tool has subcommands, list and describe them here>
<If no subcommands, rename this section to "Options" and list CLI options>

## Examples

<Practical usage examples with explanations>

## How it works

<Optional section - include if there are:>
<- Configuration files the tool reads/writes>
<- Directories it creates or uses>
<- Environment variables it respects>
<- Other implementation details developers should know>

## See Also

<Links to related tools in this repository>
<Links to external tools, libraries, or documentation>

## Last analyzed

<Date> | <Git SHA of the tool at time of analysis>
```

## Instructions for Claude

### When running `create`:

1. **Check/create top-level README.md:**
   - If README.md doesn't exist, create it
   - If it exists, ensure the Tools table is up-to-date with all tools in `bin/`

2. **Find tools needing READMEs:**
   - List only **committed** tools using `git ls-files bin/`
   - Check which are missing `docs/README.<tool>.md`
   - If a specific tool was requested, only process that tool (must be committed)

3. **For each tool needing a README:**
   - Read the tool's source code
   - Run `<tool> --help` if available
   - Create `docs/README.<tool>.md` using the template
   - Populate sections based on analysis
   - Set "Last analyzed" to current date and the tool's current git SHA

4. **Update the top-level README.md Tools table** with any new tools

### When running `update`:

1. **For each tool README to update:**
   - Read `docs/README.<tool>.md`
   - Parse the "Last analyzed" section for date and SHA
   - Run `git log <sha>..HEAD -- bin/<tool>` to check for changes
   - If no changes, skip this tool

2. **If changes exist:**
   - Read the tool's current source code
   - Run `<tool> --help` if available
   - Update the README sections as needed
   - Update "Last analyzed" with current date and new SHA

3. **Update the top-level README.md** if descriptions changed

### Important notes:

- **Only document committed tools** - Use `git ls-files bin/` to get the list of tools to document
- Always use `docs/` directory for tool READMEs (create if needed)
- Tool names in filenames should match exactly (e.g., `README.run-through.md`)
- Keep descriptions concise (1-5 sentences)
- Omit optional sections if not applicable
- For "See Also", link to related tools in this repo first, then external resources
