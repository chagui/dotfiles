# Bootstrap test image — exercises the Linux branch of run_once_* scripts.
# The platform is chosen by `docker build --platform` (see e2e-linux.sh) so
# the same image covers both amd64 and arm64 tarball selection.
FROM ubuntu:26.04

ARG DEBIAN_FRONTEND=noninteractive

# Pipefail so curl|sh failures (next RUN block) propagate instead of
# silently exiting 0 from sh after curl errored.
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Minimal prerequisites:
#   - curl, ca-certificates: chezmoi installer + curl-piped bootstraps
#   - git: chezmoi externals + repo operations
#   - sudo: the run_once init script calls `sudo apt-get install`
#   - zsh: bootstrap targets zsh as login shell
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        sudo \
        zsh \
    && rm -rf /var/lib/apt/lists/*

# Install chezmoi (matches the user-facing onboarding path).
RUN curl -fsLS https://get.chezmoi.io | sh -s -- -b /usr/local/bin

# Non-root tester user with passwordless sudo. zsh login shell because
# dot_zshenv is what the bootstrap targets.
RUN useradd --create-home --shell /usr/bin/zsh tester \
    && echo "tester ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/tester

USER tester
WORKDIR /home/tester

# Copy chezmoi source tree into the tester's source path. The .chezmoiignore
# entry for `tests` keeps the harness itself from being deployed to ~/tests
# during apply, but it remains accessible at the source path for verify.sh.
COPY --chown=tester:tester . /home/tester/.local/share/chezmoi/

CMD ["bash"]
