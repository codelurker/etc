# Set options
setopt                       \
     NO_all_export           \
        always_last_prompt   \
     NO_always_to_end        \
        append_history       \
        auto_cd              \
        auto_list            \
        auto_menu            \
     NO_auto_name_dirs       \
        auto_param_keys      \
        auto_param_slash     \
        auto_pushd           \
        auto_remove_slash    \
     NO_auto_resume          \
        bad_pattern          \
        bang_hist            \
     NO_beep                 \
     NO_brace_ccl            \
        correct_all          \
     NO_bsd_echo             \
        cdable_vars          \
     NO_chase_links          \
     NO_clobber              \
        complete_aliases     \
        complete_in_word     \
     NO_correct              \
        correct_all          \
        csh_junkie_history   \
     NO_csh_junkie_loops     \
     NO_csh_junkie_quotes    \
     NO_csh_null_glob        \
        equals               \
        extended_glob        \
        extended_history     \
        function_argzero     \
        glob                 \
     NO_glob_assign          \
        glob_complete        \
     NO_glob_dots            \
        glob_subst           \
        hash_cmds            \
        hash_dirs            \
        hash_list_all        \
        hist_allow_clobber   \
        hist_beep            \
        hist_ignore_dups     \
        hist_ignore_space    \
     NO_hist_no_store        \
        hist_verify          \
     NO_hup                  \
     NO_ignore_braces        \
     NO_ignore_eof           \
        interactive_comments \
        ksh_glob             \
     NO_list_ambiguous       \
     NO_list_beep            \
        list_types           \
        long_list_jobs       \
        magic_equal_subst    \
     NO_mail_warning         \
     NO_mark_dirs            \
     NO_menu_complete        \
        multios              \
        nomatch              \
        notify               \
     NO_null_glob            \
        numeric_glob_sort    \
     NO_overstrike           \
        path_dirs            \
        posix_builtins       \
     NO_print_exit_value     \
     NO_prompt_cr            \
        prompt_subst         \
        pushd_ignore_dups    \
        pushd_minus          \
        pushd_silent         \
        pushd_to_home        \
        rc_expand_param      \
     NO_rc_quotes            \
     NO_rm_star_silent       \
        share_history        \
     NO_sh_file_expansion    \
        sh_option_letters    \
        short_loops          \
        sh_word_split        \
     NO_single_line_zle      \
     NO_sun_keyboard_hack    \
        unset                \
     NO_verbose              \
        zle                  \
        hist_expire_dups_first  \
        hist_ignore_all_dups    \
     NO_hist_no_functions       \
     NO_hist_save_no_dups       \
        hist_reduce_blanks      \
        inc_append_history      \
        list_packed             \
     NO_rm_star_wait            \

# Save a large history
HISTFILE=~/.zshhistory
HISTSIZE=3000
SAVEHIST=3000
export HISTCONTROL=ignoredupes

# Put my source dirs on the cd path
cdpath=( ~ ~/ecn/source ~/ecn/source/cpp ~/ecn/source/python ~/ecn/source/sql ~/ecn/source/python/mtf/prog)

# Setup my login/logout watch list
watch=( notme )

# Set up new advanced completion system
autoload -U compinit
compinit -C

# Setup the prompt
autoload -U promptinit && promptinit
prompt adam1
 
# Not sure why this is needed here but completion whinges without it!
autoload _suffix_alias_files

# Turn on completion cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Add the hostnames from ~/.ssh/known_hosts to hosts
#local _myhosts
#_myhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
#zstyle ':completion:*' hosts $_myhosts

# Prevent CVS files/directories from being completed
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'

# Users completer add lot's of uninteresting user accounts, remove them
zstyle ':completion:*:*:*:users' ignored-patterns \
    adm apache bin daemon games gdm halt ident junkbust lp mail mailnull \
    named news nfsnobody nobody nscd ntp operator pcap postgres radvd \
    rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs backup  bind  \
    dictd  gnats  identd  irc  man  messagebus  postfix  proxy  sys  www-data

# Completing process IDs with menu selection
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

# If you end up using a directory as argument, this will remove the trailing
# slash (useful in ln)
zstyle ':completion:*' squeeze-slashes true

# Perty ls listings, with better visibility on a dark background
[[ -e ~/etc/ls_colors ]] && source ~/etc/ls_colors 

# Aliases

alias 1="cd ~1"
alias 2="cd ~2"
alias 3="cd ~3"
alias 4="cd ~4"
alias 5="cd ~5"
alias 6="cd ~6"
alias 7="cd ~7"
alias 8="cd ~8"
alias rl="source ~/.zshrc"
alias d="dirs -v"
alias psg="ps -elf | grep $*"
alias e="emacsclient --no-wait $*"
alias et="emacsclient -t -a vim $*"
alias ec="emacsclient -c -a vim $*"
alias ls="ls --color"
alias bats="sudo vpnc --enable-1des ~/etc/25CA.conf"
alias h="history"
alias hg="history | grep $*"
alias l="ls -lrt"
alias la="ls -a"
alias ll="ls -l"

# No spelling correction (we have correct_all option set)
alias man='nocorrect man'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
alias info='nocorrect info'
alias svn='nocorrect svn'
alias git='nocorrect git'
alias cvs='nocorrect cvs'
alias ipython='nocorrect ipython'
alias grin='nocorrect grin'

export EDITOR='emacsclient -c -a vim'

# Local environment

[[ -e ~/.zshrc.local ]] && source ~/.zshrc.local

