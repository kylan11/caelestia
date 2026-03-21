
if status is-interactive
    # Starship custom prompt
    starship init fish | source

    # Direnv + Zoxide
    command -v direnv &> /dev/null && direnv hook fish | source
    command -v zoxide &> /dev/null && zoxide init fish --cmd cd | source

    # Better ls
    alias ls='eza --icons --group-directories-first -1'

    # Abbrs
    abbr lg 'lazygit'
    abbr gd 'git diff'
    abbr ga 'git add .'
    abbr gc 'git commit -am'
    abbr gl 'git log'
    abbr gs 'git status'
    abbr gst 'git stash'
    abbr gsp 'git stash pop'
    abbr gp 'git push'
    abbr gpl 'git pull'
    abbr gsw 'git switch'
    abbr gsm 'git switch main'
    abbr gb 'git branch'
    abbr gbd 'git branch -d'
    abbr gco 'git checkout'
    abbr gsh 'git show'

    abbr l 'ls'
    abbr ll 'ls -l'
    abbr la 'ls -a'
    abbr lla 'ls -la'

    export OLLAMA_API_BASE="http://127.0.0.1:11434"
    export OLLAMA_API_KEY="ollama-local"
    export POETRY_HTTP_BASIC_DEVAIS_USERNAME=pypi
    export POETRY_HTTP_BASIC_DEVAIS_PASSWORD=glpat-gK2J88GBEVmscq7DzgGylm86MQp1OjJsenJpCw.01.1218tyt21
    # Custom colours
    cat ~/.local/state/caelestia/sequences.txt 2> /dev/null

    # For jumping between prompts in foot terminal
    function mark_prompt_start --on-event fish_prompt
        echo -en "\e]133;A\e\\"
    end
    set -gx AWS_PROFILE dbridge
    set -gx AWS_REGION eu-west-1
    set -gx AWS_TARGET_ROLE admin
    set -gx ATMOS_BASE_PATH /home/kylan11/projects/infrastructure
    set -gx ATMOS_CLI_CONFIG_PATH /home/kylan11/projects/infrastructure
    set -gx INFRA_ORDER_FILE /home/kylan11/projects/cli/.infra-order
    set -gx WEB_APPS concierge,customer,provider
    set -gx WEB_PATH /home/kylan11/projects/web
    set -gx OBSIDIAN_USE_WAYLAND 1
    set -gx OPENROUTER_API_KEY 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

    # Aliases
    alias tpt 'echo -e "terraform plan $(terraform plan -no-color | grep -E "create|destroyed|replaced|updated" | grep "#" | sed \'s/  # /-target=/g\' | sed \'s/ [will|must].*/ \\/g\')" | sed -z \'s/..$//\''
    alias tpd 'terraform plan | grep -E "create|destroyed|replaced|updated|moved|desired_count|image" | grep -E "#|desired_count|image"'
    alias gitf 'git fetch --all --tags && git branch -v | grep \'[gone]\' | awk \'{print $1}\' | tr \'\n\' \'\0\' | xargs -r -0 git branch -D && git branch -vv'
    alias gitp 'gitf && git pull'
    alias gitclean 'bash ~/.local/bin/git-clean-orphan-branches.sh'

    alias scale_up_uat 'cd ~/projects/infrastructure-v1/aws/scripts; ENV=uat TENANTS=dbridge make scale_up'
    alias scale_up_uat_baps 'cd ~/projects/infrastructure-v1/aws/scripts; ENV=uat TENANTS=bapr make scale_up'
    alias scale_up_uat_bp 'cd ~/projects/infrastructure-v1/aws/scripts; ENV=uat TENANTS=bp make scale_up'
    alias scale_up_test 'cd ~/projects/infrastructure-v1/aws/scripts; ENV=test TENANTS=dbridge make scale_up'
    alias scale_up_test_baps 'cd ~/projects/infrastructure-v1/aws/scripts; ENV=test TENANTS=bapr make scale_up'
    alias scale_up_test_bp 'cd ~/projects/infrastructure-v1/aws/scripts; ENV=test TENANTS=bp make scale_up'
    alias scale_down_uat 'cd ~/projects/infrastructure-v1/aws/scripts; ENV=uat TENANTS=dbridge make scale_down'
    alias scale_down_uat_baps 'cd ~/projects/infrastructure-v1/aws/scripts; ENV=uat TENANTS=bapr make scale_down'
    alias scale_down_uat_bp 'cd ~/projects/infrastructure-v1/aws/scripts; ENV=uat TENANTS=bp make scale_down'
    alias scale_down_test 'cd ~/projects/infrastructure-v1/aws/scripts; ENV=test TENANTS=dbridge make scale_down'
    alias scale_down_test_bp 'cd ~/projects/infrastructure-v1/aws/scripts; ENV=test TENANTS=bp make scale_down'
    alias scale_down_test_baps 'cd ~/projects/infrastructure-v1/aws/scripts; ENV=test TENANTS=baps make scale_down'

    alias kss 'aws eks update-kubeconfig --name sandbox-shared-cluster --region eu-west-1 --profile sandbox-shared'
    alias ksd 'aws eks update-kubeconfig --name staging-deeptier-cluster --region eu-west-1 --profile staging-deeptier'

    alias ff fastfetch
    alias xclip 'xclip -selection c'
    alias vpn 'sudo -n /usr/bin/openvpn --config /home/kylan11/francesco.lauritano-dbridge-root-vpn.ovpn'
    alias fattura 'cd ~/freelance/calc_scadenze_pagamenti; python main.py'
    alias work 'bash ~/.config/hypr/scripts/work.sh'
    alias k kubectl
    alias mk minikube
    alias hf helmfile
