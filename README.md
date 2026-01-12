# Flux D2 Applications Repository

This repository contains application deployments managed via Flux.

## Architecture

- **Per-application OCI artifacts**: Each app publishes to `ghcr.io/bendwyer/d2-apps/<app>`
- **Environment-based overlays**: Base manifests + cluster-specific configs (`omni/`, `home/`)
- **Secrets via 1Password**: OnePasswordItem CRDs automatically sync secrets from 1Password vaults
- **Variable substitution**: Flux postBuild injection for configs and secrets

## Repository Structure

```
flux-d2-apps/
├── components/                         # Application deployments
│   └── {app}/
│       ├── base/                      # Shared manifests
│       │   ├── deployment.yaml       # Deployments, Services, etc.
│       │   └── kustomization.yaml
│       ├── omni/                      # Omni cluster overlay
│       │   ├── configmap.yaml        # Non-sensitive values
│       │   ├── onepassworditem-*.yaml # Secrets from 1Password
│       │   ├── certificate.yaml      # TLS certificates
│       │   └── kustomization.yaml
│       └── home/                      # Home cluster overlay
│           └── ...
└── .github/workflows/
    └── publish-oci.yml                # Per-app OCI publishing
```

## Secrets Management

All application secrets use **1Password Operator** via `OnePasswordItem` CRDs:

```yaml
apiVersion: onepassword.com/v1
kind: OnePasswordItem
metadata:
  name: app-secrets
  namespace: my-app
spec:
  itemPath: "vaults/<vault-id>/items/<item-id>"
```

The operator automatically creates a Kubernetes Secret that can be referenced in Deployments or via Flux postBuild substitution.

## CI/CD Workflow

### On Pull Request
- Validates OCI artifact builds
- Does not publish artifacts

### On Merge to `main`
1. Builds OCI artifact for each app
2. Only publishes if different from `:latest` (diff detection)
3. Signs with cosign
4. Pushes to `ghcr.io/bendwyer/d2-apps/<app>:latest`

## Adding Applications

1. **Create app directory** in `components/` with base and cluster overlays
2. **Add to workflow matrix** in `.github/workflows/publish-oci.yml`
3. **Add to fleet** in `flux-d2-fleet/tenants/apps.yaml`:
   ```yaml
   inputs:
     - component: "app-name"
       tag: "latest"
       environment: "omni"
   ```

## References

- [ControlPlane D2 Applications Reference](https://github.com/controlplaneio-fluxcd/d2-apps)
- [1Password Operator](https://github.com/1Password/onepassword-operator)
- [Flux Kustomization postBuild](https://fluxcd.io/flux/components/kustomize/kustomizations/#post-build-variable-substitution)
