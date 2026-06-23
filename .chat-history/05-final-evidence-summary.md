# Final Evidence Summary

## Requirement checklist

- [x] CI runs on pull requests into `devel`.
- [x] CI failed-to-passing progression was observed.
- [x] Install, lint, test, and build pass.
- [x] Kubernetes uses a StatefulSet in `production`.
- [x] StatefulSet has 3 ready replicas.
- [x] Service listens on port 8080 and targets container port 80.
- [x] Service endpoints are populated.
- [x] Startup, readiness, and liveness probes are healthy.
- [x] `http://fsl-challenge.me` responds successfully.
- [x] Azure CD deploys an immutable Docker image publicly.
- [x] Azure root and `/health` endpoints respond with HTTP 200 over HTTPS.
- [x] No secrets or static Azure/registry credentials were committed by the implemented workflows.
- [ ] Final ZIP contains `.github` and `.chat-history` — pending packaging verification.

## Delivery evidence

- PR #1: CI workflow and deterministic checks.
- PR #2: Docker Desktop Kubernetes manifests.
- PR #3: OIDC-based Azure container deployment.
- All three PRs were merged into `devel` after their applicable checks passed.

## Final cleanup notes

- Exclude `node_modules`, build output, image archives, temporary worktrees, editor files, and local artifacts from packaging.
- Run a secret-pattern scan before packaging and manually review any matches.
- Confirm the ZIP preserves hidden directories, especially `.github` and `.chat-history`.
- Temporary federated credential files and raw private logs must not be included.
- Any detail not represented here is `not captured in this log`.
