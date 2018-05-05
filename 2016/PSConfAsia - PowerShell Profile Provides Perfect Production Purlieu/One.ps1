﻿## OK Lets look at our profile
## 
Test-Path $profile
## Ah we have no profile
##
## Lets create a file
New-Item $profile -ItemType File
##
## Lets add something to it and take a look
Set-Content $profile -Value "Write-Output 'Hello Singapore'";Add-Content $profile -Value "Write-HOst 'I have never seen a more beautiful crowd' -foreground Red -background Blue";Add-Content $profile -Value "Write-HOst 'I have never seen a more beautiful crowd' -foreground Red -background Green";Add-Content $profile -Value "Write-HOst 'I have never seen a more beautiful crowd' -foreground Red -background Yellow";Add-Content $profile -Value "Write-HOst 'I have never seen a more beautiful crowd' -foreground Blue -background Red";Add-Content $profile -Value "Write-HOst 'I have never seen a more beautiful crowd' -foreground Blue -background Yellow";Add-Content $profile -Value "Write-HOst 'I have never seen a more beautiful crowd' -foreground Blue -background Green";Add-Content $profile -Value "Write-HOst 'I have never seen a more beautiful crowd' -foreground Blue -background Blue";Add-Content $profile -Value "Write-HOst 'I have never seen a more beautiful crowd' -foreground Yellow -background Green";Add-Content $profile -Value "Write-HOst 'I have never seen a more beautiful crowd' -foreground Yellow -background Blue";Add-Content $profile -Value "Write-HOst 'I have never seen a more beautiful crowd' -foreground Yellow -background Red";Add-Content $Profile -Value "Write-output 'DONT USE WRITE-HOST!!!!!!!!!!!!!!!'"
## You can can edit your profile in notepad (or in ISE using PsEdit $Profile )
notepad $Profile
##
## Lets have a look at the profile in action
cls
##
## We can load our profile like this anytime if we are testing (or doing presentations :-) ). The Profile is loaded every time the console is opened.
.$profile
##
## Lets start by doing something useful and setting the location to something
## less obtuse than C:\windows\system32 Lets use a temporary WIP Folder
Set-Content $profile 'Set-Location c:\temp\WIP'
.$Profile
## Much better
## 
## But how about the folders you use all day every day, lets make those easier to get to
## You can use New-PSDrive 
## ALWAYS start with Get-Help
Get-Help New-PSDrive -ShowWindow
## 
## Lets create some drives
## Set the profile and load the profile
$content = Get-Content 'C:\Users\mrrob\OneDrive\Documents\Presentations\PowerShell Profile Provides Perfecct Production Purlieu\PSDrives.ps1'
Set-Content $Profile $content
## Lets have a look at it
notepad $Profile
## and see it in action
.$Profile
cd Presentations:\
dir
dir Functions:\s*
dir SQLDAVE:\Logins
dir JOBSERVER:\JObs
## I would not do that though I would use the new cmdlets from the SSMS July release
Get-SQLAgentjob -ServerInstance . | Format-Table -AutoSize -Wrap
## You can Change the prompt as well
$content = Get-Content 'C:\Users\mrrob\OneDrive\Documents\Presentations\PowerShell Profile Provides Perfecct Production Purlieu\Prompt.ps1'
Set-Content $profile $content
cd C:\Windows\System32
Start-Process powershell.exe
##
cls
## 
## As you can see you can take it as far as you like.
## How is that done ?
Get-Content 'C:\Users\mrrob\OneDrive\Documents\Presentations\PowerShell Profile Provides Perfecct Production Purlieu\Prompt.ps1'
##
##
## Not what everyone will want,but some ideas
##
## We can also set up some aliases to commonly used programmes or commands
Set-Alias npp 'C:\Program Files (x86)\Notepad++\notepad++.exe'
Set-Alias exp 'C:\Windows\explorer.exe'
Set-Alias zoom 'C:\Users\mrrob\OneDrive\Documents\ZoomIt.exe'
#
#
npp
exp
zoom
## You can also set some little custom functions
function goo($Search) {Start-Process microsoft-edge:"https://www.google.co.uk/search?q=$Search"}
goo 'PowerShell is Awesome'
##Some colour stuff
$Host.UI.RawUI.WindowTitle = 'Uber Geek Programme Of Beard'
$HOst.UI.RawUI.BackgroundColor = 'Black'
$host.UI.RawUI.ForegroundColor = 'Yellow'
cls
Get-Service
# Lets have a look at the other options, you can find them here
$HOst| gm
$Host.UI|gm
$Host.UI.RawUI|gm
# You can change Errors and Warnings too
.'C:\Users\mrrob\OneDrive\Documents\Presentations\PowerShell Profile Provides Perfecct Production Purlieu\HostColours.ps1'
.'C:\Users\mrrob\OneDrive\Documents\Scripts\Powershell Scripts\Functions\Test-ConsoleColor.ps1'
Test-ConsoleColor
.'C:\Users\mrrob\OneDrive\Documents\Scripts\Powershell Scripts\Functions\Import-ConsoleColor.ps1'
Import-ConsoleColor -Path C:\Temp\consolecolor.csv
# Start-Demo doesnt like this so lets have a new file
& 'C:\Users\mrrob\OneDrive\Documents\Presentations\PowerShell Profile Provides Perfecct Production Purlieu\Cleanup.ps1'
start-process powershell.exe -args {Start-Demo 'C:\Users\mrrob\OneDrive\Documents\Presentations\PowerShell Profile Provides Perfecct Production Purlieu\two.ps1'}
