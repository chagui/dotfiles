{ pkgs, agents, ... }:
let
  # nixpkgs runs gt inside a buildFHSEnv (bubblewrap) sandbox on Linux, which
  # Ubuntu 24.04+ AppArmor denies (unprivileged_userns profile), failing both
  # the build and every gt call. Keep nixpkgs' version and hash but return the
  # unwrapped upstream binary: it must stay unpatched (vercel/pkg payload) and
  # loads through the host's dynamic loader, which non-NixOS hosts provide.
  # Trade-off: no shell completions, which nixpkgs only generates in the FHS
  # wrapper.
  graphite-cli =
    if pkgs.stdenv.hostPlatform.isLinux then
      pkgs.graphite-cli.override {
        buildFHSEnv = args: builtins.head (args.targetPkgs pkgs);
      }
    else
      pkgs.graphite-cli;
in
{
  home = {
    # Requires --impure; see flake.nix.
    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";
    stateVersion = "26.05";

    packages = [
      graphite-cli
      pkgs.neovim
      pkgs.topgrade
      agents.claude-code
      agents.codex
    ];
  };

  # Puts the home-manager CLI on PATH for topgrade's custom command; writes no
  # config files.
  programs.home-manager.enable = true;

  targets.genericLinux = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
    # CLI tools only: skip the GPU driver shim, which needs a one-time sudo
    # setup that only GUI apps (e.g. alacritty) would benefit from.
    gpu.enable = false;
  };
}
