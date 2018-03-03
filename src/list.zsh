##
# Lists mounted devices.
##
function sub_list() {
	if (! (mount | command grep --color=never --extended-regexp '.+:.+')) {
		echo; console.info 'You have not mounted anything yet.'; echo
	}
}
