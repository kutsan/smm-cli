##
# Show program usage informations and exit.
##
function show_help() {
cat << EOF

  SSHFS Mount Manager

  SYNOPSIS
    $ smm <add|remove|list> <server-name (Host from ~/.ssh/config)>:[<server-path>] [<volume-name>]

  EXAMPLES
    $ smm add felis:/storage/emulated/0 MyPhone
      .. mounts to /media/username/felis

    $ smm add felis MyPhone
      .. shows a select menu for predefined remote paths that you can choose
      .. optional \$2 for volume-name otherwise will be used server-name as default
      .. mounts to /media/username/felis

    $ smm add felis
      .. shows a select menu for predefined remote paths that you can choose
      .. mounts to /media/username/felis

    $ smm remove felis
      .. unmounts /media/username/felis

    $ smm list
      .. lists current mount points.

  AUTHOR
    Kutsan Kaplan <me@kutsan.dev>

  LICENSE
    GPL-3.0

  VERSION
    v0.2.0

EOF

  exit 0
}
