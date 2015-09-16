parse_ini() {
  local var val section
  local system_sed=$(which sed)
  local safe_name_replace='s/[ 	]*$//;s/[^a-zA-Z0-9_]/_/g'
  cat ${1:--} | \
    $system_sed '/^[ 	]*#/d;/^[ 	]*$/d' | \
    while IFS="= " read var val; do
      case "$var" in
        \[*])
          if [[ -n "$section" ]]; then echo "}"; fi
          section=$(echo "${var:1:${#var}-2}" | "$system_sed" "$safe_name_replace")
          section="${section#"${section%%[![:space:]]*}"}"
          section="${section%"${section##*[![:space:]]}"}"
          echo "config.section.${section}() {"
          ;;
        *)
          var=$(echo "$var" | "$system_sed" "$safe_name_replace")
          var="${var#"${var%%[![:space:]]*}"}"
          var="${var%"${var##*[![:space:]]}"}"
          echo "  $var=$val"
          ;;
      esac
    done
  echo "}"
}

config_parser() {
  eval "$(parse_ini $1)"
}
