$files = @("index.html", "qui-sommes-nous.html", "services.html", "equipement.html", "devis.html", "contact.html")

foreach ($file in $files) {
    $path = Join-Path "e:\TangerWebSite\highspeed_sarl" $file
    if (Test-Path $path) {
        $content = Get-Content $path -Raw
        
        # Regex to find the footer client counter (data-to="600") and add + if valid
        # We look for data-to="600" followed by some attributes, ending with ></span></div>
        # And we ensure it is followed by CLIENTS SATISFAITS to avoid editing main section which might already have +
        
        # Regex explanation:
        # data-to="600"   : finds the value
        # [\s\S]*?        : matches any chars (non-greedy) until...
        # ></span></div>  : the end of the counter span and div
        # (?=\s*<h5.*CLIENTS SATISFAITS) : Lookahead to ensure it's the Clients widget
        
        $content = [Regex]::Replace($content, '(data-to="600"[\s\S]*?></span>)</div>(?=\s*<h5.*CLIENTS SATISFAITS)', '$1+</div>')
        
        Set-Content -Path $path -Value $content -Encoding UTF8
        Write-Host "Updated + in $file"
    }
}
