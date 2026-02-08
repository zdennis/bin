# retry-command

Retries a command until it succeeds, with configurable delay and retry limits. Operates in two modes: retry mode (stop after success) or supervisor mode (keep restarting forever). Useful for waiting on services, flaky commands, or keeping long-running processes alive.

## Options

| Option | Description |
|--------|-------------|
| `-d, --delay SECONDS` | Delay between retries (default: 10) |
| `-m, --max-retries N` | Maximum retry attempts, 0 for unlimited (default: 0) |
| `-s, --stop-on-success` | Exit after command succeeds (don't rerun) |
| `-q, --quiet` | Suppress retry status messages |
| `-h, --help` | Show help message |
| `-v, --version` | Show version number |

## Examples

### Wait for a service to be ready

Retry until a health check succeeds, then exit:

```bash
retry-command -s -- curl -f http://localhost:8080/health
```

### Retry with limits

Retry up to 5 times with a 30-second delay between attempts:

```bash
retry-command -m 5 -d 30 -s -- ./deploy.sh
```

Output on failure:
```
Attempt 1/5 failed (exit code: 1). Retrying in 30 seconds...
Attempt 2/5 failed (exit code: 1). Retrying in 30 seconds...
...
Command failed after 5 attempt(s). Giving up.
```

### Supervisor mode (keep running forever)

Keep a server running, automatically restarting if it exits:

```bash
retry-command -- ./my-server
```

Output:
```
Command exited successfully. Restarting in 10 seconds...
```

### Wait for database to accept connections

```bash
retry-command -s -d 5 -- pg_isready -h localhost
```

### Quiet mode for scripts

Suppress status messages, useful in scripts where you only care about the exit code:

```bash
if retry-command -q -s -m 10 -d 2 -- pg_isready -h localhost; then
    echo "Database is ready"
else
    echo "Database failed to start"
fi
```

### Use -- to separate options from command

When your command has its own flags, use `--` to separate retry-command options:

```bash
retry-command -s -m 3 -- curl -f -s --max-time 5 http://api.example.com
```

## How it works

- **Exit codes**: Returns 0 on success, 1 if max retries exceeded, 130 on Ctrl-C
- **Signal handling**: Catches SIGINT and SIGTERM for graceful shutdown
- **Retry mode** (`-s`): Exits immediately when command succeeds
- **Supervisor mode** (default): Restarts the command after both success and failure, useful for long-running processes that should always be running
- **Elapsed time tracking**: In unlimited retry mode, shows total wait time

## See Also

- [queue-commands](README.queue-commands.md) - Run multiple commands from a file with failure handling
- [run-through](README.run-through.md) - Pipe files through shell commands

## Last analyzed

2025-02-07 | 910ab33839e12a2165932d70455f2afd2a385f99
