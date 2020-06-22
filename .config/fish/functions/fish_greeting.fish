function fish_greeting
  set -x PATH $HOME/bin $PATH
  if type -q screenfetch
    screenfetch -n -c '4:1'
  end
end
