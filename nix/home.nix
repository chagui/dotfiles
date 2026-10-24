{ pkgs, agents, ... }:
{
  home = {
    # Requires --impure; see flake.nix.
    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";
    stateVersion = "26.05";

    packages = [
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
