#!/bin/bash

if [[ ! -v __LIB_DAEMONIZABLE_IS_LOADED ]]; then
  readonly __LIB_DAEMONIZABLE_IS_LOADED=true

  # trap ctrl-c and call ctrl_c()
fi

trap trap_daemonizable_stop INT

function trap_daemonizable_stop() {
  daemonizable::stop_running
  daemonizable::ending
  exit 1
}

function daemonizable::start_iteration() {
  #log "inicio de el comando"
  return 0
}

function daemonizable::finish_iteration() {
  #log "finalizacio del comando"
  return 0
}

function daemonizable::_stop_filename() {
  if  [[ `type -t daemonizable::stop_filename`"" == 'function' ]] ; then
    echo "$(daemonizable::stop_filename)"
  else
    echo "${PROC_DIR}/daemon.${APP_NAME}.stop"
  fi
}

function daemonizable::_pid_filename() {
  if [[ `type -t daemonizable::pid_filename`"" == 'function' ]] ; then
    echo "$(daemonizable::pid_filename)"
  else
    echo "${PROC_DIR}/daemon.${APP_NAME}.pid"
  fi
}

function daemonizable::finish_request() {
  if [[ -f $(daemonizable::_stop_filename) ]]; then
    return 1
  fi
  return 0
}

function daemonizable::wait_next_iteration() {
  return 0
}

function daemonizable::stop_running() {
  touch $(daemonizable::_stop_filename)
}

function daemonizable::initalize() {
  
  if [[ -f $(daemonizable::_pid_filename) ]]; then
    local _pid=$(cat $(daemonizable::_pid_filename))
    if [[ $(ps -p "$_pid" | grep "$_pid") != "" ]]; then
      io::writeln "El comando ${CMD_NAME} ya esta siendo ejecutado. !!"
      log::error "El comando ${CMD_NAME} ya esta siendo ejecutado. !!"
      exit 1
    fi
  fi

  mkdir -p "${PROC_DIR}"
  touch $(daemonizable::_pid_filename)
  echo $PID > $(daemonizable::_pid_filename)
}

function daemonizable::ending() {
  rm -f $(daemonizable::_pid_filename)
  rm -f $(daemonizable::_stop_filename)
  return 0
}
