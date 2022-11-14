# zombiezen's Nix image for GitHub Codespaces Release Notes

The format is based on [Keep a Changelog][],
and this project adheres to [Semantic Versioning][].

[Keep a Changelog]: https://keepachangelog.com/en/1.0.0/
[Semantic Versioning]: https://semver.org/spec/v2.0.0.html
[Unreleased]: https://github.com/zombiezen/codespaces-nix/compare/v0.2.0...HEAD

## [0.2.0][] - 2022-11-13

Version 0.2 fixes a number of issues I uncovered
after trying out the image in my own projects.
This release also adds [Lorri](https://github.com/nix-community/lorri)
and multi-user Nix support.

[0.2.0]: https://github.com/zombiezen/codespaces-nix/releases/tag/v0.2.0

### Added

- Provide system-wide Git and Nix in `PATH` at `/opt/sw/bin`.
  This is managed as the default Nix profile and linked in `/root/.nix-profile`.
- Automatically run [Lorri](https://github.com/nix-community/lorri) on startup
  ([#2](https://github.com/zombiezen/codespaces-nix/issues/2)).
- Install [procps](https://gitlab.com/procps-ng/procps) and
  [psmisc](https://gitlab.com/psmisc/psmisc) in the user profile.

### Changed

- Nix is now a multi-user installation.

### Fixed

- Provide Git that is accessible for Codespaces dotfiles clone
  ([#3](https://github.com/zombiezen/codespaces-nix/issues/3)).
- Set `LOCALE_ARCHIVE` environment variable.

## [0.1.1][] - 2022-11-12

Version 0.1.1 fixes problems with the image's metadata.

[0.1.1]: https://github.com/zombiezen/codespaces-nix/releases/tag/v0.1.1

### Fixed

- Fixed invalid JSON in `devcontainer.metadata` label
  ([#1](https://github.com/zombiezen/codespaces-nix/issues/1)).

## [0.1.0][] - 2022-11-12

Initial public release.

[0.1.0]: https://github.com/zombiezen/codespaces-nix/releases/tag/v0.1.0
