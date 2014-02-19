# /etc/zsh/zprofile overwrites stuff set in .zshenv
# # this is kind of a hack, but not that big of a deal
[[ -e /etc/zsh/zprofile ]] && source $HOME/.zshenv
