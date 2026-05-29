# foggykitchen-hello-world

This repository contains a simple **static NGINX-based demo application** used by FoggyKitchen OCI DevOps examples and patterns.

It is intentionally small and predictable. Its main purpose is to serve as:

- a Docker image source for OCI DevOps build pipelines
- a straightforward container workload for OKE deployment examples
- a lightweight demo application for public FoggyKitchen patterns

---

## Purpose

The goal of this repository is to provide a **clean application source** for build-oriented DevOps patterns.

This repository focuses on:

- container image build
- local Docker smoke testing
- OCI DevOps build pipeline compatibility

It intentionally does **not** contain:

- Helm charts
- Kubernetes manifests
- OCI-specific infrastructure code

Those concerns belong in companion repositories such as:

- `helm-foggykitchen-hello-world`
- `terraform-oci-fk-devops`
- `terraform-oci-fk-devops-pipeline`

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

## License

This repository is provided for educational and demo purposes.

