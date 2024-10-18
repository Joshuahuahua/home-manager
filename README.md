# Nix Home Manager Configuration

This is my [Nix](https://nixos.org/) [Home Manager](https://github.com/nix-community/home-manager) configuration.

## Nix Installation

Install [Nix](https://nixos.org/download.html)
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```
> Requires a shell reload

Install [Home Manager](https://github.com/nix-community/home-manager)
```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

## Alacritty Configuration
The [Alacritty](https://github.com/alacritty/alacritty) terminal emulator is used for my terminal. [(*download*)](https://github.com/alacritty/alacritty/releases/download/v0.13.2/Alacritty-v0.13.2-installer.msi)

```toml
[shell]
program = "wsl.exe ~ -d Ubuntu-24.04"

[font]
normal = { family = "Liga SFMono Nerd Font" }
```

## Additional Configuration

Run the following commands to default to zsh and install
```bash
echo -e "if test -t 1; then\n  exec zsh\nfi\n$(cat ~/.bashrc)" > ~/.bashrc
```

Configure Git credentials
```bash
git config credential.helper store
git config user.email "joshua.j.hollander@gmail.com"
git config user.name "Joshua Hollander"
```

Download [Liga Nerd Font](https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized/archive/refs/heads/main.zip)
```bash
git clone https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized.git
```
