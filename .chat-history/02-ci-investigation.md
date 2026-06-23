# CI Investigation

## Goal

Provide a GitHub Actions workflow that runs for pull requests into `devel` and passes these ordered checks: install, lint, test, and build.

## Defects found

- The workflow was under `codebase/rdicidr-0.1.0/.github/workflows/`, so GitHub could not discover it.
- Pull requests targeted `main` instead of `devel`.
- `feature-*` did not match the required `feature/**` convention, and `bugfix/**` was absent.
- npm commands ran at repository root instead of `codebase/rdicidr-0.1.0`.
- The workflow selected Node 14 while `.nvmrc` and package engines required Node 15/npm 7; the lockfile used lockfile version 2.
- `package.json` referenced Prettier and `plugin:prettier/recommended`, but the lockfile and required ESLint plugins did not support that configuration.
- The API URL test expected `REACT_APP_API_URL`, but CI did not provide a deterministic value.
- Separate jobs relied on a mismatched `node_modules` cache; the build cache key differed from the install key.
- Lint, test, and build were parallel dependents rather than an explicit ordered sequence.

## Recommendations and approved fixes

- Move the workflow to repository-root `.github/workflows/ci.yaml`.
- Trigger PR validation into `devel` and support `feature/**` and `bugfix/**` branches.
- Set the application working directory explicitly.
- Use the Node version from `.nvmrc` and npm caching keyed by the nested lockfile.
- Run install, lint, test, and build as ordered steps in one job.
- Remove the unresolved Prettier dependency, script, and ESLint extension.
- Set `REACT_APP_API_URL=https://api.rdicidr.com` only for the test step.

The fixes were approved and delivered through PR #1 from `bugfix/ci-pipeline` into `devel`.

## Validation commands

Run from `codebase/rdicidr-0.1.0`:

```bash
npm ci
npm run lint
CI=true npm run test
npm run build
```

## GitHub Actions evidence

- Initial discovered workflow run: install failed; lint, test, and build were skipped.
- After the approved fixes, branch and PR checks completed successfully.
- The PR was merged only after passing validation.
- Exact private runner logs: not captured in this log.
