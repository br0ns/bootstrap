#!/bin/bash

# I mark files with this string so I can skip the ones I have already set uo
BS_MARK="File written by Bootstrap, do not edit"

# We need `realpath` but apparently it is not a part of `coreutils` on Ubuntu
which realpath >/dev/null 2>&1 \
    || apt-get install --yes --no-install-recommends realpath

# Local variables
__this_cmd=
__this_lineno=
__assertion=
__was_exit=

# Global variables
ASK_STEP=
FORCE=
VERBOSE=
SILENT=
KEEP_TEMPDIR=
STEP="$(basename "$0")"
STEP="${STEP%.*}"
STEP_FILE="$(realpath "$0")"

# Exit on any error
set -e
# Using an undefined variable is an error
set -u
# Trace errors inside functions
set -o errtrace

# Logging
__BLACK=0
__RED=1
__GREEN=2
__YELLOW=3
__BLUE=4
__MAGENTA=5
__CYAN=6
__WHITE=7
__FG=3
__BG=4
__BOLD=1

__log() {
    ansi=$1
    shift
    label=$1
    shift
    echo -ne "\x1b[${ansi}m${label}\x1b[m " > /dev/stderr
    printf '%s' "$*" > /dev/stderr
}

__lognl() {
    ansi=$1
    shift
    label=$1
    shift
    echo -ne "\x1b[${ansi}m${label}\x1b[m " > /dev/stderr
    printf '%s\n' "$*" > /dev/stderr
}

DEBUG() {
    # Only print if verbose flag was set
    if [ "$VERBOSE" != true ] ; then
        return
    fi
    __lognl $__FG$__CYAN "DD" "$*"
}

OK() {
    # Don't print anything if the silent flag was set
    if [ "$SILENT" = true ] ; then
        return
    fi
    __lognl $__FG$__GREEN "OK" "$*"
}

INFO() {
    # Don't print anything if the silent flag was set
    if [ "$SILENT" = true ] ; then
        return
    fi
    __lognl $__FG$__BLUE "II" "$*"
}

WARN() {
    __lognl $__FG$__YELLOW "!!" "$*"
}

ERR() {
    __lognl $__FG$__RED "EE" "$*"
}

DIE() {
    __lognl "$__BOLD;$__BG$__RED" "!!" "$*"
    exit 1
}

QQ() {
    __log "$__BOLD;$__FG$__WHITE" "??" "$*"
}

__on_debug() {
    ret=$?

    # This function is called a second time if the EXIT or ERR traps trigger
    # (wat...), so we must take that into account.

    __prev_cmd=$__this_cmd
    __this_cmd=$BASH_COMMAND

    # Was the EXIT trap triggered?  The line number will be set to 1 in that
    # case.  Since this file must have been sourced on one of the lines a legit
    # call to this function will never have $LINENO being 1
    if [ $1 -eq 1 ] ; then
        return
    fi

    # Remember that this command was an exit call so we can print a message in
    # the EXIT trap handler.
    if [[ "$__this_cmd" =~ ^exit.* ]] ; then
        __was_exit=true
    fi

    __prev_lineno=$__this_lineno
    __this_lineno=$1

    # Only trace if -v flag is set
    if [ "$VERBOSE" != true ] ; then
        return
    fi

    # Was the ERR trap triggered?  This check can result in a false positive if
    # the same command is found twice on the same line but the first instance
    # doesn't trigger the ERR trap... but what are the chances?
    if [ "$__prev_cmd" = "$__this_cmd" ] && \
           [ "$__prev_lineno" = "$__this_lineno" ] && \
           [ $ret ] ; then
        return
    fi

    # We don't want to show a trace of logging commands
    if [[ "$__this_cmd" =~ ^(OK|INFO|WARN|ERR|DIE|echo|printf|prompt).* ]] ; then
        return
    fi

    __lognl $__FG$__MAGENTA "+" "$__this_cmd"
}

assert() {
    __assertion=true
    eval $@
    __assertion=false
}

max() {
    x=$1
    shift
    for n in "$@" ; do
        ((n > x)) && x=$n
    done
    echo $x
}

min() {
    x=$1
    shift
    for n in "$@" ; do
        ((n < x)) && x=$n
    done
    echo $x
}

