#!/usr/bin/env bash
set -ex

declare -rg CHEZMOI_SOURCEPATH="$(chezmoi source-path)"

function packer_compile {
    nvim \
        --headless \
        -c "autocmd User PackerCompileDone quitall" \
        -c "PackerCompile"
    cp "$XDG_CONFIG_HOME/nvim/plugin/packer_compiled.lua" "$CHEZMOI_SOURCEPATH/dot_config/nvim/plugin/packer_compiled.lua"
}

function packer_snapshot {
    local -r name="$(date +%F).json"
    local -r src="$XDG_CACHE_HOME/nvim/packer.nvim/$name"
    local -r dest="$(chezmoi source-path)/dot_cache/private_nvim/packer.nvim/snapshot.json"

    # wait for https://github.com/wbthomason/packer.nvim/pull/898
    #nvim \
    #    --headless \
    #    -c "autocmd User PackerSnapshotDone quitall" \
    #    -c "PackerSnapshot $name"
    jq -S < "$src" > "$dest"

    # Packer loads snapshot.json
    chezmoi apply --force "$XDG_CACHE_HOME/nvim/packer.nvim/snapshot.json"
}

packer_compile
packer_snapshot

