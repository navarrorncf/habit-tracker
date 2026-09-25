#!/bin/sh

set -eu

repository_root=$(CDPATH= cd "$(dirname "$0")/.." && pwd)

git -C "$repository_root" rev-parse --show-toplevel >/dev/null 2>&1

git -C "$repository_root" config core.hooksPath .githooks
printf '%s\n' "Git hooks installed for $repository_root"
printf '%s\n' 'Configured repository-local core.hooksPath=.githooks'
