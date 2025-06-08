if status is-interactive
  fish_add_path /home/linuxbrew/.linuxbrew/bin
  fish_add_path /home/linuxbrew/.linuxbrew/sbin
  fish_add_path /home/zerg/go/bin/gopls
  set -gx EDITOR nvim
  set -gx MANPAGER "nvim +Man!"
  set -U fish_greeting
end

function fish_prompt
  set -l last_stat $status
  set -l stat

  set_color --bold blue
  echo -n (prompt_pwd)

  set -g __fish_git_prompt_showdirtystate 1
  set -g __fish_git_prompt_showuntrackedfiles 1
  set -g __fish_git_prompt_char_untrackedfiles '#'
  set_color --bold yellow
  echo -n (fish_git_prompt)

  if test $last_stat -ne 0
    set_color red --bold
    set stat $last_stat
    echo -n " $stat"
  end

  set_color --bold normal
  echo -n " > "
end

function fish_right_prompt
  if test $CMD_DURATION -gt 0
    set exec_time (math $CMD_DURATION / 1000)
    set_color normal
    echo -n "[$exec_time]"
    set_color normal
  end
end

