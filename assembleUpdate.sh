#!/bin/bash
# assembleUpdate.sh --- bring this templates base in line with its two inputs.
#
# Run it after every add, rename or delete of a command or template file in
# aiTemplates-workFlow or aiTemplates-DE (an edit of an existing file needs nothing).
# It runs from any directory: the base is the directory this script is in.
#
#   ./assembleUpdate.sh          # assemblyUpdate, then assemblyCheck
#
# aiActivityAssemble.cs exits 0 even when a path is refused or the base is still
# behind, so the check's last line is read here and turned into the exit status.

set -o nounset -o pipefail

base="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

aiActivityAssemble.cs -i assemblyUpdate --base="${base}" || exit 1
echo
check="$(aiActivityAssemble.cs -i assemblyCheck --base="${base}")" || exit 1
echo "${check}"

if ! grep -q '^IN SYNC' <<<"${check}"; then
    echo "assembleUpdate.sh: the base is not in sync" >&2
    exit 1
fi
