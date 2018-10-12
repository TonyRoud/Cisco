<#
    Examples :
    foreach ($network in $networks) { Get-AltGroupId }
    $groups = foreach ($line in $hits){ Get-AltGroupID -line $line }
#>

$networks = Import-Csv "netdetails.csv" | sort location,source -Unique
$hits = get-content "huts.log"
$regex = "Group = (.*?), IP"

function Get-AltGroupId {
    $string = $hits -match $source | select -first 1
    $null = $string -match $regex
    $matches[1]
}
function Get-NetworkHitCount {
    $hitcnt = 0
    foreach ($line in $hits){
        if ($line -match $source){
            $hitcnt += 1
        }
    }
    $group = Get-AltGroupid -source $source
    $props = @{ "Location"=$location;
                "Source"=$source;
                "Group"=$group;
                "Hitcount"=$hitcnt }

    New-Object -TypeName PSObject -Property $props

}
$output = Foreach ($network in $networks) {
    $source = $($network.source)
    $location = $($network.location)

    Get-NetworkHitCount -source $source -location $location
}