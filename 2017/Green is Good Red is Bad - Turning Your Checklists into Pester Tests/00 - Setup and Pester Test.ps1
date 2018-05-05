﻿<#
## Needs Both SQL Instances

Remove-Item C:\temp\Reports\*.html
Remove-Item  C:\temp\Reports\*.xml

cd presentations:\
try
{
    Start-Process powershell.exe -ArgumentList '-noprofile -command Get-Service MS*DAVE*,SQLAgent*DAVE | Start-Service' -Verb runas
}
catch
{
    Write-Warning "FAILED to start DAVE"
}
try
{
    Start-Process powershell.exe -ArgumentList '-noprofile -command Get-Service SQLSERVERAGENT,MSSQLSERVER|Start-Service' -Verb runas
}
catch
{
    Write-Warning "FAILED to start SQL"
}

        $NUCServers = 'BeardDC1','BeardDC2','BeardLinuxVNext','SQL2005Ser2003','SQL2012Ser08AG3','SQL2012Ser2008AG1','SQL2012Ser2008AG2','SQL2014Ser2012R2','SQL2016N1','SQL2016N2','SQL2016N3','SQLVnextN1','SQLvNextN2','THEBEARDDNS1'
        $NUCVMs = Get-VM -ComputerName beardnuc | Where-Object {$_.Name -in $NUCServers}
            foreach($VM in $NUCVms)
                {
                $vm | Start-VM
                }
$server = 'SQL2012Ser08AG1'
 $srv = New-Object Microsoft.SqlServer.Management.Smo.Server $Server

$pri = $srv.AvailabilityGroups['SQL2012AG'].AvailabilityReplicas.Where{$_.RollupSynchronizationState -eq 'Synchronized' -and $_.Role -eq 'Primary'}.Name
 $sec = $srv.AvailabilityGroups['SQL2012AG'].AvailabilityReplicas.Where{$_.RollupSynchronizationState -eq 'Synchronized' -and $_.Role -eq 'Secondary'}.Name

 $path1 = "SQLSERVER:\SQL\$pri\DEFAULT\AvailabilityGroups\SQL2012AG"
 $path2 = "SQLSERVER:\SQL\$sec\DEFAULT\AvailabilityGroups\SQL2012AG"

Switch-SqlAvailabilityGroup -Path $path2
while ((Test-SqlAvailabilityGroup -Path $path2).Healthstate -ne 'Healthy')
{
    "Waiting for AG"
}
sleep -Seconds 5
(Get-SqlAgentJob -ServerInstance $sec).Where{$_.Name -like '*basebackup*' -and $_.Name -notlike '*Beard*'}.start()
sleep -Seconds 5
While((Get-SqlAgentJob -ServerInstance $sec).Where{$_.Name -like '*basebackup*' -and $_.Name -notlike '*Beard*'}.CurrentRunStatus -contains 'Executing')
{
"jobsrunning"
sleep -Seconds 5
}

Switch-SqlAvailabilityGroup -Path $path1 
while ((Test-SqlAvailabilityGroup -Path $path1).Healthstate -ne 'Healthy')
{
    "Waiting for AG"
}
(Get-SqlAgentJob -ServerInstance $pri).Where{$_.Name -like '*basebackup*' -and $_.Name -notlike '*Beard*'}.start()
sleep -Seconds 5
While((Get-SqlAgentJob -ServerInstance $pri).Where{$_.Name -like '*basebackup*' -and $_.Name -notlike '*Beard*'}.CurrentRunStatus -contains 'Executing')
{
"jobsrunning"
sleep -Seconds 5
}

$SQLServers = 'ROB-XPS','ROB-XPS\DAVE' ,'SQL2005Ser2003','SQL2014Ser12R2','SQL2016N1','SQL2016N2','SQL2016N3','SQLVnextN1','SQLvNextN2'
(Get-SQLAgentJob -Server $SQLServers).Where{$_.Name -eq 'DatabaseBackup - USER_DATABASES - LOG'}.Start()

#>

