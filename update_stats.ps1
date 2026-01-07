$files = @("index.html", "qui-sommes-nous.html", "services.html", "equipement.html", "devis.html", "contact.html")

foreach ($file in $files) {
    $path = Join-Path "e:\TangerWebSite\highspeed_sarl" $file
    if (Test-Path $path) {
        $content = Get-Content $path -Raw
        
        # 1. Update Footer KM/an (2500000 -> 850000)
        # We look for the span with data-to="2500000"
        $content = $content -replace 'data-to="2500000"', 'data-to="850000"'

        # 2. Update Footer CLIENTS SATISFAITS (1500 -> 600)
        # We look for the span with data-to="1500"
        # We also want to append "+" if not present, but simple replacement is safer first.
        # Let's replace the whole logical block if we can find a unique string.
        # '<span data-from="0" data-to="1500"' -> '<span data-from="0" data-to="600"'
        $content = $content -replace 'data-to="1500"', 'data-to="600"'
        
        # 3. Update "Collaborateurs" (35 -> 34) in index.html main section
        if ($file -eq "index.html") {
            # Provide specific context to avoid changing other 35s if any
            # The line is usually: <div class="counter counter-lined"><span data-from="0" data-to="35"
            $content = $content -replace 'data-to="35"([\s\S]*?)></span>\+', 'data-to="34"$1></span>+'
        }
        
        # 4. Try to append "+" to footer Clients 600 if requested. 
        # The user wanted "600+", so let's try to add it.
        # in footer: <div class="counter counter-small"><span data-from="0" data-to="600" ... ></span></div>
        # Regex to find the footer client counter and add + if missing
        # We search for data-to="600" followed by closing span and div, specifically in footer-like context (counter-small)
        # Note: We must be careful not to double add +.
        
        # This regex matches the span end and adding + before the div close
        # <span data-from="0" data-to="600" ... ></span></div>
        # We want: ... ></span>+</div>
        
        # Only target lines with 'counter-small' and 'data-to="600"' to avoid affecting main section if it differs
        # Splitting by lines might be safer for this specific edit
        $lines = $content -split "`r`n"
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match 'class="counter counter-small"' -and $lines[$i] -match 'data-to="600"') {
                if ($lines[$i] -notmatch '</span>\+</div>') {
                     $lines[$i] = $lines[$i] -replace '</span></div>', '</span>+</div>'
                }
            }
        }
        $content = $lines -join "`r`n"

        Set-Content -Path $path -Value $content -Encoding UTF8
        Write-Host "Updated $file"
    }
}
