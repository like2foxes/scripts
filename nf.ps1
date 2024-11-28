if ($args.Count -eq 0) {
	$path = "."
} else {
	$path = $args[0]
}

$item = Get-Item $path -ErrorVariable err 2>$null
$dir = $item.FullName
if ($err) {
	Write-Error "Invalid path: $path"
	exit 1
}

# Validate that fzf and Neovim are installed
if (-not (Get-Command "fzf" -ErrorAction SilentlyContinue)) {
    Write-Error "The 'fzf' program is not installed or not in PATH."
    exit 1
}
if (-not (Get-Command "nvim" -ErrorAction SilentlyContinue)) {
    Write-Error "The 'nvim' program is not installed or not in PATH."
    exit 1
}

# Search the directory and subdirectories using fzf
$selectedFile = (fzf --walker-root=$path)

# If a file is selected, open it with Neovim
if ($selectedFile) {
    nvim $selectedFile
    Write-Host "Opened file in Neovim: $selectedFile"
} else {
    Write-Host "No file selected."
}

