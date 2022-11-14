# zombiezen's Nix image for GitHub Codespaces

This is a [Dev Container][] base image that includes the [Nix package manager][],
suitable for use in [GitHub Codespaces][].
It has a Debian base to support the VSCode server process
and handle standard Dev Container features.

This image runs the [Lorri][] daemon and installs [direnv][].

[Dev Container]: https://containers.dev/
[direnv]: https://direnv.net/
[GitHub Codespaces]: https://github.com/features/codespaces
[Lorri]: https://github.com/nix-community/lorri
[Nix package manager]: https://nixos.org/

## Usage

Add the following `.devcontainer.json` file to your project:

```json
{
  "image": "ghcr.io/zombiezen/codespaces-nix"
}
```

Then follow the [Codespaces instructions][] to start up a Codespace.

[Codespaces instructions]: https://docs.github.com/en/codespaces/developing-in-codespaces/creating-a-codespace-for-a-repository

## License

[Unlicense](LICENSE)