__context() {
    C=3
    first=$(max 1 $(($__this_lineno - $C)))
    nlines=$(wc -l "$STEP_FILE" | cut -f 1 -d' ')
    last=$(min $(($nlines - 1)) $(($__this_lineno + $C)))
    align=${#last}
    echo -e "\x1b[35m$(basename $0):\x1b[m"
    for lineno in $(seq $first $last) ; do
        # echo -ne "\x1b[31m"
        if [ $lineno -eq $__this_lineno ] ; then
            echo -n "=> "
        else
            echo -n "   "
        fi
        echo -ne "\x1b[35m"
        printf "%${align}d\x1b[m %s\n" "$lineno" "$(head -n $lineno $STEP_FILE | tail -n-1)"
    done
}

__on_error() {
    ret=$?
    if [ "$__assertion" = true ] ; then
        ERR "ASSERTION FAILED"
    else
        ERR "Command failed with exit code $ret"
    fi
    __context
}

__on_exit() {
    ret=$?
    if [ $ret -ne 0 ] && [ "$__was_exit" = true ] ; then
        ERR "Script exited with exit code $ret"
        __context
    else
        OK Done
        echo
    fi
}

__on_int() {
    echo
    WARN Interrupted
    trap '' EXIT
    exit 0
}

# Parse command line options
__usage() {
    echo "usage: $(basename "$0") [-h] [-a] [-f] [-v|-s] [-k]"
    echo "  -h Help"
    echo "  -a Ask before each step"
    echo "  -f Force re-install (implies -a)"
    echo "  -v More output"
    echo "  -s Less output"
    echo "  -k Keep temporary directories"
}
while getopts "hafvsk" OPTION ; do
    case $OPTION in
        h) __usage
           exit 1
           ;;
        a) ASK_STEP=true
           ;;
        f) FORCE=true
           ASK_STEP=true
           ;;
        v) VERBOSE=true
           ;;
        s) SILENT=true
           ;;
        k) KEEP_TEMPDIR=true
           ;;
        ?) __usage
        exit 1
        ;;
    esac
done

# Utility functions
apt-get() {
    sudo CHECK_PKGS_DONT_RUN=1 apt-get $@
}

install() {
    INFO Installing "\`$1'"
    apt-get install --yes --no-install-recommends $1
}

plural () {
    echo -n "$1"
    if [ $2 -ne 1 ] ; then
        echo -n s
    fi
}

installed () {
    for x in $@ ; do
        if ! ( [ "${x:0:1}" = "/" ] && [ -e "$x" ] || \
               which $x || dpkg --status $x ) >/dev/null 2>&1 ; then
            return 1
        fi
    done
    return 0
}

require () {
    INFO "Checking for required packages"
    for pkg in $@ ; do
        if dpkg --status $pkg >/dev/null 2>&1 ; then
            OK $pkg
        else
            install $pkg
        fi
    done
}