end

# fish completion for dbridge                              -*- shell-script -*-
function __dbridge_debug
    set -l file "$BASH_COMP_DEBUG_FILE"
    if test -n "$file"
        echo "$argv" >> $file
    end
end

function __dbridge_perform_completion
    __dbridge_debug "Starting __dbridge_perform_completion"

    # Extract all args except the last one
    set -l args (commandline -opc)
    # Extract the last arg and escape it in case it is a space
    set -l lastArg (string escape -- (commandline -ct))

    __dbridge_debug "args: $args"
    __dbridge_debug "last arg: $lastArg"

    # Disable ActiveHelp which is not supported for fish shell
    set -l requestComp "DBRIDGE_ACTIVE_HELP=0 $args[1] __complete $args[2..-1] $lastArg"

    __dbridge_debug "Calling $requestComp"
    set -l results (eval $requestComp 2> /dev/null)

    # Some programs may output extra empty lines after the directive.
    # Let's ignore them or else it will break completion.
    # Ref: https://github.com/spf13/cobra/issues/1279
    for line in $results[-1..1]
        if test (string trim -- $line) = ""
            # Found an empty line, remove it
            set results $results[1..-2]
        else
            # Found non-empty line, we have our proper output
            break
        end
    end

    set -l comps $results[1..-2]
    set -l directiveLine $results[-1]

    # For Fish, when completing a flag with an = (e.g., <program> -n=<TAB>)
    # completions must be prefixed with the flag
    set -l flagPrefix (string match -r -- '-.*=' "$lastArg")

    __dbridge_debug "Comps: $comps"
    __dbridge_debug "DirectiveLine: $directiveLine"
    __dbridge_debug "flagPrefix: $flagPrefix"

    for comp in $comps
        printf "%s%s\n" "$flagPrefix" "$comp"
    end

    printf "%s\n" "$directiveLine"
end

# this function limits calls to __dbridge_perform_completion, by caching the result behind $__dbridge_perform_completion_once_result
function __dbridge_perform_completion_once
    __dbridge_debug "Starting __dbridge_perform_completion_once"

    if test -n "$__dbridge_perform_completion_once_result"
        __dbridge_debug "Seems like a valid result already exists, skipping __dbridge_perform_completion"
        return 0
    end

    set --global __dbridge_perform_completion_once_result (__dbridge_perform_completion)
    if test -z "$__dbridge_perform_completion_once_result"
        __dbridge_debug "No completions, probably due to a failure"
        return 1
    end

    __dbridge_debug "Performed completions and set __dbridge_perform_completion_once_result"
    return 0
end

# this function is used to clear the $__dbridge_perform_completion_once_result variable after completions are run
function __dbridge_clear_perform_completion_once_result
    __dbridge_debug ""
    __dbridge_debug "========= clearing previously set __dbridge_perform_completion_once_result variable =========="
    set --erase __dbridge_perform_completion_once_result
    __dbridge_debug "Successfully erased the variable __dbridge_perform_completion_once_result"
end

function __dbridge_requires_order_preservation
    __dbridge_debug ""
    __dbridge_debug "========= checking if order preservation is required =========="

    __dbridge_perform_completion_once
    if test -z "$__dbridge_perform_completion_once_result"
        __dbridge_debug "Error determining if order preservation is required"
        return 1
    end

    set -l directive (string sub --start 2 $__dbridge_perform_completion_once_result[-1])
    __dbridge_debug "Directive is: $directive"

    set -l shellCompDirectiveKeepOrder 32
    set -l keeporder (math (math --scale 0 $directive / $shellCompDirectiveKeepOrder) % 2)
    __dbridge_debug "Keeporder is: $keeporder"

    if test $keeporder -ne 0
        __dbridge_debug "This does require order preservation"
        return 0
    end

    __dbridge_debug "This doesn't require order preservation"
    return 1
end


