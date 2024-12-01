# Define the directory to search for .vim files
$directory = "~/AppData/Local/nvim-data/sessions/"

# Check if the directory exists
if (-not (Test-Path -Path $directory)) {
    Write-Error "The directory '$directory' does not exist."
    exit 1
}

# Ensure fzf and nvim are installed
if (-not (Get-Command "fzf" -ErrorAction SilentlyContinue)) {
    Write-Error "The 'fzf' program is not installed or not in PATH."
    exit 1
}
if (-not (Get-Command "nvim" -ErrorAction SilentlyContinue)) {
    Write-Error "The 'nvim' program is not installed or not in PATH."
    exit 1
}

# Get all .vim files from the specified directory
$vimFiles = Get-ChildItem -Path $directory -Filter "*.vim" -File

# If no files are found, exit
if ($vimFiles.Count -eq 0) {
    Write-Host "No .vim files found in the directory."
    exit 0
}

# Extract file names and pass them to fzf for selection
$fileName = $vimFiles.Name | fzf

# If a file is selected, open it with nvim -S
if ($fileName) {
    $selectedFilePath = Join-Path -Path $directory -ChildPath $fileName
    nvim -S $selectedFilePath
    Write-Host "Opened session: $selectedFilePath"
} else {
    Write-Host "No file selected."
}
