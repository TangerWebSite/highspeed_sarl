
$files = Get-ChildItem -Include *.html,*.js -Recurse

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    $originalContent = $content
    
    # Case-insensitive replace for filenames to lowercase
    $content = $content -replace 'Services\.html', 'services.html'
    $content = $content -replace 'Qui_Somme_Nous\.html', 'qui-sommes-nous.html'
    $content = $content -replace 'Equipement\.html', 'equipement.html'
    $content = $content -replace 'Devis\.html', 'devis.html'
    $content = $content -replace 'Contact\.html', 'contact.html'
    
    # Also fix Imgs/ if any left (case insensitive regex)
    $content = $content -replace 'Imgs/', 'images/'
    
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
        Write-Host "Fixed references in $($file.Name)"
    }
}
