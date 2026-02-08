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
3. **Show the current version** to the user and ask what version they want to release
   - Remind them of semver: Major (breaking changes), Minor (new features), Patch (bug fixes)
4. **Update the version** in the tool's source code to the user's chosen version
5. **Commit the version change** with message: `<tool-name>: bump version to <version>`
6. **Create the tag** in the format `<tool-name>-v<version>` (e.g., `ascii-banner-v1.0.0`)
7. **Check if tag exists** - if the tag already exists, inform the user and stop
8. **Push the commit and tag** to origin

## Example

```
/release ascii-banner
```

This will:
- Run `bin/ascii-banner --version` to get "ascii-banner 1.0.0"
- Tell the user: "Current version is 1.0.0. What version do you want to release?"
- Update the VERSION in the tool to the user's chosen version
- Commit the version change
- Create tag `ascii-banner-v<new-version>`
- Push the commit and tag to origin

## Error Handling

- If the tool doesn't exist, report an error
- If the tag already exists, inform the user (this version has already been released)

## Missing Version Support

If the tool doesn't respond to `--version`:

1. Ask the user if they want to add version support to the tool
2. If yes, ask what version to start at using **Major.minor.patch** format (e.g., `1.0.0`)
3. Remind the user to follow [Semantic Versioning (semver)](https://semver.org/):
   - **Major**: Breaking changes / incompatible API changes
   - **Minor**: New features, backwards compatible
   - **Patch**: Bug fixes, backwards compatible
4. Add a VERSION constant and `--version` flag to the tool
5. Proceed with the release
