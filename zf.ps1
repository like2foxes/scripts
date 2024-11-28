if ($args.Count -eq 0) {
	$path = "."
} else {
	$path = $args[0]
}

if (-not (Get-Command "fzf" -ErrorAction SilentlyContinue)) {
    Write-Error "The 'fzf' program is not installed or not in PATH."
    exit 1
}
if (-not (Get-Command "zoxide" -ErrorAction SilentlyContinue)) {
    Write-Error "The 'zoxide' program is not installed or not in PATH."
    exit 1
}

$item = Get-Item $path -ErrorVariable err 2>$null
$dir = $item.FullName
if ($err) {
	Write-Error "Invalid path: $path"
	exit 1
}

$selectedDir = fzf --walker-root=$dir --walker=dir,follow,hidden

# If a directory is selected, use zoxide to jump to it
if ($selectedDir) {
    zoxide add $selectedDir
    Set-Location -Path $selectedDir
    Write-Host "Changed to directory: $selectedDir"
} else {
    Write-Host "No directory selected."
}

