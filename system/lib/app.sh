#!/bin/bash

function app::version() {
  echo "${APP_NAME}#${APP_VERSION}"
  echo "${APP_DESCRIPTION}"
}

function app::installed_version() {
  if ( which $APP_NAME > /dev/null 2>&1 ); then
    echo "$($(which $APP_NAME --version) 2>&1 | awk '{print $3}')"
  else
    echo "Nope"
  fi
}

