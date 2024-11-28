param (
    [string]$path = $PWD
)

# Ensure the path is provided
if (-not $path) {
    Write-Host "Usage: script.ps1 -path <path>"
    exit 1
}

# Validate the fd, fzf, and zoxide programs are installed
if (-not (Get-Command "fd" -ErrorAction SilentlyContinue)) {
    Write-Error "The 'fd' program is not installed or not in PATH."
    exit 1
}
if (-not (Get-Command "fzf" -ErrorAction SilentlyContinue)) {
    Write-Error "The 'fzf' program is not installed or not in PATH."
    exit 1
}
if (-not (Get-Command "zoxide" -ErrorAction SilentlyContinue)) {
    Write-Error "The 'zoxide' program is not installed or not in PATH."
    exit 1
}

# Find directories using fd and pipe to fzf for selection
$selectedDir = fd -t d . $path | fzf

# If a directory is selected, use zoxide to jump to it
if ($selectedDir) {
    zoxide add $selectedDir
    Set-Location -Path $selectedDir
    Write-Host "Changed to directory: $selectedDir"
} else {
    Write-Host "No directory selected."
}

