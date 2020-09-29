#!/bin/sh

set -e

mingw_prefix=/usr/@TRIPLE@

# run it in a custom WINEPREFIX to not mess with default ~/.wine
# also default prefix might be a 32 bits prefix, which will fail to run x86_64 exes
export WINEPREFIX=${HOME}/.wine-@TRIPLE@

# WINEPATH is used to find dlls, otherwise they should lie next to the exe
if test -z "${WINEPATH}"
then
  export WINEPATH=${mingw_prefix}/bin
fi


if test "@TRIPLE@" = "x86_64-w64-mingw32"
then
  export WINEARCH=win64
else
  export WINEARCH=win32
fi

export WINEDLLOVERRIDES="mscoree,mshtml="

# if MINGW_WINE_LOCK is set, only one wine process is allowed at once
if test -n "${MINGW_WINE_LOCK}"
then
  /usr/bin/lockfile-create -r 1000 ${WINEPREFIX}
  /usr/bin/wine "$@"
  /usr/bin/lockfile-remove ${WINEPREFIX}
else
  /usr/bin/wine "$@"
fi
