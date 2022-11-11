# zombiezen's Nix image for GitHub Codespaces

This is a [Dev Container][] base image that includes the [Nix package manager][],
suitable for use in [GitHub Codespaces][].
It has a Debian base to support the VSCode server process
and handle standard Dev Container features.

[Dev Container]: https://containers.dev/
[GitHub Codespaces]: https://github.com/features/codespaces
[Nix package manager]: https://nixos.org/

## Usage

Add the following `.devcontainer.json` file to your project:

```json
{
  "image": "ghcr.io/zombiezen/codespaces-nix"
}
```

## License

[Unlicense](LICENSE)
