function Write-Log {

    
    <#
        .SYNOPSIS
        Write a linje in your log file

        .DESCRIPTION
        Write in the log file. LogLevel give color, 1 is normal, 2 give the tesk  yellow back test and 3 is red.

        .PARAMETER Message
        The message that go to the log files

        .PARAMETER LogLevel
        1 = Normal (By Default), 2 = Yellow Bagground text, 3 = Red bagground text

        .INPUTS
        Description of objects that can be piped to the script.
        
        .OUTPUTS
        Description of objects that are output by the script.       

        .EXAMPLE
        Write-Log -Message "We have found users in AD" -LogLevel 1

        .EXAMPLE
        Write-Log -Message "We have found users in AD"

        .EXAMPLE
        Write-Log "We have found users in AD"

        .EXAMPLE
        Write-Log "Fail in try { } Foreach () ....." 3

        .LINK
        Online version: 

        .LINK
        Detail on what the script does, if this is needed.

        .NOTES
        Author: Benni Ladevig Pedersen
        Date: Juli 07,2021
    #>


    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]$Message,

        [Parameter(Position=1, Mandatory=$false)]
        [PSDefaultValue(Help='1 = Normal, 2 = yellow (Warning), 3 = Red (ERROR)')]
        [ValidateSet(1, 2, 3)]
        [int]$LogLevel = 1
    )

    $TimeGenerated = "$(Get-Date -Format HH:mm:ss).$((Get-Date).Millisecond)+000"
    
    $LineFormat = $Message, $TimeGenerated, (Get-Date -Format MM-dd-yyyy), "$("$env:COMPUTERNAME.$env:USERDNSDOMAIN" | Split-Path -Leaf) - $($MyInvocation.ScriptName | Split-Path -Leaf):$($MyInvocation.ScriptLineNumber)", `
    $([System.Security.Principal.WindowsIdentity]::GetCurrent().Name), $LogLevel, $($pid)

    $Line = '<![LOG[{0}]LOG]!><time="{1}" date="{2}" component="{3}" context="{4}" type="{5}" thread="{6}" file="" >'

    $AddLine = $Line -f $LineFormat

    Add-Content -Value $AddLine -Path $ScriptLogFilePath
}
