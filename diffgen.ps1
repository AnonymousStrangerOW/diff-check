# Get the directory of the current script
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path

# Prompt the user for input file names and output file name with default path
$fileAPath = Read-Host "Enter the path for the first input file (fileA) [Default: $scriptDirectory\]"
$fileBPath = Read-Host "Enter the path for the second input file (fileB) [Default: $scriptDirectory\]"
$outputFileName = Read-Host "Enter the name and extension for the output file (output) [Default: output.txt]"

# Set default values if the user does not provide input
if (-not $fileAPath) { $fileAPath = Join-Path -Path $scriptDirectory -ChildPath "fileA.txt" }
if (-not $fileBPath) { $fileBPath = Join-Path -Path $scriptDirectory -ChildPath "fileB.txt" }
if (-not $outputFileName) { $outputFileName = "output.txt" }

# Combine the output file name with the current directory
$outputFilePath = Join-Path -Path $scriptDirectory -ChildPath $outputFileName

# Read the contents of the files with UTF8 encoding
$fileAContent = Get-Content -Path $fileAPath -Raw -Encoding UTF8
$fileBContent = Get-Content -Path $fileBPath -Raw -Encoding UTF8

# Split the contents into arrays of lines
$fileALines = $fileAContent -split "`n"
$fileBLines = $fileBContent -split "`n"

# Create a hash set for quick lookup of lines in fileA
$fileAHashSet = @{}
foreach ($line in $fileALines) {
    $fileAHashSet[$line.Trim()] = $true  # Trim whitespace for accurate comparison
}

# Filter out lines from fileB that are also in fileA
$uniqueBLines = $fileBLines | Where-Object { -not $fileAHashSet.ContainsKey($_.Trim()) }

# Combine the unique lines from fileB and write to the output file
$combinedContent = $uniqueBLines -join "`n"
Set-Content -Path $outputFilePath -Value $combinedContent -Encoding UTF8

# Inform the user that the process is complete
Write-Host "The unique lines from fileB have been written to $outputFilePath"
