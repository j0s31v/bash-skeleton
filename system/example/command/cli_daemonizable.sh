#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
SYS_DIR="$DIR/../../"
CMD_NAME=$0
IS_DAEMONIZABLE=true

#
# Obteniendo el directorio de enlaces simbolico
if [[ -L "${DIR}/${CMD_NAME}" ]]; then
  DIR=$( cd "$( dirname "$(readlink "${DIR}/${CMD_NAME}")" )" && pwd )
fi

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
    -l  --list            Lista los comandos por slug.
        --run-once        Ejecuta los comandos daemonizables solo una vez.

    [command]           Sub comando a ejecutar, en caso que los comandos sean por slug

EOF
  exit 1
}

function main() {
  io::writeln ":::::::::::::::::::::::::"
  io::writeln ":::::::::::::::::::::::::"
  io::writeln "Excecute main function!!!"
  io::writeln ":::::::::::::::::::::::::"
  io::writeln ":::::::::::::::::::::::::"

  sleep 1
}

excecute $@
