# Dev Container Features 

This is a collection (very small!) of the devcontainer features I looked for and didn't find in the wild.

### `prek`

This installs [`prek`](https://github.com/j178/prek), which is "a reimagined version of pre-commit, built in Rust". 

```jsonc
{
    "image": "ubuntu",
    "features": {
        "ghcr.io/offbyone/devcontainer-features/prek:1": {}
    }
}
```

```bash
$ prek install
...
```

### `zmx`

Installs [zmx](https://zmx.sh) — session persistence for terminal processes.

zmx provides persistent terminal sessions without the complexity of window managers like tmux. It lets you attach, detach, and re-attach to terminal sessions while preserving state and scrollback.

#### Usage

Add the feature to your `devcontainer.json`:

```jsonc
{
    "features": {
        "ghcr.io/offbyone/devcontainer-features/zmx:1": {}
    }
}
```

#### Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `0.6.0` | The version of zmx to install |

#### Example with options

```jsonc
{
    "features": {
        "ghcr.io/offbyone/devcontainer-features/zmx:1": {
            "version": "0.6.0"
        }
    }
}
```

#### Quick start

Once installed in your dev container:

```bash
# Create/attach to a session named "dev"
zmx attach dev

# Detach with Ctrl+\ or close the terminal window

# Re-attach later
zmx attach dev

# List active sessions
zmx list

# Run a command in a session without attaching
zmx run dev ls -la
```

## Distributing Features

### Versioning

Features are individually versioned by the `version` attribute in a Feature's `devcontainer-feature.json`.  Features are versioned according to the semver specification. More details can be found in [the dev container Feature specification](https://containers.dev/implementors/features/#versioning).

### Publishing

This repo contains a **GitHub Action** [workflow](.github/workflows/release.yaml) that will publish each Feature to GHCR. 

```
ghcr.io/offbyone/devcontainer-features/prek:1
```

The provided GitHub Action will also publish a third "metadata" package with just the namespace, eg: `ghcr.io/devcontainers/feature-starter`.  This contains information useful for tools aiding in Feature discovery.

'`devcontainers/feature-starter`' is known as the feature collection namespace.

#### Using private Features in Codespaces

For any Features hosted in GHCR that are kept private, the `GITHUB_TOKEN` access token in your environment will need to have `package:read` and `contents:read` for the associated repository.

Many implementing tools use a broadly scoped access token and will work automatically.  GitHub Codespaces uses repo-scoped tokens, and therefore you'll need to add the permissions in `devcontainer.json`

An example `devcontainer.json` can be found below.

```jsonc
{
    "image": "ubuntu",
    "features": {
     "ghcr.io/offbyone/devcontainer-features/prek:1": {}
    },
    "customizations": {
        "codespaces": {
            "repositories": {
                "my-org/private-features": {
                    "permissions": {
                        "packages": "read",
                        "contents": "read"
                    }
                }
            }
        }
    }
}

## Repository Structure

```
.
├── src/
│   └── zmx/
│       ├── devcontainer-feature.json   # Feature metadata and options
│       └── install.sh                  # Installation script
├── test/
│   └── zmx/
│       ├── test.sh                     # Default option tests
│       ├── scenarios.json              # Test scenario definitions
│       └── install_specific_version.sh # Version-specific tests
├── .github/
│   ├── workflows/
│   │   ├── test.yaml                   # CI tests on push/PR
│   │   ├── validate.yaml              # Feature JSON validation
│   │   ├── release.yaml               # Publish to GHCR
│   │   └── zizmor.yaml                # Actions security linting
│   └── dependabot.yml                 # Automated dependency updates
├── .devcontainer/
│   └── devcontainer.json              # Dog-fooding: use the feature for development
├── LICENSE
└── README.md
```

## Development

### Running tests locally

```bash
npm install -g @devcontainers/cli

# Run all tests for the zmx feature
devcontainer features test -f zmx .

# Run against a specific base image
devcontainer features test --skip-scenarios -f zmx -i ubuntu:latest .
```

### Publishing

Trigger the **Release** workflow manually from the Actions tab to publish features to GHCR (GitHub Container Registry) and generate updated documentation.

## Security

- All GitHub Actions are pinned to full commit SHAs
- [zizmor](https://github.com/zizmorcore/zizmor) lints workflows for security issues
- [Dependabot](https://docs.github.com/en/code-security/dependabot) keeps action versions up to date
- Feature install script uses `set -euo pipefail`, validates inputs, and cleans up temp files
- Downloads use HTTPS; upstream does not currently publish checksums

## License

MIT — see [LICENSE](LICENSE).
