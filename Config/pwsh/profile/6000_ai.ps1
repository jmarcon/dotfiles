if ($ENV:PROFILE_DEBUG -eq $true) {
    Write-Host 'Loading AI Functions'
}

if(Get-Command "npx" -ErrorAction SilentlyContinue) {
    # If the command exists, create a new alias
    function gemini {
        if ($args.Count -eq 0) {
            npx @google/gemini-cli
        } else {
            npx @google/gemini-cli $args
        }
    }

    function claude {
        if ($args.Count -eq 0) {
            npx @anthropic-ai/claude-code
        } else {
            npx @anthropic-ai/claude-code $args
        }
    }
}