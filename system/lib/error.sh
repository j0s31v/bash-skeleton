#!/bin/bash

function error() {
  local -r _source=$1
  local -r _function=$2
  local -r _line=$3
  local -r _message=$4

  local _error_message="${_source}: ${_function}: line ${_line}: ${_message}"

  io::writeln "$_error_message" >&2
  log::error "$_error_message"

  exit 1
}

function failed() {
  local -r _message=$1  

  io::writeln "[FAILED] $_message" >&2 
  log::error "$_message"

  exit 1
}

#
# Aliases ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
alias   fail='printf "${BASH_SOURCE##*/}: ${FUNCNAME:-main}: %s\n"'
alias  debug='printf "${BASH_SOURCE##*/}: ${FUNCNAME:-main}: line ${LINENO}: %s\n"'
alias caller='nm=$(builtin caller 0); nm=${nm% *}; nm=${nm#* }; echo "${nm}"; unset nm'
alias    err='error "${BASH_SOURCE##*/}" "${FUNCNAME:-main}" "${LINENO}"'