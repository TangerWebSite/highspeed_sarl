
$targetColor = "#1ABC9C"
$replacementColor = "#d12e2e" 
$oldHover = "#222" # Sometimes used as hover for links
$newHover = "#b01b1b" # Deep Red for hover

$file = "e:\TangerWebSite\highspeed_sarl\style.css"
$content = Get-Content $file -Raw -Encoding UTF8

# Ensure secondary replacement of any left over 1ABC9C (case insensitive)
$content = $content -replace '(?i)#1ABC9C', $replacementColor

# Replace generic dark text color if found in specific contexts (optional, but requested palette application)
# We already did specific Lines via multi_replace, this is a safety net for the hex code.

Set-Content -Path $file -Value $content -Encoding UTF8
Write-Host "Applied palette to style.css"
