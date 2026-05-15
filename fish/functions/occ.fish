function occ -d "Run opencode with cheap context (one-off, doesn't change default)"
    # Save current context
    set -l config_dir "$HOME/.config/opencode"
    set -l current_ctx (occtx 2>/dev/null | head -1)
    
    # Switch to cheap temporarily
    occtx cheap >/dev/null 2>&1
    
    # Run opencode with args
    opencode $argv
    
    # Restore previous context
    if test -n "$current_ctx"
        echo "$current_ctx" | grep -q "cheap\|expensive" && occtx "$current_ctx" >/dev/null 2>&1
    end
end
