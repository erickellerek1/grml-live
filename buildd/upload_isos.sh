#!/bin/sh
# Filename:      /usr/share/grml-live/buildd/upload_isos.sh
# Purpose:       upload grml ISOs to a rsync server
# Authors:       grml-team (grml.org), (c) Michael Prokop <mika@grml.org>
# Bug-Reports:   see http://grml.org/bugs/
# License:       This file is licensed under the GPL v2 or any later version.
################################################################################

. /etc/grml/grml-buildd.conf || exit 1
[ -n "$RSYNC_MIRROR" ] || exit 2
[ -n "$ISO_DIR" ] || exit 3

cd $ISO_DIR || exit 4

umask 002
for file in *.iso ; do
    [ -f "${file}.md5" ]  || md5sum "$file" > "${file}".md5
    [ -f "${file}.sha1" ] || sha1sum "$file" > "${file}".sha1
    chmod 664 "${file}" "${file}".md5 "${file}".sha1
done

for distri in squeeze wheezy sid ; do
  for flavour in grml-small_$distri   grml-medium_$distri   grml_$distri \
                 grml64-small_$distri grml64-medium_$distri grml64_$distri ; do
                 if ls $flavour* 1>/dev/null 2>&1 ; then
                   rsync --times --partial -az --quiet $flavour* $RSYNC_MIRROR/$flavour/
                 fi
  done
done

## END OF FILE #################################################################
