# Azure CD Investigation

## Goal

Build and deploy the application publicly as a Linux Docker container on Azure App Service.

## Prepared environment context

- Azure resources were prepared before this phase and treated as environment setup.
- Azure Container Registry and Linux App Service are used.
- GitHub `production` environment variables provide non-secret configuration names and identifiers.
- Azure authentication uses GitHub OIDC.
- No GitHub environment secrets are required.
- No `AZURE_CREDENTIALS`, client secret, publish profile, ACR username, or ACR password is used.
- The Web App uses managed identity to pull from ACR.
- Full Azure subscription, tenant, and client identifiers are intentionally omitted.

## Workflow design

- File: `.github/workflows/cd.yaml`
- Trigger: push to `devel` and `workflow_dispatch`.
- GitHub environment: `production`.
- Permissions: `contents: read` and `id-token: write`.
- Authentication: `azure/login@v3` using values from the `vars` context.
- Image build: Linux AMD64 from `codebase/rdicidr-0.1.0`.
- Image tag: immutable Git commit SHA.
- Registry delivery: Azure identity authenticates to ACR, then Docker pushes the image.
- App update: Azure CLI updates the Web App container image and enables managed-identity registry access.
- Validation: resolve the Web App default hostname and retry its HTTPS `/health` endpoint.

The workflow was delivered through PR #3 from `feature/azure-cd` into `devel`. The post-merge CD job completed successfully.

## Validation commands

```powershell
az webapp show --name <webapp-name> --resource-group <resource-group>
Invoke-WebRequest https://<hostname>/ -UseBasicParsing
Invoke-WebRequest https://<hostname>/health -UseBasicParsing
```

## Result

- Web App state: Running
- HTTPS-only access: enabled
- Root endpoint: HTTP 200
- Health endpoint: HTTP 200
- Deployed image used the merge commit SHA as its tag.
- Resource names were captured where useful; full Azure IDs and credential material were not captured.
