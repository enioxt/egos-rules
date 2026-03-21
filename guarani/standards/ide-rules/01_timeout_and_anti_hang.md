# Timeout and Anti-Hang Rule

## Command Safety

- Always prefer cheap checks before heavy commands.
- Every shell/network command must use an explicit timeout when possible.
- Default timeout policy:
  - FAST: `timeout 10s`
  - MEDIUM: `timeout 20s`
  - HEAVY: `timeout 60s`
- For background MCP/process smoke tests, start the process, wait briefly, capture first lines of log, then terminate it.
- Never batch many risky network checks into a single command if running them one-by-one gives clearer failure isolation.
- If a command fails to return captured output, retry with a smaller command and stricter timeout.

## Network Calls

- Use `curl --max-time 10` for simple reachability checks.
- Use Python/urllib timeouts <= 10s for API smoke tests.
- Prefer HEAD/cheap metadata endpoints before full requests.

## Execution Style

- One verification command at a time for external services.
- Summarize partial evidence frequently instead of waiting for one giant verification step.
- If two consecutive commands fail due to capture/timeout issues, switch to smaller probes and report that explicitly.
