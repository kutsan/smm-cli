#!/usr/bin/env zsh

###
# SSHFS Mount Manager
# `smm` uses your ~/.ssh/config file.
#
# USAGE
#   Run this program without arguments to see list of options.
#
# @author Kutsan Kaplan <me@kutsankaplan.com>
# @license GPL-3.0
# @version v0.1.0
##

setopt ERR_EXIT NO_UNSET PIPE_FAIL WARN_CREATE_GLOBAL WARN_NESTED_VAR

typeset -g SCRIPT_PATH="$(readlink -f "$0" | xargs dirname)"

##
# @param $1 {string} Subcommand.
# @param $2 {string} Subcommand arguments.
##
function main() {
	cd $SCRIPT_PATH

	local script
	foreach script (
		./console.zsh
		./help.zsh
		./add.zsh
		./list.zsh
		./remove.zsh
	) {
		source $script || exit 1
	}

	local subcommand=${1:-''}

	case "$subcommand" {
		'' | '-h' | '--help' | 'help')
			show_help
			;;

		'--version' | 'version')
			echo 'smm v0.1.0'
			exit 0
			;;

		'add' | 'remove' | 'list')
			hash sshfs &>/dev/null || {
				echo; console.error "You need to install ${bold_color}sshfs${reset_color} first in order to use this program."; echo
				exit 1
			}

			shift
			sub_${subcommand} "$@" && exit 0
			;;

		*)
			echo
			console.error \
				"${bold_color}$subcommand${reset_color} is not a known subcommand." \
				"Run ${bold_color}smm --help${reset_color} for a list of known subcommands."
			echo
			exit 1
			;;
	}
}
main "$@"
