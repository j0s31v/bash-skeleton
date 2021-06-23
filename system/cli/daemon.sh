#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
CMD_NAME=$0

# Obteniendo el directorio de enlaces simbolico
if [[ -L "${DIR}/${CMD_NAME}" ]]; then
  DIR=$( cd "$( dirname "$(readlink "${DIR}/${CMD_NAME}")" )" && pwd )
fi

# Cargar el sistema base
source "${DIR}/../bootstrap.sh"

function usage() {
  cat <<EOF >&2

Usage: $0 [command] [command options]

    -h| --help          Esta pantalla.
    -v| --version       Version   
    --run-once          Ejecuta solo un ciclo.                 
    [command]           Sub comando a ejecutar
EOF
  exit 0
}

function show_version() {
  echo -e "${CMD_NAME} version: ${VERSION}"
  exit 0
}

function __evaluate_default_arguments() {
  local -r _arguments=$@

  for _argument in ${_arguments[@]}; do
      case $_argument in
           -h|--help) usage ;;
        -v|--version) show_version ;;
          --run-once) daemonizable::stop_running ;;
              --stop) stop_execution ;;
      esac
  done
}

function __evaluate_stop_argument() {
  local -r _arguments=$@

  local _stopped=0
  for _argument in ${_arguments[@]}; do
    if [[ $_argument == "--stop" ]]; then
      _stopped=1
      daemonizable::stop_running
      io::write "Esperando a que el proceso se detenga"
      for (( i = 0; i < 60; i++ )); do
        
        if [[ ! -f $(daemonizable::_pid_filename) ]]; then
          io::newline
          io::writeln "Proceso finalizado."
          daemonizable::ending
          exit 0
        else
          io::write "."
        fi

        sleep 1
      done
    fi
  done 

  if [[ $_stopped == 1 ]]; then
    io::newline
    io::writeln "No se puede detener el proceso"
  fi

}

function excecute() {

  source "${SYS_DIR}/lib/daemonizable.sh"
  
  __evaluate_stop_argument $@

  daemonizable::initalize
  while :; do
    daemonizable::start_iteration

    __evaluate_default_arguments $@
    main $@

    daemonizable::finish_iteration
    daemonizable::wait_next_iteration
    # fin del ciclo
    $(daemonizable::finish_request) || break
  done
  daemonizable::ending

}
