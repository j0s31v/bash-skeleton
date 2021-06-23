#!/bin/bash

if [[ ! -v colors::colorized ]]; then
  
  function colors::colorized() {
    
    # Colores de texto
    readonly NC=$'\e[0m'
    readonly YELLOW=$'\e[38;5;220m'
    readonly GREEN=$'\e[32m'
    readonly RED=$'\e[31m'
    readonly BLUE=$'\e[34m'
    readonly LIGHT_BLUE=$'\e[38;5;159m'
    readonly CYAN=$'\e[38;5;51m'
    readonly ORANGE=$'\e[38;5;208m'
    readonly TEAL=$'\e[38;5;192m'
    readonly PINK=$'\e[38;5;212m'
    readonly GRAY=$'\e[38;5;246m'
    readonly LOG_GRAY=$'\e[38;5;240m'
    readonly LIGHT_GRAY=$'\e[38;5;242m'
    readonly MAGENTA=$'\e[38;5;219m'

    # Colores en Background
  }

fi
