# queue-commands

Reads a file of shell commands and executes them sequentially, pausing when any command fails to allow you to fix the issue before continuing. Useful for running batches of commands where you want to monitor progress and handle failures interactively.

## Options

| Option | Description |
|--------|-------------|
| `-f, --file=FILE` | File to read commands from (required) |
| `-w, --wait` | Pause for confirmation before running each command |
| `-c, --continue` | Continue on error without pausing |
| `-v, --verbose` | Print additional information about command execution |
| `-h, --help` | Show help message |
| `--version` | Show version number |

## Examples

### Basic usage

Create a file with commands to run:

```bash
# commands.txt
echo "Step 1: Compiling..."
make build
echo "Step 2: Running tests..."
make test
echo "Step 3: Deploying..."
make deploy
```

Run the commands:

```bash
queue-commands -f commands.txt
```

### Interactive mode with confirmations

Use `-w` to pause before each command for manual confirmation:

```bash
queue-commands -f commands.txt -w
```

Output:
```
Command 1/3:
  echo "Step 1: Compiling..."
Hit Enter to run or Ctrl-C to quit:
```

### Verbose output with progress tracking

```bash
queue-commands -f commands.txt --verbose
```

Output:
```
Loaded 3 command(s) from commands.txt

[1/3] Running: echo "Step 1: Compiling..."
Step 1: Compiling...
done

[2/3] Running: make build
...
```

### Continue on error (batch mode)

Use `-c` to run all commands without pausing on failures:

```bash
queue-commands -f commands.txt --continue --verbose
```

This is useful for CI/CD pipelines or when you want to see all failures at once.

## How it works

- **Command file format**: One command per line. Lines starting with `#` are treated as comments. Empty lines are ignored.
- **Exit codes**: Returns 0 if all commands succeed, 1 if any command fails.
- **Failure handling**: By default, pauses after each failed command and prompts you to fix the issue before continuing. Use `-c` to skip pauses.
- **Interrupt handling**: Ctrl-C gracefully exits with code 130.

## See Also

- [run-through](README.run-through.md) - Pipes files through shell commands
- [retry-command](../bin/retry-command) - Retries a single command until it succeeds

## Last analyzed

2025-02-07 | 53c483f8bd13b3b4feec29bd2fc5035689aff100
