function wh {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [pscustomobject]
        $PipeInput,
        [Parameter(Position=0)]
        [String]
        $Property,
        [Parameter(Position=1)]
        [String]
        $Query,
        [Parameter()]
        [Switch]$NoWildCard,
        [Parameter()]
        [Switch]$NotLike
    )

    process {
        if (!$NoWildCard -and !$NotLike) {
            $PipeInput | Where-object {$_.$($Property) -like "*$($Query)*" } -outvariable Var
        }
        elseif ($NoWildCard -and !$NotLike) {
            $PipeInput | Where-object {$_.$($Property) -like "$($Query)" } -outvariable Var        
        }    
        elseif (!$NoWildCard -and $NotLike) {
            $PipeInput | Where-object {$_.$($Property) -notlike "*$($Query)*" } -outvariable Var        
        }    
        elseif ($NoWildCard -and $NotLike) {
            $PipeInput | Where-object {$_.$($Property) -notlike "$($Query)" } -outvariable Var        
        }    
    }

    end {
        return $Var 
    }
}