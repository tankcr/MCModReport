#This Function creates a dialogue to return a Folder Path
function Get-Folder {
    param([string]$Description="Select Folder to place results in",[string]$RootFolder="Desktop")

 [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |
     Out-Null     

   $objForm = New-Object System.Windows.Forms.FolderBrowserDialog
        $objForm.Rootfolder = $RootFolder
        $objForm.Description = $Description
        $Show = $objForm.ShowDialog()
        If ($Show -eq "OK")
        {
            Return $objForm.SelectedPath
        }
        Else
        {
            Write-Error "Operation cancelled by user."
        }
}

$timestamp = get-date -format "yyyyMMMdd"
$MCModsFolder = Get-Folder -Description "Folder Where Mods Reside" -RootFolder "Desktop"
$modfiles = GCI $MCModsFolder -recurse|where{$_.name -like "*.jar"}|select BaseName,@{N='FileName';E={$_.Name}},@{N='Path';E={$_.FullName}},@{N='DateAdded';E={$_.CreationTime}}
$modfiles|export-csv c:\temp\modsreport-$timestamp.csv -notypeinformation