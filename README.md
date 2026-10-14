# foggykitchen-hello-world

This repository contains a simple **static NGINX-based demo application** used by FoggyKitchen OCI DevOps and Azure DevOps examples and patterns.

It is intentionally small and predictable. Its main purpose is to serve as:

- a Docker image source for OCI DevOps and Azure DevOps build pipelines
- a container workload for Azure DevOps build-and-deploy examples using Azure Container Apps
- a straightforward container workload for OKE deployment examples
- a lightweight demo application for public FoggyKitchen patterns

Support expectations are documented in [SUPPORT.md](SUPPORT.md).

---

## Purpose

The goal of this repository is to provide a **clean application source** for build and deployment DevOps patterns.

This repository focuses on:

- container image build
- local Docker smoke testing
- OCI DevOps build pipeline compatibility
- Azure DevOps build and deployment pipeline compatibility

It intentionally does **not** contain:

- Helm charts
- Kubernetes manifests
- OCI-specific infrastructure code
- Azure-specific infrastructure code

Those concerns belong in companion repositories such as:

- [helm-foggykitchen-hello-world](https://github.com/foggykitchen/helm-foggykitchen-hello-world)
- [terraform-oci-fk-devops](https://github.com/foggykitchen/terraform-oci-fk-devops)
- [terraform-oci-fk-devops-pipeline](https://github.com/foggykitchen/terraform-oci-fk-devops-pipeline)
- [terraform-az-fk-devops-pipeline](https://github.com/foggykitchen/terraform-az-fk-devops-pipeline)

---

## Repository Structure

```bash
foggykitchen-hello-world/
├── config/
├── src/
├── Dockerfile
├── build.sh
├── run.sh
├── build_spec.yaml
├── azure-pipelines.yml
├── azure-pipelines-cicd.yml
└── README.md
```

---

## Local Docker Usage

### Build the image

```bash
./build.sh
```

### Run the container

```bash
./run.sh
```

### Smoke test

```bash
curl -s http://localhost
```

---

## OCI DevOps Usage

This repository is designed to work with OCI DevOps **build-only** flows.

The included [build_spec.yaml](build_spec.yaml) builds a container image and publishes the standard OCI DevOps Docker output artifact:

- `APPLICATION_DOCKER_IMAGE`

It does not package or publish Helm charts. That concern belongs in:

- `helm-foggykitchen-hello-world`

---

## Build Spec Notes

The OCI DevOps build spec:

- derives a short `BUILDRUN_HASH` from `OCI_BUILD_RUN_ID`
- builds the Docker image from the repository root
- emits a Docker output artifact for downstream DevOps stages

This keeps the repository aligned with the new public:

- `oci/devops/build-only`

pattern in `foggykitchen-landing-zone-orchestrator`.

---

## Azure DevOps Usage

This repository is designed to work with Azure DevOps **build-only** and **build-and-deploy** flows.

The included [azure-pipelines.yml](azure-pipelines.yml) builds and smoke-tests a container image and publishes an image archive as a Pipeline Artifact:

- `APPLICATION_DOCKER_IMAGE`

This provides the Azure build-only counterpart to the OCI build-only flow.

The included [azure-pipelines-cicd.yml](azure-pipelines-cicd.yml) builds and smoke-tests the image, pushes it to Azure Container Registry (ACR), deploys the exact image digest to Azure Container Apps, and verifies the application over HTTPS. It publishes digest and source metadata as:

- `IMAGE_METADATA`

This flow was verified end-to-end in the companion repository's example:

- [terraform-az-fk-devops-pipeline: 02_container_build_and_deploy](https://github.com/foggykitchen/terraform-az-fk-devops-pipeline/tree/main/examples/02_container_build_and_deploy)

That example registers `azure-pipelines-cicd.yml` from this repository's `master` branch; Terraform infrastructure and pipeline permissions belong in the companion repository.

---

## Azure Pipeline Notes

The Azure DevOps YAML files:

- use `trigger: none` and `pr: none` for manually queued reference runs; the CI/CD example avoids unexpected billable deployments
- build on `ubuntu-24.04`, tag images with `Build.BuildId`, and compare the local HTTP response with `src/index.html`
- publish a compressed image archive, source metadata and checksum in the build-only flow

The CI/CD YAML additionally:

- requires the `fk-configuration` variable group for registry, Resource Group, application, environment and HTTPS URL values
- uses the `fk-azure-oidc` ARM service connection for OIDC-authenticated ACR push and Container Apps deployment
- passes the tested image digest from Build to Deploy and verifies both the deployed image reference and HTTPS response content

---

## License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.

See [LICENSE](LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
