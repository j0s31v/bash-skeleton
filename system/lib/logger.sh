#!/bin/bash

# LOGGER
# Se basa en el rfc5424
# https://tools.ietf.org/html/rfc5424
# 0       Emergency: system is unusable
# 1       Alert: action must be taken immediately
# 2       Critical: critical conditions
# 3       Error: error conditions
# 4       Warning: warning conditions
# 5       Notice: normal but significant condition
# 6       Informational: informational messages
# 7       Debug: debug-level messages
#

if [[ ! -v __LIB_SYSLOG_IS_LOADED ]]; then
  readonly __LIB_SYSLOG_IS_LOADED=true

  readonly     LOGGER_EMERGENCY=0
  readonly         LOGGER_ALERT=1
  readonly      LOGGER_CRITICAL=2
  readonly         LOGGER_ERROR=3
  readonly       LOGGER_WARNING=4
  readonly        LOGGER_NOTICE=5
  readonly LOGGER_INFORMATIONAL=6
  readonly         LOGGER_DEBUG=7

fi

function syslog::name() {
  local -r _level=$1

  case $_level in
        $LOGGER_EMERGENCY) echo 'emergency';;
            $LOGGER_ALERT) echo 'alert';;
         $LOGGER_CRITICAL) echo 'critical';;
            $LOGGER_ERROR) echo 'error';;
          $LOGGER_WARNING) echo 'warning';;
           $LOGGER_NOTICE) echo 'notice';;
    $LOGGER_INFORMATIONAL) echo 'informational';;
                        *) echo 'debug';;
  esac
}

function syslog::template() {
  local -r _level=$1

  case $_level in
        $LOGGER_EMERGENCY) echo '[EMER]';;
            $LOGGER_ALERT) echo '[ALRT]';;
         $LOGGER_CRITICAL) echo '[CRIT]';;
            $LOGGER_ERROR) echo '[ERNO]';;
          $LOGGER_WARNING) echo '[WARN]';;
           $LOGGER_NOTICE) echo '[NOTI]';;
    $LOGGER_INFORMATIONAL) echo '[INFO]';;
                        *) echo '[DEBG]';;
          
  esac
}

function logger() {
  local -r _message=$1
  local -r _level=$2

  local _prefix=$(log::prefix $_level)
  
  if [[ $DEBUGGER == 1 || $_level -le $LOG_LEVEL ]]; then
    echo -e "${_prefix} ${_message}" >> $(log::filename)
  fi
}

function log() {
  local -r _level=$1
  local -r _message=$2

  logger "$_message" "$_level"
}

if [[ ! -v log::prefix ]]; then
  function log::prefix() {
    local -r _level=$1

    local _date=$(date +%s)
    local _tmpl_syslog=$(syslog::template $_level)

    echo  "[${_date}][${PID}]${_tmpl_syslog}"
  }
fi

if [[ ! -v log::filename ]]; then
  function log::filename() {
    echo "$LOGFILE"
  }
fi

# Aliases ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
alias log::emergency="log $LOGGER_EMERGENCY"
alias log::alert="log $LOGGER_ALERT"
alias log::critical="log $LOGGER_CRITICAL"
alias log::error="log $LOGGER_ERROR"
alias log::warning="log $LOGGER_WARNING"
alias log::notice="log $LOGGER_NOTICE"
alias log::informational="log $LOGGER_INFORMATIONAL"
alias log::debug="log $LOGGER_DEBUG"
  
alias log::err='log::error'
alias log::info='log::informational'
alias log::crit='log::critical'
alias log::warn='log::warning'
