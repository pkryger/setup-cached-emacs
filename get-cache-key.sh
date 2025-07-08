#!/bin/bash

if [[ $# -eq 0  || $# -gt 2 ]]; then
   echo "Usage: $0 OS EMACS_VERSION" >&2n
   exit 1
fi

set -euo pipefail

emacs_version=$(echo "${2}"                                         \
                    | sed -e 's/^[[:space:]]*//;s/[[:space:]]*$//')

if [[ "${emacs_version}" == "snapshot"
        || "${emacs_version}" == "release-snapshot" ]]; then
    if [[ "${emacs_version}" == "snapshot" ]]; then
        ref=refs/heads/master
    else
        ref=refs/heads/emacs-30
    fi
    emacs_version=$(git ls-remote https://github.com/emacs-mirror/emacs.git ${ref}  \
                        | sed -e 's/^\([[:xdigit:]]\{7,7\}\).*/emacs@\1/ '          \
                        | tr -d '\n')
fi

if [[ -z "${emacs_version}" ]]; then
    echo "Cannot get emacs version" >&2
    exit 1
fi


key="cached-emacs-${1}-${emacs_version}"

echo "${key}" | tee /dev/stderr
