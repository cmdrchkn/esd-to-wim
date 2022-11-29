param (

    [Parameter(Mandatory,HelpMessage='Full path to ESD file')] 
        [string]$ESDPath,

    [Parameter(Mandatory,HelpMessage='Full path to the output directory')] 
        [string]$WIMRoot,

    [Parameter(HelpMessage='Optional. Specify an index to extract and skip prompt for index')] 
        [int]$ImageID
    
)

# Verify input exists
$ESDFile = Get-Item -Path $ESDPath
if (!(Test-Path -Path $ESDFile))
{
    Write-Error "Input ESDFile does not exist or cannot be accessed: $ESDPath" 
    exit 1
}

# List Images
dism /Get-WimInfo /WimFile:$ESDPath

# Prompt for Target ID to Extract
Write-Host ""
Write-Host "================================================================================"
if (!$ImageID){
    $ImageID = Read-Host -Prompt 'Target Image ID'
}


# Extract Target Image
$OutputFile = "$WIMRoot\" + ($ESDFile.Basename) + "-$ImageID.wim"
Write-Host ""
Write-Host "Exporting image $ImageID to $OutputFile"
Write-Host "================================================================================"
dism /export-image /SourceImageFile:$ESDPath /SourceIndex:$ImageID /DestinationImageFile:$OutputFile /Compress:max /CheckIntegrity
