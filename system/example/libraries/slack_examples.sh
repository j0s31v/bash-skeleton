#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
SYS_DIR="$DIR/../../"

source "$SYS_DIR/lib/str.sh"
source "$SYS_DIR/lib/io.sh"
source "$SYS_DIR/lib/colors.sh"

colors::colorized

source "$SYS_DIR/lib/slack.sh"

readonly SLACK_WEBHOOK="https://hooks.slack.com/services/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"
readonly SLACK_SENDER_NAME="user example"
readonly SLACK_SENDER_ICON=":fire:"

io::title "Ejemplo envio slack"

slack::send::message "#general" "*holamundo*"

slack::attach "lorem"
slack::attach "ipsum"
slack::attach "dolor"
slack::attach "sit ammet"
slack::send::attach "#general" "titulo *sdfsdfsd*" "error" 

slack::attach "lorem"
slack::attach "ipsum"
slack::attach "dolor"
slack::attach "sit ammet"
slack::send::attach "#general" "" "warning" "lodf"

slack::send::attach "#general" "" "warning" 