# This function does two things:
# - Obtain the completions and store them in the global __dbridge_comp_results
# - Return false if file completion should be performed
function __dbridge_prepare_completions
    __dbridge_debug ""
    __dbridge_debug "========= starting completion logic =========="

    # Start fresh
    set --erase __dbridge_comp_results

    __dbridge_perform_completion_once
    __dbridge_debug "Completion results: $__dbridge_perform_completion_once_result"

    if test -z "$__dbridge_perform_completion_once_result"
        __dbridge_debug "No completion, probably due to a failure"
        # Might as well do file completion, in case it helps
        return 1
    end

    set -l directive (string sub --start 2 $__dbridge_perform_completion_once_result[-1])
    set --global __dbridge_comp_results $__dbridge_perform_completion_once_result[1..-2]

    __dbridge_debug "Completions are: $__dbridge_comp_results"
    __dbridge_debug "Directive is: $directive"

    set -l shellCompDirectiveError 1
    set -l shellCompDirectiveNoSpace 2
    set -l shellCompDirectiveNoFileComp 4
    set -l shellCompDirectiveFilterFileExt 8
    set -l shellCompDirectiveFilterDirs 16

    if test -z "$directive"
        set directive 0
    end

    set -l compErr (math (math --scale 0 $directive / $shellCompDirectiveError) % 2)
    if test $compErr -eq 1
        __dbridge_debug "Received error directive: aborting."
        # Might as well do file completion, in case it helps
        return 1
    end

    set -l filefilter (math (math --scale 0 $directive / $shellCompDirectiveFilterFileExt) % 2)
    set -l dirfilter (math (math --scale 0 $directive / $shellCompDirectiveFilterDirs) % 2)
    if test $filefilter -eq 1; or test $dirfilter -eq 1
        __dbridge_debug "File extension filtering or directory filtering not supported"
        # Do full file completion instead
        return 1
    end

    set -l nospace (math (math --scale 0 $directive / $shellCompDirectiveNoSpace) % 2)
    set -l nofiles (math (math --scale 0 $directive / $shellCompDirectiveNoFileComp) % 2)

    __dbridge_debug "nospace: $nospace, nofiles: $nofiles"

    # If we want to prevent a space, or if file completion is NOT disabled,
    # we need to count the number of valid completions.
    # To do so, we will filter on prefix as the completions we have received
    # may not already be filtered so as to allow fish to match on different
    # criteria than the prefix.
    if test $nospace -ne 0; or test $nofiles -eq 0
        set -l prefix (commandline -t | string escape --style=regex)
        __dbridge_debug "prefix: $prefix"

        set -l completions (string match -r -- "^$prefix.*" $__dbridge_comp_results)
        set --global __dbridge_comp_results $completions
        __dbridge_debug "Filtered completions are: $__dbridge_comp_results"

        # Important not to quote the variable for count to work
        set -l numComps (count $__dbridge_comp_results)
        __dbridge_debug "numComps: $numComps"

        if test $numComps -eq 1; and test $nospace -ne 0
            # We must first split on \t to get rid of the descriptions to be
            # able to check what the actual completion will be.
            # We don't need descriptions anyway since there is only a single
            # real completion which the shell will expand immediately.
            set -l split (string split --max 1 \t $__dbridge_comp_results[1])

            # Fish won't add a space if the completion ends with any
            # of the following characters: @=/:.,
            set -l lastChar (string sub -s -1 -- $split)
            if not string match -r -q "[@=/:.,]" -- "$lastChar"
                # In other cases, to support the "nospace" directive we trick the shell
                # by outputting an extra, longer completion.
                __dbridge_debug "Adding second completion to perform nospace directive"
                set --global __dbridge_comp_results $split[1] $split[1].
                __dbridge_debug "Completions are now: $__dbridge_comp_results"
            end
        end

        if test $numComps -eq 0; and test $nofiles -eq 0
            # To be consistent with bash and zsh, we only trigger file
            # completion when there are no other completions
            __dbridge_debug "Requesting file completion"
            return 1
        end
    end

    return 0
end

# Since Fish completions are only loaded once the user triggers them, we trigger them ourselves
# so we can properly delete any completions provided by another script.
# Only do this if the program can be found, or else fish may print some errors; besides,
# the existing completions will only be loaded if the program can be found.
if type -q "dbridge"
    # The space after the program name is essential to trigger completion for the program
    # and not completion of the program name itself.
    # Also, we use '> /dev/null 2>&1' since '&>' is not supported in older versions of fish.
    complete --do-complete "dbridge " > /dev/null 2>&1
end

# Remove any pre-existing completions for the program since we will be handling all of them.
complete -c dbridge -e

# this will get called after the two calls below and clear the $__dbridge_perform_completion_once_result global
complete -c dbridge -n '__dbridge_clear_perform_completion_once_result'
# The call to __dbridge_prepare_completions will setup __dbridge_comp_results
# which provides the program's completion choices.
# If this doesn't require order preservation, we don't use the -k flag
complete -c dbridge -n 'not __dbridge_requires_order_preservation && __dbridge_prepare_completions' -f -a '$__dbridge_comp_results'
# otherwise we use the -k flag
complete -k -c dbridge -n '__dbridge_requires_order_preservation && __dbridge_prepare_completions' -f -a '$__dbridge_comp_results'
complete -k -c dbridge -n '__dbridge_requires_order_preservation && __dbridge_prepare_completions' -f -a '$__dbridge_comp_results'
