#!/bin/sh


platform=""
case $(uname) in
"Darwin") platform="darwin" ;;
*) platform="linux" ;;
esac

architecture=""
case $(uname -m) in
i386) architecture="386" ;;
i686) architecture="386" ;;
x86_64) architecture="amd64" ;;
arm) dpkg --print-architecture | grep -q "arm64" && architecture="arm64" || architecture="arm" ;;
esac

echo "Detected OS: $platform & $architecture"
fisher_version=3.2.11
fisher_download_url="https://raw.githubusercontent.com/jorgebucaran/fisher/$fisher_version/fisher.fish"
starship_download_url="https://starship.rs/install.sh"
screenfetch_version=3.9.1
screenfetch_download_url="https://github.com/KittyKatt/screenFetch/blob/v$screenfetch_version/screenfetch-dev"
fzf_version=0.21.1
fzf_dowload_url="https://github.com/junegunn/fzf-bin/releases/download/$fzf_version/fzf-$fzf_version-${platform}_$architecture.tgz"
theme_url_prefix="https://raw.githubusercontent.com/Hiberbee/fish-theme/master"
config_dir=${XDG_CONFIG_HOME:-"$HOME/.config"}
fish_functions_path="$config_dir/fish/functions"
bin_dir=${BIN_DIR:-$HOME/bin}

if [ ! -d "$bin_dir" ]; then
  echo "Directory $bin_dir directory is not exist, creating"
  mkdir "$bin_dir"
fi

export PATH="$bin_dir:$PATH"

if [ ! -d "$fish_functions_path" ]; then
  echo "Fish's $fish_functions_path directory is not exist, creating"
  mkdir -p "$fish_functions_path"
fi

if [ ! -f "$fish_functions_path/fisher.fish" ]; then
  echo "Downloading fisher"
  wget "$fisher_download_url" -qO "$fish_functions_path/fisher.fish"
else
  echo "Fisher already installed"
fi

echo "Installing dependencies, theme settings & shell prompts"
wget "$theme_url_prefix/.config/starship.toml" -qO "$config_dir/starship.toml"
wget "$theme_url_prefix/fishfile" -qO "$config_dir/fish/fishfile"
wget "$theme_url_prefix/functions/fish_prompt.fish" -qO "$fish_functions_path/fish_prompt.fish"
wget "$theme_url_prefix/functions/fish_prompt.fish" -qO "$fish_functions_path/fish_prompt.fish"

if [ ! "$(command -v starship)" ]; then
  echo "Installing Starship shell prompt"
  wget "$starship_download_url" -qO- | FORCE=1 BIN_DIR=$bin_dir bash
else
  echo "Starship already installed"
fi

if [ ! "$(command -v screenfetch)" ]; then
  echo "Installing SreenFetch"
  wget "$screenfetch_download_url" -qO "$bin_dir/screenfetch"
else
  echo "ScreenFetch already installed"
fi

if [ ! "$(command -v fzf)" ]; then
  echo "Downloading fzf $fzf_dowload_url"
  wget "$fzf_dowload_url" -qO- | tar -xzv -C "$bin_dir"
else
  echo "fzf already installed"
fi

chmod -R +x "$bin_dir"
