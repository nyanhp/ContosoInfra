<#
.SYNOPSIS
    Remove user
.DESCRIPTION
    Remove users based on username and department
.EXAMPLE
    Remove-ContosoUser HR john

    Remove John working in the HR department
.NOTES
    Author: Japete
    Version: 1.2.3 (but this belongs in the module manifest ;)
#>
function Remove-ContosoUser
{
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'high')] # WhatIf, Confirm
    param
    (
        # Inline help for parameter Department
        [ValidateSet('HR','Finance','Engineering')]
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $Department,

        # Inline help for parameter UserName
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $UserName
    )

    process # Executed for every object in the pipeline, so that 'john','sally' | Remove-ContosoAdUser -Department HR
    {
        if (-not $PSCmdlet.ShouldProcess(('{0} in department {1}' -f $Username, $Department), 'Remove')) { return }

        try
        {
            $user = Get-ADUser -Filter "Department -eq '$Department' -and SamAccountName -eq '$UserName'" -ErrorAction Stop
        }
        catch {}

        if (-not $user)
        {
            Write-Error -Message "$UserName does not exist in Department $department"
            return # regardless of erroraction, leave function.
        }

        $user | Remove-ADUser -Confirm:0
    }
}

<#
Department,UserName
HR,Sally
Finance,John

# After the import, each row is imported as a customobject with noteproperties (using the first row as header)
Import-Csv TheTable.csv | Remove-ContosoADUser

# Excel: ImportExcel --> Does not require Excel to be installed (unlike COM objects)
#>