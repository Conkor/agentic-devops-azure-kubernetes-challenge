# Kubernetes Investigation

## Goal

Run the application locally on Docker Desktop Kubernetes with production-style workload configuration and access through `http://fsl-challenge.me`.

## Requirements

- Namespace: `production`
- Workload: StatefulSet
- Replicas: at least 3
- StatefulSet and Service in `production`
- Service port: 8080
- Stable startup, readiness, and liveness probes
- Local access: `http://fsl-challenge.me`

## Defects found

- A Deployment was used instead of a StatefulSet.
- Replica count was 2.
- Resources had no `production` namespace.
- `agentpool: userpool` was a cloud-only node selector that blocked Docker Desktop.
- The image referenced a private ACR deployment rather than a local image.
- The manifest declared container/probe port 3000, while nginx listens on port 80.
- The Service selector `rdicidr-web` did not match pod label `rdicidr`, so no endpoints were created.
- The Service exposed port 80 instead of 8080.
- Existing probes were aggressive and lacked a startup probe.
- No host-based local exposure existed.
- Docker Desktop Kubernetes used a separate containerd image store, so the locally built image required import into the cluster node.

## Approved manifest fixes

- Add `k8s/namespace.yaml` for `production`.
- Replace `k8s/deployment.yaml` with a three-replica `k8s/statefulset.yaml`.
- Use `rdicidr:local` with `imagePullPolicy: Never` and remove cloud scheduling constraints.
- Declare named container port `http` on port 80.
- Add startup, readiness, and liveness HTTP probes on `/health`.
- Update `k8s/service.yaml` to select `app: rdicidr` and route port 8080 to named target port `http`.
- Add `k8s/ingress.yaml` for host `fsl-challenge.me` using ingress-nginx.

The fixes were approved, validated on Docker Desktop, and delivered through PR #2 from `bugfix/k8s-manifest` into `devel`.

## Validation commands

Run the image build from `codebase/rdicidr-0.1.0` so `.` is the Docker build context:

```powershell
docker build -t rdicidr:local .
kubectl apply -f k8s/
kubectl get all -n production
kubectl rollout status statefulset/rdicidr -n production
kubectl get svc -n production
kubectl get endpoints -n production
Invoke-WebRequest http://fsl-challenge.me -UseBasicParsing
Invoke-WebRequest http://fsl-challenge.me/health -UseBasicParsing
```

For this Docker Desktop runtime, the image was also imported into the node's `k8s.io` containerd namespace before pod recreation. The final validation showed 3/3 ready replicas, three populated endpoints, zero restarts, and HTTP 200 for both local URLs.
