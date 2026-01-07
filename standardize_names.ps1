
# Define the renaming map
$renameMap = @{
    # Folders
    "Imgs" = "images"
    "composants" = "components"
    
    # HTML Files
    "Contact.html" = "contact.html"
    "Devis.html" = "devis.html"
    "Equipement.html" = "equipement.html"
    "Qui_Somme_Nous.html" = "qui-sommes-nous.html"
    "Services.html" = "services.html"
}

# Define the content replacement map (Regex strings for safety)
$replaceMap = @{
    # Check for quotes to avoid replacing random text
    'href="Contact.html"' = 'href="contact.html"'
    'href="Devis.html"' = 'href="devis.html"'
    'href="Equipement.html"' = 'href="equipement.html"'
    'href="Qui_Somme_Nous.html"' = 'href="qui-sommes-nous.html"'
    'href="Services.html"' = 'href="services.html"'
    'href="../Contact.html"' = 'href="../contact.html"'
    'href="../Devis.html"' = 'href="../devis.html"'
    'href="../Equipement.html"' = 'href="../equipement.html"'
    'href="../Qui_Somme_Nous.html"' = 'href="../qui-sommes-nous.html"'
    'href="../Services.html"' = 'href="../services.html"'

    # Image paths
    'src="Imgs/' = 'src="images/'
    'url\("Imgs/' = 'url("images/'
    "url\('Imgs/" = "url('images/"
    'data-lazyload="Imgs/' = 'data-lazyload="images/'
    'data-thumb="Imgs/' = 'data-thumb="images/'
    'data-videomp4="Imgs/' = 'data-videomp4="images/'
    'data-dark-logo="Imgs/' = 'data-dark-logo="images/'
    
    # Path corrections
    'src="../Imgs/' = 'src="../images/'
    'data-dark-logo="../Imgs/' = 'data-dark-logo="../images/'
    
    # Composants (if referenced in comments or scripts)
    'composants/' = 'components/'
}

# 1. Rename Files and Folders
Write-Host "Renaming files and folders..."
foreach ($key in $renameMap.Keys) {
    if (Test-Path $key) {
        Rename-Item -Path $key -NewName $renameMap[$key]
        Write-Host "Renamed $key to $($renameMap[$key])"
    } else {
        Write-Host "Skipped $key (Not found)"
    }
}

# 2. Update Content
Write-Host "Updating file content..."
$exts = @("*.html", "*.css", "*.js", "*.php")
$files = Get-ChildItem -Include $exts -Recurse

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    $originalContent = $content
    
    foreach ($key in $replaceMap.Keys) {
        $pattern = [regex]::Escape($key).Replace('"', '\"').Replace("'", "\'") # Basic escaping
        # Actually, for simple replacement, string replace is safer regarding regex constraints
        # But we need to be careful. Let's use simple string replace for the keys defined above.
        
        # We need to unescape the regex chars manually for string replace or just use as is.
        # The keys in $replaceMap are literal strings we want to find.
        
        $search = $key -replace '\\', '' # Clean backslashes if any from map keys (none currently)
        $replace = $replaceMap[$key]
        
        # Special case for url('Imgs/
        if ($key -match "url") {
             # Removing the regex confusion, just use literal replace
             $content = $content.Replace($key.Replace('\(', '(').Replace("\'", "'"), $replace)
        } else {
             $content = $content.Replace($key, $replace)
        }
    }
    
    # Additional generic replacements for Imgs folder that might not be caught by explicit quotes
    # Be careful not to replace text content.
    # Safe replacement for folder paths in css
    $content = $content.Replace("Imgs/", "images/")
    
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
        Write-Host "Updated content in $($file.Name)"
    }
}
