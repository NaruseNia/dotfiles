if status is-interactive
    # Commands to run in interactive sessions can go here
end

#PATH
set PATH $HOME/.cargo/bin usr/bin usr/local/bin /home/linuxbrew/.linuxbrew/bin/ /home/linuxbrew/.linuxbrew/bin/fish $PATH
set PARCOL peco

#ALIASES
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
set fish_color_command bryellow
set fish_color_error red
set fish_color_quote brcyan
set fish_color_param yellow
set fish_color_operator brpurple

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
