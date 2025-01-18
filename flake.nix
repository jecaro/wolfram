{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      wolfram = pkgs.haskellPackages.callCabal2nix "wolfram" ./. { };
    in
    {
      packages.x86_64-linux.default = wolfram;

      devShells.x86_64-linux.default =
        pkgs.haskellPackages.shellFor {
          packages = p: [ wolfram ];
          withHoogle = true;
          buildInputs = [
            pkgs.haskellPackages.haskell-language-server
            pkgs.haskellPackages.ghcid
            pkgs.haskellPackages.cabal-install
          ];
        };
    };
}
