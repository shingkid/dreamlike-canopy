# Source after `eval "$(starship init zsh)"` to redraw completed prompts.
# The character module preserves Starship's success/error coloring.
starship_transient_prompt_func() {
  starship module character
}

enable_transience
