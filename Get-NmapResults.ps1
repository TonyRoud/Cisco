function Get-NmapPortScan {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]$nmapxml
        [Parameter]$filterstandardports
    )

    import-module "H:\Tickets\Calastone\5222240\Parse-Nmap.ps1"

    $nmapOutput = Parse-Nmap $nmapxml
    $portRegex = "1433|27000|28001-28002|29000|3306|4789|5224|7946|8443|52|21|20|80|443|143|110|25|22|49|43|1025|123|135|136|137|138|3268|3269|445|49152-65535|88|53|389|636|139"

    foreach ($item in $nmapxml) {
        $vmDetails = Import-Csv "portscan.csv"
        Foreach ($device in $nmapOutput){

            $specialPorts = $device.ports.split(":") | % { Select-String -InputObject $_ -Pattern "^[0-9]+$" -AllMatches | ? {$_ -notmatch $portregex} }

            [PSCustomObject]@{
                'Name'      = ($vmDetails | ? { $_.ipaddress -eq $device.ipv4 }).name
                'IPAddress' = $device.ipv4
                'MAC'       = $device.MAC
                'ports'     = $specialPorts
            }
        }
    }
}
