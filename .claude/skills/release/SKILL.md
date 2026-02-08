---
name: release
description: Release a tool by creating and pushing a version tag
argument-hint: <tool-name>
---

# Release Tool

Release a tool by creating and pushing a version tag.

## Usage

```
/release <tool-name>
```

## Instructions

When the user invokes this skill with a tool name:

1. **Verify the tool exists** in the `bin/` directory
2. **Get the current version** by running `bin/<tool-name> --version` and parsing the version number
   - If `--version` is not supported, follow the "Missing Version Support" section below
3. **Find the last tag** for this tool by searching for tags matching `<tool-name>-v*`
4. **Analyze changes since last tag**:
   - Run `git diff <last-tag>..HEAD -- bin/<tool-name>` to see what changed
   - If no previous tag exists, this is the initial release
5. **Suggest version bump** based on changes:
   - **Patch** (x.y.Z): Internal changes only - refactoring, bug fixes, documentation, code cleanup
   - **Minor** (x.Y.0): New features added - new flags, new functionality, new options
   - **Major** (X.0.0): Breaking changes - removed features, changed default behavior, renamed flags, modified output format
6. **Show analysis to user**:
   - Display the current version
   - Summarize the changes since last tag
   - Show your recommended bump type with reasoning
   - Let the user confirm or choose a different version
7. **Update the version** in the tool's source code to the chosen version
8. **Commit the version change** with message: `<tool-name>: bump version to <version>`
9. **Create the tag** in the format `<tool-name>-v<version>` (e.g., `ascii-banner-v1.0.0`)
10. **Check if tag exists** - if the tag already exists, inform the user and stop
11. **Push the commit and tag** to origin

## Example

```
/release ascii-banner
```

This will:
- Run `bin/ascii-banner --version` to get "ascii-banner 1.0.0"
- Find the last tag `ascii-banner-v1.0.0`
- Run `git diff ascii-banner-v1.0.0..HEAD -- bin/ascii-banner` to see changes
- Analyze the diff and suggest a version bump:
  - "I see you added a new `--color` flag. This is a new feature, so I recommend a **minor** bump to 1.1.0"
  - Or: "I see you fixed a bug in the output formatting. This is an internal fix, so I recommend a **patch** bump to 1.0.1"
  - Or: "I see you changed the default output format. This breaks backward compatibility, so I recommend a **major** bump to 2.0.0"
- Let the user confirm or choose a different version
- Update the VERSION in the tool to the chosen version
- Commit the version change
- Create tag `ascii-banner-v<new-version>`
- Push the commit and tag to origin

## Change Analysis Guidelines

When analyzing the diff, look for these patterns:

### Patch (bug fixes, internal changes)
- Fixed typos or documentation
- Refactored code without changing behavior
- Fixed bugs that made the tool not work as documented
- Performance improvements
- Code cleanup

### Minor (new features, backward compatible)
- New command-line flags or options
- New output formats (when existing formats still work)
- New functionality that doesn't affect existing behavior
- Added help text or examples

### Major (breaking changes)
- Removed flags or options
- Changed default behavior
- Renamed flags (e.g., `--verbose` → `--debug`)
- Changed output format in a way that breaks scripts
- Changed exit codes
- Removed features

## Error Handling

- If the tool doesn't exist, report an error
- If the tag already exists, inform the user (this version has already been released)

## Missing Version Support

If the tool doesn't respond to `--version`:

1. Ask the user if they want to add version support to the tool
2. If yes, suggest starting at `1.0.0` for initial release (or `0.1.0` if the tool is experimental)
3. Add a VERSION constant and `--version` flag to the tool
4. Proceed with the release (no change analysis needed for initial release)

## No Previous Tag

If this is the first release (no previous tag exists for this tool):

1. Inform the user this is the initial release
2. Skip change analysis (nothing to compare against)
3. Use the current version in the tool as the release version
4. Proceed with tag creation and push
