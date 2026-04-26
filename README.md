# dotfiles

NixOS configuration with home-manager for a GNOME desktop on `x86_64-linux`.

## Structure

```
.
├── flake.nix                        # Flake inputs and nixosConfigurations output
├── hosts/
│   └── computer/
│       ├── default.nix              # Host entry point
│       └── hardware.nix             # Generated hardware config
└── modules/
    ├── nixos/                       # System-level modules
    │   ├── audio.nix                # PipeWire
    │   ├── boot.nix                 # systemd-boot
    │   ├── flatpak.nix
    │   ├── fonts.nix                # JetBrains Mono + Nerd Font
    │   ├── gnome.nix                # GNOME + GDM
    │   ├── locale.nix
    │   ├── networking.nix
    │   ├── nix.nix                  # Nix settings, GC
    │   ├── nvidia.nix               # Proprietary NVIDIA driver
    │   └── users.nix
    └── home-manager/                # User-level modules
        ├── apps/                    # Equibop, Cider, BlackBox
        ├── browsers/                # LibreWolf + NUR add-ons
        ├── development/             # Git, VS Code
        ├── gnome/                   # dconf settings, extensions
        └── shell.nix                # Nushell, Starship, direnv, Atuin
```

## Inputs

| Input | Purpose |
|---|---|
| `nixpkgs` | `nixos-unstable` |
| `home-manager` | User environment management |
| `claude-code-nix` | Claude Code overlay |
| `NUR` | Firefox add-ons (LibreWolf) |

## Usage

```bash
sudo nixos-rebuild switch --flake .#computer
```

## Linting & formatting

```bash
nix run nixpkgs#statix -- check .   # lint
nixpkgs-fmt .                        # format
```
