$Lookup = @{
    378389 = [version]'4.5'
    378675 = [version]'4.5.1'
    378758 = [version]'4.5.1'
    379893 = [version]'4.5.2'
    393295 = [version]'4.6'
    393297 = [version]'4.6'
    394254 = [version]'4.6.1'
    394271 = [version]'4.6.1'
    394802 = [version]'4.6.2'
    394806 = [version]'4.6.2'
    460798 = [version]'4.7'
    460805 = [version]'4.7'
    461308 = [version]'4.7.1'
    461310 = [version]'4.7.1'
    461808 = [version]'4.7.2'
    461814 = [version]'4.7.2'
}


Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse |
  Get-ItemProperty -name Version, Release -EA 0 |
  Where-Object { $_.PSChildName -match '^(?!S)\p{L}'} |
  Select-Object @{name = ".NET Framework"; expression = {$_.PSChildName}},
@{name = "Product"; expression = {$Lookup[$_.Release]}},
Version, Release

$installeddotnetreleases = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse |
  Get-ItemProperty -name Version, Release -EA 0 |
  Where-Object { $_.PSChildName -match 'Full'} |
  Select-Object @{name = ".NET Framework"; expression = {$_.PSChildName}},
@{name = "Product"; expression = {$Lookup[$_.Release]}}, 
Version, Release

ForEach ($installeddotnetrelease in $installeddotnetreleases) {
    if ($installeddotnetrelease.Release -ge 394271) {
        Write-Host -ForegroundColor green $installeddotnetrelease.Release 'OK /' 394271 'needed'
    }
    else {
        Write-Host -ForegroundColor red $installeddotnetrelease.Release 'to old /' 394271 'needed'
    }
}

# $Lookup = @{
#    378389 = [version]'4.5'
#    378675 = [version]'4.5.1'
#    378758 = [version]'4.5.1'
#    379893 = [version]'4.5.2'
#    393295 = [version]'4.6'
#    393297 = [version]'4.6'
#    394254 = [version]'4.6.1'
#    394271 = [version]'4.6.1'
#    394802 = [version]'4.6.2'
#    394806 = [version]'4.6.2'
#    460798 = [version]'4.7'
#    460805 = [version]'4.7'
#    461308 = [version]'4.7.1'
#    461310 = [version]'4.7.1'
#    461808 = [version]'4.7.2'
#    461814 = [version]'4.7.2'
#}
#
#
#Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse |
#  Get-ItemProperty -name Version, Release -EA 0 |
#  Where-Object { $_.PSChildName -match '^(?!S)\p{L}'} |
#  Select-Object @{name = ".NET Framework"; expression = {$_.PSChildName}},
#@{name = "Product"; expression = {$Lookup[$_.Release]}},
#Version, Release
#
#$installeddotnetreleases = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse |
#  Get-ItemProperty -name Version, Release -EA 0 |
#  Where-Object { $_.PSChildName -match 'Full'} |
#  Select-Object @{name = ".NET Framework"; expression = {$_.PSChildName}},
#@{name = "Product"; expression = {$Lookup[$_.Release]}},
#Version, Release
#
#if ($installeddotnetrelease.Release -ge 394271) {
#    Write-Host -ForegroundColor green $installeddotnetrelease.Release 'OK /' 394271 'needed'
#}
#else {
#    Write-Host -ForegroundColor red $installeddotnetrelease.Release 'to old /' 394271 'needed'
#}
#
#function Get-dotNET-Release{
#    $installeddotnetreleases = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse |
#      Get-ItemProperty -name Version, Release -EA 0 |
#      Where-Object { $_.PSChildName -match 'Full'} |
#      Select-Object @{name = ".NET Framework"; expression = {$_.PSChildName}},
#    @{name = "Product"; expression = {$Lookup[$_.Release]}},
#    Version, Release
#    ForEach ($installeddotnetrelease in $installeddotnetreleases) {
#         $installeddotnetrelease.Release
#    }
#}
#
#function Check-dotNET-Release{
#    param ([int]$ver)
#
#    $cur = Get-dotNET-Release
#    if ($cur -ge $ver) {
#        Write-Host -ForegroundColor green $cur 'OK /'  $ver 'needed'
#    }
#    else {
#        Write-Host -ForegroundColor red $cur 'to old /' $ver 'needed'
#    }
#
#}
#
#$dotNETNeed = 394271
#
#Check-dotNET-Release($dotNETNeed)
#$path461 = '.\dotNET461.exe'
#if(![System.IO.File]::Exists($path461)){
#    Invoke-RestMethod -Uri https://download.microsoft.com/download/E/4/1/E4173890-A24A-4936-9FC9-AF930FE3FA40/NDP461-KB3102436-x86-x64-AllOS-ENU.exe -Method Get -OutFile $path461 -Verbose
#}
## .\dotNET461.exe /q
#$pathSBAM = 'SBAM.msi'
#if(![System.IO.File]::Exists($pathSBAM)){
#    # Invoke-RestMethod -Uri https://teamcity.sbitsinc.com:8543/repository/download/SAM41/38397:id/SBActivityMonitorSetup-4.1.0.5.zip!/SBActivityMonitorSetup.msi -Method Get -OutFile $pathSBAM -Verbose
#}