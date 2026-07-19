# Source after `eval "$(starship init zsh)"` to redraw completed prompts.
# This hook owns its ZLE integration; no external transience plugin is needed.
starship_transient_prompt_func() {
  local prompt_status=${1:-0}
  starship module character --status "$prompt_status"
}

starship_transient_prompt_zle_line_init() {
  emulate -L zsh

  [[ $CONTEXT == start ]] || return 0

  while true; do
    zle .recursive-edit
    local -i result=$?
    [[ $result == 0 && $KEYS == $'\4' ]] || break
    [[ -o ignore_eof ]] || exit 0
  done

  local saved_prompt=$PROMPT
  local saved_rprompt=$RPROMPT
  local prompt_status=${STARSHIP_CMD_STATUS:-0}
  PROMPT='$(starship_transient_prompt_func '"$prompt_status"')'
  RPROMPT=''
  zle .reset-prompt
  PROMPT=$saved_prompt
  RPROMPT=$saved_rprompt

  if (( result )); then
    zle .send-break
  else
    zle .accept-line
  fi
  return $result
}

enable_transience() {
  zle -N zle-line-init starship_transient_prompt_zle_line_init
}

enable_transience
