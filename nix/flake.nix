# CLI tools installed through Home Manager. Packages only: chezmoi keeps
# owning every dotfile, so no `programs.*` module that writes config is used.
#
# Applied by .chezmoiscripts/run_onchange_after_05_home_manager.sh.tmpl:
#   nix run ./nix#home-manager -- switch --impure --flake ./nix#<system>
# --impure lets home.nix read $USER/$HOME, so one configuration per system
# covers every user (the author, CI's `tester`, ...).
{
  description = "chezmoi-managed CLI tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # No `follows`: llm-agents keeps its own nixpkgs pin so its binary cache
    # (configured system-wide by run_once_before_00_init.sh) hits regardless
    # of our nixpkgs revision.
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      llm-agents,
      ...
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      # Pinned home-manager CLI, so bootstrap does not depend on a channel.
      packages = forAllSystems (system: {
        home-manager = home-manager.packages.${system}.default;
      });

      homeConfigurations = forAllSystems (
        system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs.agents = llm-agents.packages.${system};
          modules = [ ./home.nix ];
        }
      );
    };
}
