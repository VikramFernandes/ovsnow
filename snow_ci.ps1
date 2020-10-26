# Author : Vikram Fernandes

Import-Module HPOneView.500

$appliance = Read-Host "OneView appliance IP "
$cred = Get-Credential -Credential 'Administrator'

Connect-HPOVMgmt -appliance $appliance -Credential $cred

$servers = Get-HPOVServer 

$serverArray = @()

foreach ($server in $servers) {

    $ciObj = [PSCustomObject]@{
        Name = $server.name
        AssetTag = $server.uuid
        Manufacturer = "Hewlett Packard Enterprise"
        Company = "Hewlett Packard Enterprise"
        SerialNumber = $server.serialNumber
        ModelId = $server.model
        RAM = $server.memoryMb
        CPUManufacturer = 'Intel'
        CPUType = $server.processorType
        CPUSpeed = $server.processorSpeedMhz
        CPUCount = $server.processorCount
        CPUCoreCount = $server.processorCoreCount
    }

    $serverArray += $ciObj    
}

$serverArray | ForEach {[PSCustomObject]$_} | Format-Table -AutoSize

$OutFile = $PSScriptRoot + '\snow_ci_out.csv'

$serverArray | Export-Csv -Path $OutFile -NoTypeInformation

Disconnect-HPOVMgmt

Remove-Module HPOneView.500