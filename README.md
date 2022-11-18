# zombiezen's Nix image for GitHub Codespaces

This is a [Dev Container][] base image that includes the [Nix package manager][],
suitable for use in [GitHub Codespaces][].
It has a Debian base to support the VSCode server process
and handle standard Dev Container features.

[Dev Container]: https://containers.dev/
[GitHub Codespaces]: https://github.com/features/codespaces
[Nix package manager]: https://nixos.org/

## Features

- No-fuss container configuration
- [Multi-user][] Nix installation
- [direnv][] preinstalled
- Automatically runs [Lorri][] daemon
- VSCode dependences preinstalled

[direnv]: https://direnv.net/
[Lorri]: https://github.com/nix-community/lorri
[Multi-user]: https://nixos.org/manual/nix/stable/installation/multi-user.html

## Usage

Add the following `.devcontainer.json` file to your project:

```json
{
  "image": "ghcr.io/zombiezen/codespaces-nix"
}
```

Then follow the [Codespaces instructions][] to start up a Codespace.

[Codespaces instructions]: https://docs.github.com/en/codespaces/developing-in-codespaces/creating-a-codespace-for-a-repository

## Alternatives

- The Development Containers [nix Feature][].
  Works with most distribution base images,
  but adds time to container builds compared to a dedicated image.
- [nix-devcontainer][] shares many of the same goals as this project.
  However, nix-devcontainer tries to be an all-in-one solution in many ways.
  This project aims to be a small minimal image,
  and rely on the user to use Nix to manage their environment as they see fit.

[nix-devcontainer]: https://github.com/xtruder/nix-devcontainer
[nix Feature]: https://github.com/devcontainers/features/tree/3fc9604ddadc34ec44651ce981cebc7bd77095e5/src/nix

## License

[Unlicense](LICENSE)
