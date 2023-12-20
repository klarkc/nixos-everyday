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
          host-keys = { config, lib, ... }:
            {
              options.host-keys = {
                dir = lib.mkOption {
                  type = lib.types.str;
                  default = "/var/keys";
                };
                source = lib.mkOption {
                  type = lib.types.str;
                };
              };
              config =
                let cfg = config.host-keys; in
                {
                  environment.etc = lib.mkIf config.services.sshd.enable
                    {
                      "ssh/ssh_host_ed25519_key" = {
                        mode = "0600";
                        source = "${cfg.dir}/id_ed25519";
                      };
                      "ssh/ssh_host_ed25519_key.pub" = {
                        mode = "0644";
                        source = "${cfg.dir}/id_ed25519.pub";
                      };
                    };
                  virtualisation.sharedDirectories.keys = {
                    source = cfg.source;
                    target = cfg.dir;
                  };
                  age.identityPaths =
                    lib.mkIf (builtins.hasAttr "age" config)
                      [ "${config.host-keys.dir}/id_ed25519" ];
                };
            };
        in
        { inherit logger host-keys; };
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
