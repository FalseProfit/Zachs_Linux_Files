# Zach's Linux Preference Files

This repo is a lightweight portability bundle for new Kali Linux boxes, a main Kali VM, and a few convenience cases on macOS. Kali/Linux is the primary target. Most files are either shell/tmux preferences or small operator helpers. A few files are reference notes only.

## What is here

- [`.zshrc`](/Users/zjohnson/Repositories/Zachs_Linux_Files/.zshrc): shared shell configuration with guarded aliases and path defaults.
- [`zach.zsh-theme`](/Users/zjohnson/Repositories/Zachs_Linux_Files/zach.zsh-theme): Oh My Zsh theme used by `.zshrc`.
- [`.tmux.conf`](/Users/zjohnson/Repositories/Zachs_Linux_Files/.tmux.conf): tmux defaults with optional clipboard and VPN-status integrations.
- [`initial_setup.sh`](/Users/zjohnson/Repositories/Zachs_Linux_Files/initial_setup.sh): copies the main config files into place and can optionally install `/etc/tmux.conf`.
- [`SSH_tunneling_for_internalPen.sh`](/Users/zjohnson/Repositories/Zachs_Linux_Files/SSH_tunneling_for_internalPen.sh): SSH tunnel helper for common internal testing pivots.
- [`gather_workpapers.sh`](/Users/zjohnson/Repositories/Zachs_Linux_Files/gather_workpapers.sh): collects known log/workpaper directories into a destination folder. Work in progress.
- [`DNS_enum_multiple_resolvers.sh`](/Users/zjohnson/Repositories/Zachs_Linux_Files/DNS_enum_multiple_resolvers.sh): queries multiple public resolvers for A records.

## Reference files

- [`Linux Tricks.txt`](/Users/zjohnson/Repositories/Zachs_Linux_Files/Linux%20Tricks.txt): personal command notes.
- [`Tool Installs/PCredz_install_steps.txt`](/Users/zjohnson/Repositories/Zachs_Linux_Files/Tool%20Installs/PCredz_install_steps.txt): install notes, not an automation script.
- [`vmdk_repair.ps1`](/Users/zjohnson/Repositories/Zachs_Linux_Files/vmdk_repair.ps1): standalone Windows/PowerShell repair helper.
- [`default.zsh-theme`](/Users/zjohnson/Repositories/Zachs_Linux_Files/default.zsh-theme): reference theme variant.

## Local overrides

Use local overrides for values that differ by host instead of editing the shared files every time.

- `.zshrc` will source `$HOME/.zshrc.local` when present.
- Useful override variables include:
  - `ZJ_PIPX_BIN_DIR`
  - `ZJ_TOOL_ROOT`
  - `ZJ_SCRIPT_DIR`
  - `ZJ_POSTMAN_BIN`
  - `ZJ_VMWARE_SHARES_DIR`
  - `GOROOT`
  - `GOPATH`
- `initial_setup.sh` supports:
  - `-p` / `--proxy` to route both the Oh My Zsh installer download and the installer's Git traffic through the executing host's installed `proxychains` (or `proxychains4` when `proxychains` is absent). The binary uses its existing configuration; the script does not install ProxyChains or change its config. Configure the SOCKS endpoint and proxy DNS on that host beforehand. Proxy failures stop setup without falling back to direct downloads.
  - `--install-system-tmux` to back up an existing `/etc/tmux.conf` and write the new one. Only these system copies use `sudo` when needed; run the script as your normal user to keep your user configuration and ProxyChains settings.
  - `-y` / `--yes` to skip the script's prompts. Noninteractive runs also skip them. `sudo` may still require authentication when system tmux installation is requested.
  - Run from the repository root, for example: `zsh initial_setup.sh --proxy -y`. Download or installation failures stop setup before the configuration files are copied.
  - Existing configs are backed up beside the original before replacement, using names such as `.zshrc.bkup.20261103-143000.A1b2C3d4`. A unique suffix prevents backup collisions; backup failures stop setup before overwriting that config.
- `gather_workpapers.sh` supports `ZJ_GATHER_SUBFOLDER` to rename the destination subfolder.

## Usage notes

- Shared config now guards optional dependencies so it can land on a fresh Kali box without immediately failing on missing local tools or helper scripts.
- The repo still assumes Kali/Linux first. macOS support is intentionally limited to low-friction cases such as the prompt IP lookup.
