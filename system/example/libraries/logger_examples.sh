#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
SYS_DIR="$DIR/../../"

source "$SYS_DIR/lib/str.sh"
source "$SYS_DIR/lib/io.sh"
source "$SYS_DIR/lib/colors.sh"

colors::colorized

source "$SYS_DIR/lib/logger.sh"

LOGFILE="/tmp/syslog_example.log"
LOG_LEVEL=$LOGGER_DEBUG
PID=$$

touch $LOGFILE

io::title "Logger example"

io::writeln "Se escribe en el archivo :: ${GREEN}$(log::filename)${NC}"
io::writeln "Nivel de erbosidad DEBUG"

log::emergency "Mensaje tipo emergencia"
log::alert "Mensaje tipo alert"
log::critical "Mensaje tipo critical"
log::error "Mensaje tipo error"
log::warning "Mensaje tipo warnig"
log::notice "Mensaje tipo notice"
log::informational "Mensaje tipo info"
log::debug "Mensaje tipo debug"
log::err "Mensaje tipo error"
log::info "Mensaje tipo info"
log::crit "Mensaje tipo critico"
log::warn "Mensaje tipo warning"

io::writeln "Se modifica el nivel de verbosidad a ${RED}ERROR${NC}"

LOG_LEVEL=$LOGGER_ERROR
log::emergency "====================================="
log::emergency "Mensaje tipo emergencia"
log::alert "Mensaje tipo alert"
log::critical "Mensaje tipo critical"
log::error "Mensaje tipo error"
log::warning "Mensaje tipo warnig"
log::notice "Mensaje tipo notice"
log::informational "Mensaje tipo info"
log::debug "Mensaje tipo debug"

function log::filename() {
    echo "/tmp/logger_change_example.log"
}

io::writeln "Se modifica el archivo de logeo"
io::writeln "Se escribe en el archivo :: ${GREEN}$(log::filename)${NC}"
io::writeln "Nivel de verbosidad NOTICE"

LOG_LEVEL=$LOGGER_NOTICE
log::emergency "====================================="
log::emergency "Mensaje tipo emergencia"
log::alert "Mensaje tipo alert"
log::critical "Mensaje tipo critical"
log::error "Mensaje tipo error"
log::warning "Mensaje tipo warnig"
log::notice "Mensaje tipo notice"
log::informational "Mensaje tipo info"
log::debug "Mensaje tipo debug"
