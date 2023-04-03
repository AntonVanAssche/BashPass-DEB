#!/usr/bin/env bash

set -o errexit  # Abort on nonzero exit code.
set -o noglob   # Disable globbing.
set +o xtrace   # Disable debug mode.
set -o pipefail # Don't hide errors within pipes.

readonly NAME='bashpass-remote'
readonly VERSION='1.0'

# Whenever an error occurs, we want to notify the user about it.
# This is a basic function that wil print the corresponding error
# message to stderr, and will exit with the given exit status.
error_out() {
    printf '\n'
    printf 'An error occurred: %s' "${1}" >&2
    printf '\n'
    exit "${2}"
}

# The script expects BashPass-Remote to be in the same directory as this script.
# So we will have to check if it is there.
[[ -d BashPass-Remote ]] || \
    error_out 'BashPass-Remote is not in the same directory as this script.' 1

# Prepare build directory.
mkdir -p DEBIAN/usr/bin
mkdir -p DEBIAN/usr/share/man/man1

cp -r "BashPass-Remote/${NAME}" DEBIAN/usr/bin/
cp -r "BashPass-Remote/docs/${NAME}.1.gz" DEBIAN/usr/share/man/man1/

# Create the package.
dpkg-deb --build . "${NAME}_${VERSION}_all.deb"
