# bash-completion script for progress

_progress()
{
    local cur prev
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    case "${prev}" in
        progress)
            local options
            options="-q --quiet -d --debug -w --wait -W --wait-delay -m --monitor -M --monitor-continuously -a --additional-command -c --command -p --pid -i --ignore-file -o --open-mode -v --version -h --help"
            COMPREPLY=($(compgen -W "$options" -- "$cur"))
            return 0
            ;;
        -W|--wait-delay)
            COMPREPLY=()
            return 0
            ;;
        -o|--open-mode)
            COMPREPLY=($(compgen -W "r w" -- "$cur"))
            return 0
            ;;
        *)
            # Handle custom completions for specific options here if needed
            ;;
    esac
}

complete -F _progress progress
