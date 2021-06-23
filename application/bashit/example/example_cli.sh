#!/bin/bash
declare -g -A _BASHIT_PARAMS=(
    ["foo"]=""
)

function usage() {
    cat <<EOF >&2

Usage: $(basename $0)  [options]

    Example:
        $(basename $0) 

    --foo          Argumento foo
    -h| --help     Esta pantalla.
    
EOF
}

function example_arguments() {
  
  local _foo=""
  
  for arg in "$@"
  do
    case ${arg} in
          --foo=*) _foo="${arg#*=}" && shift ;;
        -h|--help) usage && exit 1 ;;
                *) shift ;;
    esac
    shift
  done

  [[ -z "$_foo" ]] && _foo=$BASHIT_EXAMPLE_FOO
 
  _BASHIT_PARAMS["foo"]=$_foo

}

function example::run::cli() {
  if [[ ! -v __EXAMPLE_IS_LOADED ]]; then
    readonly __EXAMPLE_IS_LOADED=true

    source "${APP_DIR}/bashit/example/example.sh"

    examples_arguments $@
  fi
 
  local -r _foo=${_BASHIT_PARAMS["foo"]}
 
  bashit::run "$_foo" 
}