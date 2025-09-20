#!/bin/bash
set -euo pipefail

function ghmcp {
    local -r token="$(ddtool auth github token)"
    docker pull ghcr.io/github/github-mcp-server
    docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN="$token" ghcr.io/github/github-mcp-server
}

ghmcp
