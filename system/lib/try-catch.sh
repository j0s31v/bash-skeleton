#!/bin/bash

declare -g -A __EXCEPTION_NAMES=()

# https://gist.github.com/e7d/e43e6586c1c2ecb67ae2
function try()
{
    [[ $- = *e* ]]; SAVED_OPT_E=$?
    set +e
}

function throw()
{
    exit $1
}

function catch()
{
    export ex_code=$?
    (( $SAVED_OPT_E )) && set +e
    return $ex_code
}

function throw_errors()
{
    set -e
}

function ignore_errors()
{
    set +e
}

function exception_name() {
  local -r _code=$1
  echo "${__EXCEPTION_NAMES[$_code]}"
}

function add_exception() {
  local -r _name=$1
  local -r _code=$2
  local -r _description=$3
  
  [[ ! -v __EXCEPTION_NAMES[$_code] ]] || error "Excepcion con codigo $_code, $_name ya existe, favor seleccionar un nuevo codigo!!" 

  readonly $_name=$_code

  __EXCEPTION_NAMES[$_code]="$_description"
}