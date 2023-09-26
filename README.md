# NixOS Everyday

## Overview

The NixOS Everyday provides a collection of useful modules for everyday use in NixOS configurations. These modules are designed to simplify common tasks, streamline system management, and enhance your NixOS experience.

Whether you're a seasoned NixOS user or just getting started, these modules aim to make your daily system administration tasks more convenient and efficient.

## Features

### 1. `nixosModules.logger`

Configure a `logger` systemd service to pipe all system logs in the system console (without requiring login).

## Getting Started

To get started with NixOS Everyday, follow these steps:

1. Add the flake to your NixOS configuration's `flake.nix`:

    ```nix
    {
      inputs = {
        everyday.url = "github:klarkc/nixos-everyday";
      };

      outputs = { self, everyday, ... }: {
        nixosConfigurations.my-system = nixos.lib.nixosSystem {
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

## Contributing

We welcome contributions from the NixOS community to improve and expand the NixOS Everyday. If you have ideas for new modules or improvements to existing ones, please open an issue or submit a pull request on our [GitHub repository](https://github.com/klarkc/nixos-everyday).

## License

This project is licensed under the Apache License - see the [LICENSE](LICENSE) file for details.

## Contact

If you have any questions, issues, or feedback, please feel free to reach out to us through the [GitHub repository](https://github.com/klarkc/nixos-everyday).
