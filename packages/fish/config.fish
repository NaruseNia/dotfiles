if status is-interactive
    # Commands to run in interactive sessions can go here
end

#PATH
set PATH $HOME/.cargo/bin usr/bin usr/local/bin /home/linuxbrew/.linuxbrew/bin/ /home/linuxbrew/.linuxbrew/bin/fish $PATH
set PARCOL peco

#ALIASES
alias pbcopy='clip.exe'
alias gq='cd (ghq root)/(ghq list | peco)'  
alias gcc=/home/linuxbrew/.linuxbrew/bin/gcc-11
alias g=git
alias bi='brew install'
alias def='cd /mnt/c/Users/notsh'
alias home='cd ~'
alias rl='exec $SHELL -l'
alias sai='sudo apt install'
alias nv='nvim'
alias ffp='fontforge -script ~/font-patcher/font-patcher'

#Color Settings for fish
set fish_color_command ffe599
set fish_color_error red
set fish_color_quote c9daf8
set fish_color_param fff2cc 
set fish_color_operator 8e7cc3
set fish_color_redirection 93c47d
set fish_color_escape c27ba0

#Run / Attach Tmux when start.
function attach_tmux_session_if_needed
    set ID (tmux list-sessions)
    if test -z "$ID"
        tmux new-session
        if type -t "nvim"
          nvim -c "q!"
        else if type -t "vim"
          vim -c "q!"
        end
        return
    end

    set new_session "Create New Session" 
    set ID (echo $ID\n$new_session | peco --on-cancel=error | cut -d: -f1)
    if test "$ID" = "$new_session"
        tmux new-session
    else if test -n "$ID"
        tmux attach-session -t "$ID"
    end
end

if test -z $TMUX && status --is-login
    attach_tmux_session_if_needed
end
fish_add_path /home/linuxbrew/.linuxbrew/sbin
