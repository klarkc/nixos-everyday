# NixOS Everyday

## Overview

The NixOS Everyday provides a collection of useful modules for everyday use in NixOS configurations. These modules are designed to simplify common tasks, streamline system management, and enhance your NixOS experience.

Whether you're a seasoned NixOS user or just getting started, these modules aim to make your daily system administration tasks more convenient and efficient.


## Getting Started

To get started with NixOS Everyday, follow these steps:

1. Add the flake to your NixOS configuration's `flake.nix`:

    ```nix
    {
      inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        everyday.url = "github:klarkc/nixos-everyday";
      };

      outputs = { self, nixpkgs, everyday, ... }: {
        nixosConfigurations.my-system = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            # Add the specific modules you want to use from the flake.
            everyday.nixosModules.logger
            # ...
          ];
        };
      };
    }
    ```

2. Customize the modules as needed by referring to the individual module documentation provided above.

3. Apply the configuration changes using the `nixos-rebuild` command:

    ```bash
    nixos-rebuild switch --flake .#my-system
    ```
## Features

### 1. `nixosModules.logger`

Configure a `logger` systemd service to pipe all system logs in the system console (without requiring login).

### 2. `nixosModules.host-keys`

> :warning: The private key will be shared with the nix guest. Use at your own risk.

Use a local ssh key as ssh host key in a virtual machine.

```nix
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
      everyday.nixosModules.host-keys
      {
        # scan id_ed25519 and id_ed25519.pub
        host-keys.source = "/home/klarkc/.ssh";
      }
    ];
  };
```

The host source keys are mounted in `/var/keys` and if:

- `services.sshd.enable` is `true`, symlinks are created from `/var/keys/id_ed25519*` to `/etc/ssh_host_*`;
- `age` exists, `age.identityPaths` is set to `/var/keys/id_ed25519`.

#### Usage with agenix

[`agenix`](https://github.com/ryantm/agenix) is a small and convenient Nix library for securely managing and deploying secrets using common public-private SSH key pairs.

```nix
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
      agenix.nixosModules.default
      everyday.nixosModules.host-keys
      ({ config, ...}: {
        # scan for id_ed25519 and id_ed25519.pub
        host-keys.source = "/home/klarkc/.ssh";
        # assuming example.age is encrypted by klarkc
        age.secrets.example.file = ./secrets/example.age;
        # decripted file
        example = config.age.secrets.example.path;
      })
    ];
  };
```

## Contributing

We welcome contributions from the NixOS community to improve and expand the NixOS Everyday. If you have ideas for new modules or improvements to existing ones, please open an issue or submit a pull request on our [GitHub repository](https://github.com/klarkc/nixos-everyday).

## License

This project is licensed under the Apache License - see the [LICENSE](LICENSE) file for details.

## Contact

If you have any questions, issues, or feedback, please feel free to reach out to us through the [GitHub repository](https://github.com/klarkc/nixos-everyday).
