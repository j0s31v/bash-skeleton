#!/bin/bash

trap clean::temporal_files EXIT

function clean::temporal_files() {

  if [[ $CLEAN_FILES_AND_FOLDERS || $DEBUGGER == 0 ]] ; then
    clean::cleanup
    clean::dead_process
  fi  
}

function clean::cleanup() {
  local _pid=$1

  if [[ $_pid = "" ]]; then
    _pid="${PID}"  
  fi

  local _proc_dir="${PROC_DIR}/${_pid}"  
  local  _tmp_dir=$(cat "${PROC_DIR}/${_pid}/tmp_dir")

  if [[ ! -z $_tmp_dir ]]; then
    rm -rf $_tmp_dir
  fi

  if [[ ! -z $_proc_dir ]]; then
    rm -rf $_proc_dir
  fi
  
}

function clean::dead_process() {

  find ${PROC_DIR}/* -prune -type d 2>/dev/null | while IFS= read -r _dir; do
    if [[ $(ps -p ${_dir##*/} | grep ${_dir##*/}) = "" ]]; then
      log::error "El proceso ${_dir##*/} esta muerto, eliminando los archivos generados por el sistema!!."   
      clean::cleanup "${_dir##*/}"
    fi
  done 
}
