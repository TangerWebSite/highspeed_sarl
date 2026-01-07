
$files = Get-ChildItem -Include *.html -Recurse

foreach ($file in $files) {
    if ($file.Name -eq "index.html") { continue } # Skipped index.html as I did it manually

    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    
    # Check if the file still has the unique revo-slider css block or custom menu styles
    if ($content -match "revo-slider-emphasis-text") {
        # Regex to remove style blocks
        # This is a bit risky with regex, but since the structure is consistent and we just moved it to css/custom.css
        # we can try to find the specific blocks.
        
        # Simple string replacement for the known blocks might be safer if they are identical.
        # Let's try to remove everything between <style> and </style> if it matches known content.
        
        # Strategy: Remove the specific style blocks we identified in index.html, which seem to be replicated.
        
        # Block 1: Revo Slider
        $content = $content -replace '(?s)<style>.*?revo-slider-emphasis-text.*?</style>', ''
        
        # Block 2: Custom Menu Styles (includes header extras)
        $content = $content -replace '(?s)<!-- Custom Menu Styles -->\s*<style>.*?header-extras.*?</style>', ''
        
         # Block 2 without comment if comment is missing
        $content = $content -replace '(?s)<style>.*?header-extras.*?</style>', ''

        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
        Write-Host "Cleaned internal CSS from $($file.Name)"
    }
}
