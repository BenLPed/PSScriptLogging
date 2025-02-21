function Write-Log {

    
    <#
        .SYNOPSIS
        Writes a message to the log file with a specified log level.

        .DESCRIPTION
        The Write-Log function adds a message to the log file with a timestamp and log level.
        It supports three log levels: 1 = NORMAL, 2 = WARNING, and 3 = ERROR.

        .PARAMETER Message
        The message to be logged.

        .PARAMETER LogLevel
        1 = Info (By Default), 2 = Warning, 3 = Error

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
        Detail on what the script does, if this is needed.

        .NOTES
        Author: Benni Ladevig Pedersen
        Date: January 20,2025
    #>


    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$Message,

        [Parameter(Position = 1)]
        [ValidateSet(1, 2, 3)] 
        [int]$LogLevel = 1 # 1 = Info, 2 = Warning, 3 = ERROR
    )


    $TimeGenerated = "$(Get-Date -Format HH:mm:ss).$((Get-Date).Millisecond)+000"
    $LineFormat = $Message, $TimeGenerated, (Get-Date -Format MM-dd-yyyy), "$("$env:COMPUTERNAME.$env:USERDNSDOMAIN" | Split-Path -Leaf) - $($MyInvocation.ScriptName | Split-Path -Leaf):$($MyInvocation.ScriptLineNumber)", `
    $([System.Security.Principal.WindowsIdentity]::GetCurrent().Name), $LogLevel, $($pid)
    $Line = '<![LOG[{0}]LOG]!><time="{1}" date="{2}" component="{3}" context="{4}" type="{5}" thread="{6}" file="" >'

    $AddLine = $Line -f $LineFormat

    Add-Content -Value $AddLine -Path $ScriptLogFilePath -Encoding UTF8
}

# // TODO: Test om dette gør noget for Scriptet
#   $TimeGenerated = "$(Get-Date -Format HH:mm:ss).$((Get-Date).Millisecond)+000"
#    $Component = "$("$env:COMPUTERNAME.$env:USERDNSDOMAIN" | Split-Path -Leaf) - $($MyInvocation.ScriptName | Split-Path -Leaf):$($MyInvocation.ScriptLineNumber)"
#    $Context = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
#    $LineFormat = $Message, $TimeGenerated, (Get-Date -Format MM-dd-yyyy), $Component, $Context, $LogLevel, $pid
#    $Line = '<![LOG[{0}]LOG]!><time="{1}" date="{2}" component="{3}" context="{4}" type="{5}" thread="{6}" file="" >'
