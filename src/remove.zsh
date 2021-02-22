##
# Unmount a mounted device.
#
# @param $1 {string} Name of the device that will be unmounted.
##
function sub_remove() {
  if [[ -z "$*" ]] {
    echo; console.error 'You need to specify a device.'; echo
    exit 1
  }

  local SERVER_NAME="${1:-''}"
  local UNMOUNT_PATH="/media/$(whoami)/$SERVER_NAME"

  if (! (mount | grep "$UNMOUNT_PATH" >/dev/null)) {
    echo; console.error "$UNMOUNT_PATH not mounted."
    exit 1
  }

  echo

  console.info \
    'Following command will be executed with root permissions.' \
    "$ \033[${color[underline]}m${fg[green]}sudo${reset_color} ${fg[green]}umount${reset_color} -f $UNMOUNT_PATH"

  sudo umount -f "$UNMOUNT_PATH"

  if (( $? == 0 )) {
    console.info "Successfully unmounted."; echo
    exit 0

  } else {
    console.error "Can't unmount. There was an error."; echo
    exit 1
  }
}
