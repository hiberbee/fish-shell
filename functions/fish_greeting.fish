set -x $PATH $HOME/bin $PATH

function fish_greeting
  if type -q screenfetch
    screenfetch -n -c '4:1'
  end
end
