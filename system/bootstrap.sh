#!/bin/bash

# bash style coding :: https://github.com/icy/bash-coding-style
# bash style coding :: http://mpailhe.free.fr/bashPdf/StyleGuideShell.en.pdf
# bash style coding :: https://chromium.googlesource.com/chromiumos/docs/+/master/styleguide/shell.md
# bash style coding :: https://google.github.io/styleguide/shellguide.html
#( set -o posix ; set ) >/tmp/variables.before

shopt -s expand_aliases
#shopt -s shift_verbose
#shopt -s xpg_echo
#shopt -u restricted_shell
#shopt -s sourcepath
#shopt -s extglob
LC_NUMERIC="en_US.UTF-8"

# Configuraciones por defecto
readonly        PID=$$
readonly   ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" >/dev/null 2>&1 && pwd )"
readonly    VAR_DIR="${ROOT_DIR}/var"
readonly    TMP_DIR=$(mktemp -d -t exec_XXXXXXX --tmpdir="${VAR_DIR}/tmp")
readonly    LOG_DIR="${ROOT_DIR}/var/log"
readonly   PROC_DIR="${ROOT_DIR}/var/proc"
readonly    SYS_DIR="${ROOT_DIR}/system"
readonly    APP_DIR="${ROOT_DIR}/application"
readonly CONFIG_DIR="${APP_DIR}/config"

# Creacion de carpetas
if [[ ! -d "${PROC_DIR}/${PID}" ]]; then
  mkdir -p "${PROC_DIR}/${PID}"
fi

if [[ ! -d "${TMP_DIR}" ]]; then
  mkdir -p "${TMP_DIR}"
fi

if [[ ! -d "${LOG_DIR}" ]]; then
  mkdir -p "${LOG_DIR}"
fi

echo "${TMP_DIR}" > "${PROC_DIR}/${PID}/tmp_dir"

# Cargar las configuraciones de ambiente
source "${ROOT_DIR}/.app_environment"

# Cargar configuraciones
source "${SYS_DIR}/lib/config/system_configuration"

# Cargar librerias base del framework
source "${SYS_DIR}/lib/colors.sh"
source "${SYS_DIR}/lib/io.sh"
source "${SYS_DIR}/lib/logger.sh"
source "${SYS_DIR}/lib/cleaner.sh"
source "${SYS_DIR}/lib/str.sh"
source "${SYS_DIR}/lib/time.sh"
source "${SYS_DIR}/lib/tmp.sh"
source "${SYS_DIR}/lib/try-catch.sh"
source "${SYS_DIR}/lib/error.sh"
source "${SYS_DIR}/lib/request.sh"

colors::colorized

if [[ ! -d "${USR_DIR}" ]]; then
  mkdir -p "${USR_DIR}"
fi

# Cargar librerias extras 
if [[ -f "${CONFIG_DIR}/load_libraries" ]]; then
  source "${CONFIG_DIR}/load_libraries"
  load_libraries
fi
