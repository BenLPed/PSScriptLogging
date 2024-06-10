function Start-Log {

    <#
        .SYNOPSIS
        Create LogFile or continue in the existing file from the same day.
            
        .DESCRIPTION
        Create a file .log, only one per day. If a file exist then continue today's file
            
        .PARAMETER $FilePath
        The URL for the file path. It can also be a network path

        .PARAMETER $FileName
        The name of the file

        .PARAMETER $Company
        The Name of the company that runs this script.

        .PARAMETER $Description
        Create a short descrition what this script do.

        .PARAMETER $DeletedLogDays
        The script delete old log file, name the no. of days it shall loock back in time.

        .INPUTS
        Description of objects that can be piped to the script.
        
        .OUTPUTS
        Description of objects that are output by the script.

        .EXAMPLE
        Start-Log -FilePath "\\LogShare$\ADUsers" -FileName "ListOfAdUsers" -Company "BLIT" -Description "Find all users in our AD that is Enabled" -DeletedLogDays "30"

        .EXAMPLE
        Start-Log "\\LogShare$\ADUsers" "ListOfAdUsers" "BLIT" "Find all users in our AD that is Enabled" "30"

        .LINK
        Online version: 

        .LINK
        Detail on what the script does, if this is needed.

        .NOTES
        Author: Benni Ladevig Pedersen
        Date: Juli 07,2021

         
        #################################################################################
        #
        # Company       : $Company
        # Description   : $Description
        # Date          : $LogFilName
        # Runs from     : $env:COMPUTERNAME.$env:USERDNSDOMAIN
        # Authorized    : $env:USERNAME
        # 
        # Location      : $FilePath
        # Filename      : $LogFilName.log
        #    
        #################################################################################

    #>


    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [PSDefaultValue(Help='Path for folder location')]
        [ValidateScript({ Split-Path $_ -Parent | Test-Path })]
        [string]$FilePath,

        [Parameter(Position=1, Mandatory=$true)]
        [PSDefaultValue(Help='Name of the file')]
        [string]$FileName,
        
        [Parameter(Position=2, Mandatory=$true)]
        [PSDefaultValue(Help='The name of you compay')]
        [string]$Company,

        [Parameter(Position=3, Mandatory=$true)]
        [PSDefaultValue(Help='Short description what the script do')]
        [string]$Description,

        [Parameter(Position=4, Mandatory=$false)]
        [PSDefaultValue(Help='Days script delete old logs')]
        [int]$DeletedLogDays
    )

    $LogDate = Get-Date -Format yyyy-MM-dd
    $FileName = $LogDate + ' - ' + $FileName.Substring(0,1).ToUpper() + $FileName.Substring(1) + '.log'

    Try {
        if(-not(Test-Path $FilePath)) {
            New-Item $FilePath -Type Directory
        }
    } catch [System.Exception] {
        Write-Warning -Message "An error occurred when try to create a new Directory. Error message: $($_.Exception.Message)"; break
    } # SLUT - try {
        

    $FilePathLog = Join-Path $FilePath $FileName

    try {
        if (-not(Test-Path $FilePathLog)) {
            ## Create the log file
            New-Item $FilePathLog -Type File | Out-Null
        }
                   
        $global:ScriptLogFilePath = $FilePathLog
        
        Write-Log " " 
        Write-Log "#################################################################################" 2
        Write-Log "#" 2
        Write-Log "# Company    : $Company" 2
        Write-Log "# Description      : $Description" 2
        Write-Log "# Date             : $LogDate" 2
        Write-Log "# Runs from  : $env:COMPUTERNAME.$env:USERDNSDOMAIN" 2
        Write-Log "# Authorized : $env:USERNAME" 2
        Write-Log "# " 2
        Write-Log "# Location     : $FilePath" 2
        Write-Log "# Filename    : $FileName" 2
        Write-Log "# " 2   
        Write-Log "#################################################################################" 2
        Write-Log " " 
        Write-Log " "  

    } catch [System.Exception] {
        
            Write-Warning -Message "An error occurred when try to create head ribben for this script in log file. Error message: $($_.Exception.Message)"; break
    } # SLUT - try {
     
    if(-not($DeletedLogDays -eq "" -or $DeletedLogDays -eq "0")) {

        $Date = (Get-Date).Adddays(-$DeletedLogDays)

        Get-ChildItem -Path $FilePath | Where-Object { $_.LastWriteTime -le $Date} | Remove-item 
    }
} # SLUT - function Start-Log
