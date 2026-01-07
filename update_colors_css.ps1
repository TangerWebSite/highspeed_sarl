
$file = "e:\TangerWebSite\highspeed_sarl\css\colors.css"
$content = Get-Content $file -Raw -Encoding UTF8

$targetColor = "#1ABC9C"
$replacementColor = "#d12e2e"

# Case insensitive replacement
$content = $content -replace '(?i)' + [regex]::Escape($targetColor), $replacementColor

Set-Content -Path $file -Value $content -Encoding UTF8
Write-Host "Replaced $targetColor with $replacementColor in colors.css"
