# Used to search a VM's folder for corrupted/broken vmdk files
# Helpful when a "The specified virtual disk needs repair" error is encountered


# Set the path to the folder containing the .vmdk files
$folderPath = "C:\Path\To\Your\Folder"

# Set the path to the .exe you want to run
$exePath = "C:\Path\To\YourProgram\yourtool.exe"

# Get all .vmdk files recursively
$vmdkFiles = Get-ChildItem -Path $folderPath -Filter *.vmdk -Recurse -File

# Loop through each file and run the .exe with the file path as an argument
foreach ($file in $vmdkFiles) {
    Write-Host "Processing $($file.FullName)"
    & "$exePath" "-R" "$($file.FullName)"
}
