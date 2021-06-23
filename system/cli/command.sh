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
    [command]           Sub comando a ejecutar
EOF
  exit 1
}

function show_version() {
  echo -e "${CMD_NAME} version: ${VERSION}"
  exit 1
}

function show_list() {
  echo -e "Muestra la lista de comandos disponibles"
  echo -e ""
  
  for _cmd in "${!CLI_SUBCOMMANDS_EXEC[@]}"
  do
    echo -e "${GREEN}$_cmd :${NC} ${CLI_SUBCOMMANDS_DESC[$_cmd]}"
  done

  exit 1
}

function __evaluate_default_arguments() {
  local -r _arguments=$@

  for _argument in ${_arguments[@]}; do
      case $_argument in
           -h|--help) usage ;;
        -v|--version) show_version ;;
      esac
  done
}

function __evaluate_default_arguments_subcommand() {
  local -r _command=$1

  local -r _arguments=($@)
  
  if [[ $_command == "-h" || $_command == "--help" ]];then
    usage
  fi

  for _argument in $@; do
      case $_argument in
        -v|--version) show_version ;;
           -l|--list) show_list ;; 
      esac
  done
}

function excecute() {

  load_subcommands
  load_libraries

  if [[ -v CLI_SUBCOMMANDS_EXEC[@] ]]; then
    __run_subcommands $@
  else
    __run_main $@ 
  fi

}

function load_subcommands() {
  echo -n ""
}

function load_libraries() {
  echo -n ""
}

function evaluate_arguments() {
  echo -n ""
}

function __run_subcommands() {
  local -r _command=$1

  __evaluate_default_arguments_subcommand $@
  shift

  if [[ $_command = "" ]]; then 
    echo "Falta ingresar el commando a ejecutar"
    usage 
  fi

  if [[ ! -v CLI_SUBCOMMANDS_EXEC[$_command] ]]; then
    echo "Commando ${_command} no encontrado !!"
    usage 
  fi

  evaluate_arguments $@

  if [[ -f ${CLI_SUBCOMMANDS_EXEC["$_command"]} ]];then
    bash "${CLI_SUBCOMMANDS_EXEC["${_command}"]}" $@
  else
    ${CLI_SUBCOMMANDS_EXEC["$_command"]} $@
  fi
}

function __run_main() {
  __evaluate_default_arguments $@
  evaluate_arguments $@
  main $@
}

