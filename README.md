# dotfiles

## Setup

```bash
git clone git@github.com:zhaoyuheng200/dotfiles.git ~/code/dotfiles
cd ~/code/dotfiles
./setup.sh
```

Then:
- Open `nvim` to auto-install plugins and Mason packages
- Open `tmux`, then press `prefix + I` (Ctrl-a Shift+I) to install tmux plugins

## Troubleshooting

### tree-sitter: GLIBC version not found

On older systems, the prebuilt `tree-sitter` binary may fail with:
```
tree-sitter: /lib64/libc.so.6: version `GLIBC_2.xx' not found
```

Run the build script to compile from source:
```bash
./build-tree-sitter.sh
```

This checks for required tools (git, cc), installs cargo/Rust if missing,
builds tree-sitter from source, and installs it to `~/.local/bin`.
