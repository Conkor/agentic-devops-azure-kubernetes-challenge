# Initial Agent Context

## Challenge context

The agent was assigned as the primary engineer for an Agentic DevOps challenge covering a React application, GitHub Actions, local Docker Desktop Kubernetes, and Azure App Service container delivery.

## Working rules

- Never hardcode or expose secrets, tokens, credential JSON, publish profiles, or registry passwords.
- Use `feature/**` or `bugfix/**` branches.
- Deliver all repository changes through pull requests into `devel`.
- Inspect and diagnose before changing files; apply phase-specific fixes only after approval.
- Validate each phase before moving to the next phase.
- Keep CI changes limited to CI/package/test/build configuration unless deterministic fixtures require otherwise.

## Delivery phases

1. CI pipeline
2. Local Kubernetes deployment
3. Azure CD deployment
4. Evidence capture and packaging

## Agentic workflow

For each phase, the agent inspected the existing state, reported defects and evidence, proposed a minimal fix, waited for approval, implemented on an isolated branch, validated the result, and promoted the change through a pull request.
