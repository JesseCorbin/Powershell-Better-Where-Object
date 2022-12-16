# Powershell-Better-Where-Object
## .SYNOPSIS
I made this because I was sick of typing " | ? {$\_.name -like "**"}" over and over and over. Realizing that 90% of the time I write it, it is the same except what is in between the asterisks. The only other thing that changes sometimes is the property that is queried so that is a parameter in here as well. The result is nice, I think. From " | ? {$_.name -like "\*foo\*"}" to "wh name foo".  
**Copy this function to your $PROFILE so it's always there when you need it.**

## .DESCRIPTION
The function is simple. Where-Object is cumbersome to type, even when you use the '?' alias. This makes your life easier.

## .PARAMETER PipeInput
This parameter is just there to enable input from the pipe to this function

## .PARAMETER Property
Enter the object property you want to filter for. For instance: "name", "displayname", "lastwritetime". Required. **Position 1**

## .PARAMETER Query
Enter what property value you want to filer for. For instance: "Azure", "svchost", "Stopped". Required. **Position 2**

## .PARAMETER NoWildcard
By default, this function uses wildcards (asterisks) on both ends ("*$Query*") in it's query. Use this switch to filter without wildcards. 

## .PARAMETER NotLike
By default, this function uses "-like". Use this switch to use "-notlike" instead.

## .INPUTS
Pipe PSObjects into this function, similar to Where-Object.

## .OUTPUTS
This script should output the same way Where-Object does. It may take some extra finagling in cases where you want to do multiple filters in one expression but I still find it easier to write two "wh" pipes than one Where-Object expression (See Example #5).

## .NOTES
Version:        1.0

Author:         Jesse Corbin

Creation Date:  December 16th 2022

Purpose/Change: Initial script development
    
## .EXAMPLE
    Get-Service | wh Status Stopped

## .EXAMPLE
    Get-Process | wh processname svchost -NotLike

## .EXAMPLE
    Get-Alias | wh name gp
    
## .EXAMPLE
    Get-ADComputer -filter 'name -like "ABC-???-?' -NoWildcard

## .EXAMPLE
    Get-ADComputer -filter 'name -like "ABC-\*"' | wh name ABC-\*-t -NotLike | wh name ABC-*-base -NotLike | ogv

## Here's the script

    function wh {
        [CmdletBinding()]
        param (
            [Parameter(ValueFromPipeline)]
            [pscustomobject]
            $PipeInput,
            [Parameter(Position=0,Mandatory=$true)]
            [String]
            $Property,
            [Parameter(Position=1,Mandatory=$true)]
            [String]
            $Query,
            [Parameter()]
            [Switch]$NoWildcard,
            [Parameter()]
            [Switch]$NotLike
        )
        process {
            if (!$NoWildcard -and !$NotLike) {
                $PipeInput | Where-object {$_.$($Property) -like "*$($Query)*" } -outvariable Var
            }
            elseif ($NoWildcard -and !$NotLike) {
                $PipeInput | Where-object {$_.$($Property) -like "$($Query)" } -outvariable Var        
            }    
            elseif (!$NoWildcard -and $NotLike) {
                $PipeInput | Where-object {$_.$($Property) -notlike "*$($Query)*" } -outvariable Var        
            }    
            elseif ($NoWildcard -and $NotLike) {
                $PipeInput | Where-object {$_.$($Property) -notlike "$($Query)" } -outvariable Var        
            }    
        }
        end {
            return $Var 
        }
    }