promptyn () {
    if [ $# -eq 2 ] ; then
        if [ $2 == "y" ] ; then
            p="[Y/n]"
        else
            p="[y/N]"
        fi
    else
        p="[y/n]"
    fi
    while true; do
        QQ "$1 $p "
        read yn
        if [ "x$yn" == "xy" ] || \
               [ "x$yn" == "xyes" ] || \
               [ "x$yn" == "xY" ] || \
               [ "x$yn" == "xYes" ] || \
               [ "x$yn" == "xYES" ] || \
               [[ "x$yn" == "x" && $# -eq 2 && $2 == "y" ]] ; then
            return 0
        fi
        if [ "x$yn" == "xn" ] || \
               [ "x$yn" == "xno" ] || \
               [ "x$yn" == "xN" ] || \
               [ "x$yn" == "xNo" ] || \
               [ "x$yn" == "xNO" ] || \
               [[ "x$yn" == "x" && $# -eq 2 && $2 == "n" ]] ; then
            return 1
        fi
        WARN "Please answer yes or no"
    done
}

function promptoptions () {
    while true ; do
        QQ "$1 "
        read opt
        if [ "x${opt}" == "x" ] ; then
            echo "$3"
            return
        fi
        if [[ "$2" =~ (^| )${opt}($| ) ]] ; then
            echo "${opt}"
            return
        fi
        WARN "Invalid option"
    done
}

strstr () {
    x="${1%%$2*}"
    [[ "$x" = "$1" ]] && echo -1 || echo ${#x}
}

promptlist () {
    PROMPT="[$(echo "$1" | sed "s/\($2\)/\U\1/" | sed "s/./\0\\//g" | \
               head -c -2)] "
    while true ; do
        read -p "$PROMPT" opt
        if [ ${#opt} -eq 0 ] ; then
            opt=$2
        fi
        if [ ${#opt} -eq 1 ] ; then
            # Downcase
            opt=${opt,,}
            if [[ $1 == *"$opt"* ]] ; then
                echo $opt
                return
            fi
        fi
        echo "?" > /dev/stderr
    done
}

prompt_install () {
    prog=$1
    if [ $# -eq 2 ] ; then
        name=$2
    else
        name=$prog
    fi
    if installed $prog && [ "$FORCE" != true ] ; then
        # If the user ran this script directly, maybe she wants to re-install
        if [ -z "${BOOTSTRAP_ALL+x}" ] ; then
            promptyn "\`$name' is already installed; Re-install?" "y" || exit 0
            return 0
        fi
        exit 0
    fi
    # The user already agreed to run this step, so don't ask again
    [ "$ASK_STEP" = true ] && return 0
    # The user ran the step directly which shows intent, so don't ask
    [ -z "${BOOTSTRAP_ALL+x}" ] && return 0
    promptyn "\`$name' is not installed; Install now?" "y" || exit 0
    return 0
}

function configured () {
    head -n1 "$1" 2>/dev/null | grep -q "$BS_MARK"
}

function prompt_configure () {
    file=$1
    if configured $file && [ "$FORCE" != true ] ; then
        # If the user ran this script directly, maybe she wants to re-configure
        if [ -z "${BOOTSTRAP_ALL+x}" ] ; then
            promptyn "\`$file' is already configured by Bootstrap; Re-configure?" "y" || exit 0
            return 0
        fi
        exit 0
    fi
    # The user already agreed to run this step, so don't ask again
    [ "$ASK_STEP" = true ] && return 0
    # The user ran the step directly which shows intent, so don't ask
    [ -z "${BOOTSTRAP_ALL+x}" ] && return 0
    promptyn "\`$file' is not configured; Configure now?" "y" || exit 0
    return 0
}

function prompt_step () {
    # The user already agreed to run this step, so don't ask again
    [ "$ASK_STEP" = true ] && return 0
    promptyn "$1" "$2" || exit 0
    return 0
}

function goto_tempdir () {
    # TEMPDIR="/tmp/install-$STEP"
    TEMPDIR="$(mktemp -d /tmp/bootstrap.XXXXXXXXXX)"
    CLEAN="rm -rf $TEMPDIR 2>/dev/null || sudo rm -rf $TEMPDIR"
    eval $CLEAN
    mkdir -p $TEMPDIR
    cd $TEMPDIR
    INFO "Changing directory to $TEMPDIR"
    # Update exit handler to clean up
    if [ "$KEEP_TEMPDIR" != true ] ; then
        trap "$CLEAN;__on_exit" EXIT
    fi
}

# Finish up before we hand it back to the script
__title=$(echo "$STEP"|sed -r 's/([0-9]+)/(\x1b[36m\1\x1b[m) /')
echo -e "  \x1b[33m<<\x1b[m $__title \x1b[33m>>\x1b[m"

if [ -n "${BOOTSTRAP_ALL+x}" ] && [ "$ASK_STEP" = true ] ; then
    promptyn "Run step \`$STEP'?" "y" || exit 0
fi

# Invariant:  we're in home at the beginning of each step
cd

# Be sure to have the latest and greatest PATH
[ -f ~/.profile ] && . ~/.profile

# Find SSH agent's socket, if running
if [ -z ${SSH_AUTH_SOCK-} ] ; then
    SSH_AUTH_SOCK=$(\
        find /tmp -regex '/tmp/ssh-[a-zA-Z0-9]+/agent\.[0-9]+' 2>/dev/null \
            | head -n 1 \
            | tr -d '\n'
                 )

    # SSH agent is not running
    if [ -z $SSH_AUTH_SOCK ] ; then
        eval $(ssh-agent)
    else
        DEBUG Exporting SSH_AUTH_SOCK=$SSH_AUTH_SOCK
        export SSH_AUTH_SOCK
    fi
fi

# Add SSH key if not done so already
if ! ssh-add -l >/dev/null && [ -f ~/.ssh/id_rsa ] ; then
    INFO Adding key to SSH agent:
    ssh-add
fi

# Set up trap handlers
trap '__on_error' ERR
trap '__on_exit' EXIT
trap '__on_int' INT
trap '__on_debug $LINENO' DEBUG
