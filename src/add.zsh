##
# Mounts a device.
#
# @param $1 {string} Name of the remote server.
# @param $2 {string} Path of the directory to be mounted in remote server.
##
function sub_add() {
  if [[ "$*" == '' ]] {
    echo; console.error 'You need to specify a device.'; echo
    exit 1
  }

  local SERVER_NAME="${1%:*}" # String before colon
  local SERVER_PATH="$(echo "${1//$SERVER_NAME/}" | sed -e 's/://')" # String after colon
  local MOUNT_PATH="/media/$(whoami)/$SERVER_NAME"

  if (mount | grep "$MOUNT_PATH" &>/dev/null) {
    echo; console.error "${bold_color}$MOUNT_PATH${reset_color} already mounted."; echo
    exit 1
  }

  # If mount path does not exist
  if [[ ! -d "$MOUNT_PATH" ]] {
    echo; console.info "Mount path does not exist, creating ${bold_color}$MOUNT_PATH${reset_color}."; echo

    mkdir -p "$MOUNT_PATH" 2>/dev/null \
      || console.info \
          'Following command will be executed with root permissions.' \
          "$ sudo mkdir -p \"$MOUNT_PATH\" && sudo chown $(whoami) \"$MOUNT_PATH\"" \
        && sudo mkdir -p "$MOUNT_PATH" && sudo chown "$(whoami)" "$MOUNT_PATH"
  }

  if [[ "$SERVER_PATH" == '' ]] {
    echo; console.warn 'You did not specify any path. Choose one of them.'; echo

    # Prepare select
    local PS3='> '
    local choice=''
    local REPLY=''
    local SERVER_PATH_ALIAS=''

    select choice ('$HOME' '/' '/storage/emulated/0') {
      case ${REPLY:-''} {
        1) SERVER_PATH=''; SERVER_PATH_ALIAS="\~/" ;;
        2) SERVER_PATH=$choice ;;
        3) SERVER_PATH=$choice ;;
        *) console.warn 'Invalid option' ;;
      }

      # If $choice valid
      if [[ $choice != '' ]] {
        break
      }
    }

    if ([[ $SERVER_NAME == '' ]] || [[ $SERVER_PATH_ALIAS == '' ]]) {
      console.error 'Operation has terminated, exiting.'
      exit 1
    }
  }

  local VOLUME_NAME="${2:-$SERVER_NAME ${SERVER_PATH_ALIAS:-$SERVER_PATH}}"

  sshfs \
    -F ~/.ssh/config \
    -o volname="$VOLUME_NAME" \
    "$SERVER_NAME:$SERVER_PATH" \
    "$MOUNT_PATH"

  if (( $? == 0 )) {
    echo; console.info "Mounted on $MOUNT_PATH."; echo

  } else {
    echo
    console.error \
      "There was an error mounting $SERVER_NAME:${SERVER_PATH_ALIAS:-$SERVER_PATH} to local $MOUNT_PATH, check your configuration." \
      "Broken $MOUNT_PATH unmounting..."
    echo

    umount -f "$MOUNT_PATH" || sudo umount -f "$MOUNT_PATH" || true
    rm -rf "$MOUNT_PATH" 2>/dev/null || sudo rm -rf "$MOUNT_PATH" 2>/dev/null || true

    echo
    exit 1
  }
}
