#!/bin/bash

# https://github.com/tprasadtp/ubuntu-post-install/blob/master/after-effects
function parse_yaml() {
  local -r _yaml_file="${1}"
  local -r _prefix="${2}"
  
  local s='[[:space:]]*'
  local w='[a-zA-Z0-9_.-]*'
  local fs="$(echo @|tr @ '\034')"

  (
    #shellcheck disable=SC1003
    sed -e '/- [^\"]'"[^\']"'.*: /s|\([ ]*\)- \([[:space:]]*\)|\1-\'$'\n''  \1\2|g' |

    sed -ne '/^--/s|--||g; s|\"|\\\"|g; s/[[:space:]]*$//g;' \
        -e "/#.*[\"\']/!s| #.*||g; /^#/s|#.*||g;" \
        -e "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)${s}[:-]$s\(.*\)$s\$|\1$fs\2$fs\3|p" |

    awk -F"$fs" '{
        indent = length($1)/2;
        if (length($2) == 0) { conj[indent]="+";} else {conj[indent]="";}
        vname[indent] = $2;
        for (i in vname) {if (i > indent) {delete vname[i]}}
            if (length($3) > 0) {
                vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
                printf("%s%s%s%s=(\"%s\")\n", "'"$_prefix"'",vn, $2, conj[indent-1],$3);
            }
        }' |
        sed -e 's/_=/+=/g' |
        awk 'BEGIN {
                FS="=";
                OFS="="
            }
            /(-|\.).*=/ {
                gsub("-|\\.", "_", $1)
            }
            { print }'
  ) < "$_yaml_file"
}
