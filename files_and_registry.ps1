# Get-WmiObject -Class Win32_Product | Select-Object Name, Version
[bool] $SFAMInstalled = $false
[bool] $SFAMAgentInstalled = $false
foreach ($inst in Get-WmiObject -Class Win32_Product | Select-Object Name, Version) {
    if ($inst.Name -eq 'STEALTHbits Activity Monitor') {
      Write-Host -ForegroundColor Green 'STEALTHbits Activity Monitor found in Add&Remove with' $inst.Version
      $SFAMInstalled = $true
    }
    if ($inst.Name -eq 'STEALTHbits Activity Monitor Agent 64-bit') {
      Write-Host -ForegroundColor Green 'STEALTHbits Activity Monitor Agent 64-bit found in Add&Remove with' $inst.Version
      $SFAMAgentInstalled= $true
    }

}

function SBAM-PAth-Exists {
    param ([string]$_path)
    if ([System.IO.File]::Exists($_path)) {Write-Host -ForegroundColor Green $_path " exists"}
    else {Write-Host -ForegroundColor Red $_path " not exists"}
}


if (!$SFAMInstalled) {
    Write-Host -ForegroundColor Red 'STEALTHbits Activity Monitor not found in Add&Remove'
}


if (!$SFAMAgentInstalled) {
    Write-Host -ForegroundColor Red 'STEALTHbits Activity Monitor Agent 64-bit not found in Add&Remove'
}
else {
#    SBAM-PAth-Exists($Env:Programfiles + "\STEALTHbits\StealthAUDIT\FSAC")
    SBAM-PAth-Exists($Env:Programfiles + "\STEALTHbits\StealthAUDIT\FSAC\SBTFileMon.ini")
    SBAM-PAth-Exists($Env:Programfiles + "\STEALTHbits\StealthAUDIT\FSAC\SBTService.exe")
    SBAM-PAth-Exists($env:windir + "\System32\drivers\SBTFSF.sys")
    $reg = (Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Services\SBTLogging\').GetValue('ConfigPath')
    $reg = (Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Services\SBTLogging\').GetValue('ConfigPath')
    SBAM-PAth-Exists([string]$reg.ToString())
    (Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\SBTLogging\Parameters).ConfigPath
    SBAM-PAth-Exists((Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\SBTLogging\Parameters).ConfigPath)
    SBAM-PAth-Exists((Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\SBTService).ImagePath.Replace('"', ""))

}

function Get-dotNET-Release{
    $installeddotnetreleases = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse |
      Get-ItemProperty -name Version, Release -EA 0 |
      Where-Object { $_.PSChildName -match 'Full'} |
      Select-Object @{name = ".NET Framework"; expression = {$_.PSChildName}},
    @{name = "Product"; expression = {$Lookup[$_.Release]}},
    Version, Release
    ForEach ($installeddotnetrelease in $installeddotnetreleases) {
         $installeddotnetrelease.Release
    }
}

function Check-dotNET-Release{
    param ([int]$ver)

    $cur = Get-dotNET-Release
    Write-Host $cur "dotNET release detected, " $ver "need for SBAM"
    if ($cur -ge $ver) {
        Write-Host -ForegroundColor green $cur 'OK /'  $ver 'needed'
    }
    else {
        Write-Host -ForegroundColor red $cur 'to old /' $ver 'needed'
    }

}

Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse |
  Get-ItemProperty -name Version, Release -EA 0 |
  Where-Object { $_.PSChildName -match 'Full'} |
  Select-Object @{name = ".NET Framework"; expression = {$_.PSChildName}},
@{name = "Product"; expression = {$Lookup[$_.Release]}},
Version, Release

$dotNETNeed = 394271

Check-dotNET-Release($dotNETNeed)
$path461 = '.\dotNET461.exe'
if(![System.IO.File]::Exists($path461)){
    #Invoke-RestMethod -Uri https://download.microsoft.com/download/E/4/1/E4173890-A24A-4936-9FC9-AF930FE3FA40/NDP461-KB3102436-x86-x64-AllOS-ENU.exe -Method Get -OutFile $path461 -Verbose
}
# .\dotNET461.exe /q
$pathSBAM = 'SBAM.msi'
if(![System.IO.File]::Exists($pathSBAM)){
    # Invoke-RestMethod -Uri https://teamcity.sbitsinc.com:8543/repository/download/SAM41/38397:id/SBActivityMonitorSetup-4.1.0.5.zip!/SBActivityMonitorSetup.msi -Method Get -OutFile $pathSBAM -Verbose
}

