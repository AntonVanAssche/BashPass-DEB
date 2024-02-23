#!/usr/bin/env bash

set -o errexit  # Abort on nonzero exit code.
set -o noglob   # Disable globbing.
set +o xtrace   # Disable debug mode.
set -o pipefail # Don't hide errors within pipes.

readonly NAME='bashpass'
readonly VERSION='3.2'

# Whenever an error occurs, we want to notify the user about it.
# This is a basic function that wil print the corresponding error
# message to stderr, and will exit with the given exit status.
error_out() {
    printf '\n'
    printf 'An error occurred: %s' "${1}" >&2
    printf '\n'
    exit "${2}"
}

# The script expects BashPass to be in the same directory as this script.
# So we will have to check if it is there.
[[ -d BashPass ]] || \
    error_out 'BashPass is not in the same directory as this script.' 1

# Prepare build directory.
mkdir -p DEBIAN/usr/bin
mkdir -p DEBIAN/usr/share/man/man1
mkdir -p DEBIAN/etc/skel/.config/bashpass

cp -r "BashPass/${NAME}" DEBIAN/usr/bin/
cp -r "BashPass/docs/${NAME}.1.gz" DEBIAN/usr/share/man/man1/
cp -r "BashPass/docs/${NAME}.conf.1.gz" DEBIAN/usr/share/man/man1/
cp -r "BashPass/config/${NAME}.conf" DEBIAN/etc/skel/.config/bashpass/

# Create the package.
dpkg-deb --build . "${NAME}_${VERSION}_all.deb"
