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