## Test before presentation
Describe "Testing for Presentation" {
    Context "Rob-XPS" {
        It "Should have One PowerShell ISE Process" {
            (Get-Process powershell_ise -ErrorAction SilentlyContinue).Count | Should Be 1
        }
        It "Should have PowerPoint Open" {
            (Get-Process POWERPNT  -ErrorAction SilentlyContinue).Count | Should Be 1
        }
        It "Should have the correct PowerPoint Presentation Open" {
            (Get-Process POWERPNT  -ErrorAction SilentlyContinue).MainWindowTitle| Should Be 'Green is Good Red is Bad - Turning Your Checklists into Pester Tests - PowerPoint'
        }
        It "Mail Should be closed" {
            (Get-Process HxMail -ErrorAction SilentlyContinue).COunt | Should Be 0
        }
        It "Tweetium should be closed" {
            (Get-Process WWAHost -ErrorAction SilentlyContinue).Count | Should Be 0
        }
        It "Slack should be closed" {
            (Get-Process slack* -ErrorAction SilentlyContinue).Count | Should BE 0
        }
        It "Prompt should be Presentations" {
            (Get-Location).Path | Should Be 'Presentations:\'
        }
    }
    Context "Rob-XPS SQL" {
        BeforeAll {
             $srv = New-Object Microsoft.SQLServer.Management.SMO.Server .
        }
        It "DBEngine is running" {
            (Get-Service MSSQLSERVER).Status | Should Be Running
        }
        It "SQL Server Agent is running" {
            (Get-Service SQLSERVERAGENT).Status | Should Be Running
        }
        It "DAVE DBEngine is running" {
            (Get-Service mssql*Dave).Status | Should Be Running
        }
        It "DAVE Agent is running" {
            (Get-Service sqlagent*dave).Status | Should Be Running
        }
        It "Should not have any HTML files in Reports Folder" {
        (Get-ChildItem C:\temp\Reports\*.html).Count | Should Be 0
        }
        It "Should not have any XML files in Reports Folder" {
        (Get-ChildItem C:\temp\Reports\*.xml).Count | Should Be 0
        }
    }
    Context "VM State" {       
        $NUCServers = 'BeardDC1','BeardDC2','BeardLinuxVNext','SQL2005Ser2003','SQL2012Ser08AG3','SQL2012Ser2008AG1','SQL2012Ser2008AG2','SQL2014Ser2012R2','SQL2016N1','SQL2016N2','SQL2016N3','SQLVnextN1','SQLvNextN2','THEBEARDDNS1'
        $NUCVMs = Get-VM -ComputerName beardnuc | Where-Object {$_.Name -in $NUCServers}
            foreach($VM in $NUCVms)
                {
                $VMName = $VM.Name
                  It "$VMName Should be Running"{
                    $VM.State | Should Be 'Running'
                  }
			    }

    
    } # end context vms
    Context "THEBEARD_Domain" {
            $NUCServers ='BeardDC2','LinuxVvNext','SQL2005Ser2003','SQL2012Ser08AG3','SQL2012Ser08AG1','SQL2012Ser08AG2','SQL2014Ser12R2','SQL2016N1','SQL2016N2','SQL2016N3','SQLVnextN1','SQLvNextN2','THEBEARDDNS1'
            foreach($VM in $NUCServers)
                {
                                 It "$VM Should respond to ping" {
				(Test-Connection -ComputerName $VM -Count 1 -Quiet -ErrorAction SilentlyContinue) | Should be $True
				}
                }
    }
    Context "SQL State" {
        $SQLServers = 'SQL2005Ser2003','SQL2012Ser08AG3','SQL2012Ser08AG1','SQL2012Ser08AG2','SQL2014Ser12R2','SQL2016N1','SQL2016N2','SQL2016N3','SQLVnextN1','SQLvNextN2'
        foreach($Server in $SQLServers)
        {
          $DBEngine = Get-service -ComputerName $Server -Name MSSQLSERVER
           It "$Server  DBEngine should be running" {
                $DBEngine.Status | Should Be 'Running'
            }
           It "DBEngine Should be Auto Start" {
            $DBEngine.StartType | Should be 'Automatic'
           }
              $Agent= Get-service -ComputerName $Server -Name SQLSERVERAGENT
              It "$Server Agent should be running" {
                  $Agent.Status | Should Be 'Running'
           }
           It "$Server Agent Should be Auto Start" {
            $Agent.StartType | Should be 'Automatic'
           }
        }
    
    }
}