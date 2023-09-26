{
  outputs = { self, ... }@inputs:
    let
      nixosModules =
        let
          logger = {
            config.systemd.services.logger = {
              description = "Monitor systemd journal in real-time";
              wantedBy = [ "multi-user.target" ];
              script = "journalctl -b -f";
              serviceConfig = {
                StandardOutput = "tty";
                StandardError = "tty";
                TTYPath = "/dev/console";
                Restart = "always";
              };
            };
          };
        in
        { inherit logger; };
    in
    { inherit nixosModules; };

  # --- Flake Local Nix Configuration ----------------------------
  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    # This sets the flake to use nix cache.
    # Nix should ask for permission before using it,
    # but remove it here if you do not want it to.
    extra-substituters = [
      "https://klarkc.cachix.org"
    ];
    extra-trusted-public-keys = [
      "klarkc.cachix.org-1:R+z+m4Cq0hMgfZ7AQ42WRpGuHJumLLx3k0XhwpNFq9U="
    ];
  };
}
