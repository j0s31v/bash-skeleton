#!/bin/bash

if [[ ! -v __LIB_TIME_IS_LOADED ]]; then
  readonly __LIB_TIME_IS_LOADED=true

  declare -g __LIB_TIME_TIMMER=()
fi

function time::epoch() {
  date +%s
}

function time::now() {
  date --rfc-3339=seconds
}

function time::today() {
  date +'%F'
}

function time::add_timer() {
  local -r _name=$1
  
  __LIB_TIME_TIMMER["${_name}"]=${SECONDS}
  
  echo ${__LIB_TIME_TIMMER["${_name}"]}
}

function time::enlapsed() {
  local -r _name=$1
  
  local _start=${__LIB_TIME_TIMMER["${_name}"]}
  local _end=$SECONDS
  
  echo $(( _end - _start ))
}
