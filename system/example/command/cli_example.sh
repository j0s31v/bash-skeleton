#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
SYS_DIR="$DIR/../../"
CMD_NAME=$0

#
# Cargar el sistema base
source "${SYS_DIR}/base/runner_cli.sh"

function usage() {
  cat <<EOF >&2

Usage: $0 [options]

    Example:
        $0 --version

    -h  --help            Esta pantalla.
    -v  --version         Version.
        --show-variables  Muestra las variables generadas el inicio de la ejecución.

    [command]           Sub comando a ejecutar, en caso que los comandos sean por slug
    
    
EOF
exit 0
}

function main() {
  io::writeln ":::::::::::::::::::::::::"
  io::writeln ":::::::::::::::::::::::::"
  io::writeln "Excecute main function!!!"
  io::writeln ":::::::::::::::::::::::::"
  io::writeln ":::::::::::::::::::::::::"
 
  sleep 30
}

excecute $@
