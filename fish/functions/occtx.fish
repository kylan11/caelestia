function occtx -d "Switch OhMyOpenCode context (cheap|expensive)"
    set -l config_dir "$HOME/.config/opencode"
    set -l contexts cheap expensive
    
    # Show current context if no args
    if test (count $argv) -eq 0
        if test -f "$config_dir/current-context"
            cat "$config_dir/current-context"
        else
            echo "cheap (default)"
        end
        return 0
    end
    
    set -l target $argv[1]
    
    # Validate context name
    if not contains $target $contexts
        echo "Error: Invalid context '$target'" >&2
        echo "Valid contexts: "(string join " " $contexts) >&2
        return 1
    end
    
    # Check if context config exists
    set -l source_file "$config_dir/contexts/$target/oh-my-openagent.json"
    if not test -f "$source_file"
        echo "Error: Context config not found at $source_file" >&2
        echo "Run install.sh to set up contexts" >&2
        return 1
    end
    
    # Swap config
    cp "$source_file" "$config_dir/oh-my-openagent.json"
    echo "$target" > "$config_dir/current-context"
    
    echo "Switched to '$target' context"
    
    # Show primary models for this context
    switch $target
        case cheap
            echo "Primary: opencode-go/kimi-k2.6, opencode-go/glm-5.1, opencode-go/qwen3.5-plus"
        case expensive
            echo "Primary: github-copilot/claude-opus-4.8, github-copilot/gpt-5.5, github-copilot/gpt-5.4-mini"
    end
end
