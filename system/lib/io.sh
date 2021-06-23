#!/bin/bash

function io::title() {
  local -r _title=$1
  local _color=$2

  if [[ -z $_color ]];then
    _color="orange"
  fi

  local _underline=$(str::repeat "=" $(str::len "$_title" ))
  
  io::colorized "$_color"
  io::newline
  io::writeln "$_title"
  io::writeln "$_underline"
  io::newline
  io::colorized
}

function io::comment() {
  local -r _message=$1

  io::colorized "blue"
  io::writeln "${_message}"
  io::colorized
}

function io::success(){
  local -r _message=$1

  io::colorized "green"
  io::writeln "${_message}"
  io::colorized
}

function io::error() {
  local -r _message=$1
  io::writeln "${_message}"
}

function io::warning(){
  local -r _message=$1
  io::writeln "${_message}"
}

function io::note(){
  local -r _message=$1

  io::writeln "${_message}"
}

function io::caution(){
  local -r _message=$1

  io::writeln "${_message}"
}

function io::list::title() {
  local -r _message=$1
  io::writeln "➜  ${_message}"
}

function io::list() {
  local -r _icon=$1
  local -r _message=$2
  local -r _level=$3
  
  io::writeln "  ${_icon} ${_message}"
}

function io::list::ul() {
  local -r _message=$1
  local -r _level=$2

  io::list "•" "$_message"
}

function io::list::li() {
  local -r _message=$1
  local -r _level=$2

  io::list "-" "$_message"
}

function io::list::error() {
  local -r _message=$1
  local -r _level=$2
 
  io::list "✘" "$_message"
}

function io::list::success() {
  local -r _message=$1
  local -r _level=$2

  io::list "✔︎" "$_message"
}

function io::writeln() {
  local -r _message=$1
  local -r _level=$2

  io::write "${_message}" "${_level}"
  io::newline
}

function io::write () {
  local -r _message=$1

  printf "${_message}"
  
}

function io::newline(){
  printf "\n"
}

function io::hr() {
  local -r _color=$1
  
  local _line=$(str::repeat "=" 120)

  io::colorized "$_color"
  io::writeln "$_line"
  io::colorized
}

function io::colorized() {
  local -r _color=$1

  case $_color in
        "yellow") printf "${YELLOW}";;
         "green") printf "${GREEN}";;
           "red") printf "${RED}";;
          "blue") printf "${BLUE}";;
    "light_blue") printf "${LIGHT_BLUE}";;
          "cyan") printf "${CYAN}";;
        "orange") printf "${ORANGE}";;
          "teal") printf "${TEAL}";;
          "pink") printf "${PINK}";;
          "gray") printf "${GRAY}";;
      "log_gray") printf "${LOG_GRAY}";;
    "light_gray") printf "${LIGHT_GRAY}";;
       "magenta") printf "${MAGENTA}";;
               *) printf "${NC}";;
  esac
}

# https://unix.stackexchange.com/questions/311329/bash-output-array-in-table
function io::table() {
  perl -MText::ASCIITable -e '
    $t = Text::ASCIITable->new({drawRowLine => 1});
    while (defined($c = shift @ARGV) and $c ne "--") {
      push @header, $c;
      $cols++
    }
    $t->setCols(@header);
    $rows = @ARGV / $cols;
    for ($i = 0; $i < $rows; $i++) {
      for ($j = 0; $j < $cols; $j++) {
        $cell[$i][$j] = $ARGV[$j * $rows + $i]
      }
    }
    $t->addRow(\@cell);
    print $t' -- "$@"

    # example
    #io::table Domain 'Without WWW'    'With WWW' -- \
    #        "$@"   "${WOUT_WWW[@]}" "${WITH_WWW[@]}"

}

function io::ask() {
  local -r _ask=$1

  local _response
  read -r -p "${_ask}" _response

  echo "$_response"
}

function io::progressBar() {
  echo ""
}

#
# Aliases ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
alias io::text='io::write'

#echo "✘ ✔︎ ∴ → ☿ ★ ⇒ ⤵ ↴ ⋅ ፠ ᰾ ⦒ 𐮚 𐮙 𖬺 𑗕 ⸙ ⁘ ⁙ ᛭ ¶ * ↦ ⇶ ⇒ ⇔ ⇢ ♲ ✘ ✗ ✕ ✔ ✆ ✉ ⛃ ⛁ 🗭 🗩 🗑 🗝 🗎 🗀 🖧 🖥 🖪 🖒 🖓 🖴 🖫 🗲 ✸ % @ 🗬 ⁚ ⁛ ⁝ ⁖ ⋅ ∙ ⇂ ⇄ ⇆  • ☹ ☺ ☢ ☐ ☑ ☒ $ ＄ ﹩ ∙ ∙ ❯ ❮ ❱ ❰  〔 〕 ⸏⸏"
#tput cols

#export RED=$(tput setaf 1 :-"" 2>/dev/null)
#export GREEN=$(tput setaf 2 :-"" 2>/dev/null)
#export YELLOW=$(tput setaf 3 :-"" 2>/dev/null)
#export BLUE=$(tput setaf 4 :-"" 2>/dev/null)
#export RESET=$(tput sgr0 :-"" 2>/dev/null)

#echo $GREEN some text $RESET
#echo $RED; printf -- "-%.0s" $(seq $(tput cols)); echo $RESET
#echo $YELLOW''more' 'text''$RESET

#echo $RED''" more text "$RESET
