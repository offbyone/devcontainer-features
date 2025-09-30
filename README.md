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
```
