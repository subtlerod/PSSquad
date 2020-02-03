<#
    
.SYNOPSIS
    A brief description of the function or script.

.DESCRIPTION
    A longer description.

.PARAMETER FirstParameter
    Description of each of the parameters
    Note:
    To make it easier to keep the comments synchronized with changes to the parameters, 
    the preferred location for parameter documentation comments is not here, 
    but within the param block, directly above each parameter.

.PARAMETER SecondParameter
    Description of each of the parameters

.INPUTS
    Description of objects that can be piped to the script

.OUTPUTS
    Description of objects that are output by the script

.EXAMPLE
    Example of how to run the script

.LINK
    Links to further documentation

.NOTES
    Additional notes.
#>
function Get-PathToEXE
{

    param(
        [parameter(Mandatory=$true)]
        [string]$ServerAppID
    )
    process {
        switch ($ServerAppID) {
            403240 { $ServerPathToExe = 'SquadGame\Binaries\Win64\SquadGameServer.exe'; break}
            746200 { $ServerPathToExe = 'PostScriptum\Binaries\Win64\PostScriptumServer.exe'; break}
            774961 { $ServerPathToExe = 'SquadUAT\Binaries\Win64\SquadUATServer.exe'; break}
        }
    }
    end {
        return $ServerPathToExe
    }
}

#############################################################################################################################
<#
    
.SYNOPSIS
    A brief description of the function or script.

.DESCRIPTION
    A longer description.

.PARAMETER FirstParameter
    Description of each of the parameters
    Note:
    To make it easier to keep the comments synchronized with changes to the parameters, 
    the preferred location for parameter documentation comments is not here, 
    but within the param block, directly above each parameter.

.PARAMETER SecondParameter
    Description of each of the parameters

.INPUTS
    Description of objects that can be piped to the script

.OUTPUTS
    Description of objects that are output by the script

.EXAMPLE
    Example of how to run the script

.LINK
    Links to further documentation

.NOTES
    Additional notes.
#>
function Get-GameServerAPIurl
{

    param(
        [parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [PSObject[]]$ServerDataObject,
        [parameter(Mandatory=$false)]
        [string[]]$APIDataSource=@('rcon.tog.ninja','api.battlemetrics.com')
    )
    process {
        $APIurl=@()
        foreach($API in $APIDataSource)
        {
            $object = New-Object PSObject
            switch ($API) {
                'rcon.tog.ninja'
                {
                    $object | Add-Member NoteProperty BaseURL 'rcon.tog.ninja'
                    $object | Add-Member NoteProperty FullURL $("https://rcon.tog.ninja/api.php?IP={0}&Port={1}" -f $ServerDataObject.IPAddress,$ServerDataObject.QueryPort)
                    ; break
                }
                'api.battlemetrics.com'
                {
                    $object | Add-Member NoteProperty BaseURL 'api.battlemetrics.com'
                    if(($($ServerDataObject.BattlemetricsServerID) -ne '') `
                            -and ($($ServerDataObject.BattlemetricsServerID) -gt 0) `
                            -and ($null -ne $($ServerDataObject.BattlemetricsServerID)))
                    {
                        $object | Add-Member NoteProperty FullURL $("https://api.battlemetrics.com/servers/{0}" -f $ServerDataObject.BattlemetricsServerID)
                    } else {
                        $object | Add-Member NoteProperty FullURL $null
                    }
                ; break
                }
            }
            $APIurl+=$object
        }
    }
    end {
        return $APIurl
    }
}

#############################################################################################################################
<#
    
.SYNOPSIS
    A brief description of the function or script.

.DESCRIPTION
    A longer description.

.PARAMETER FirstParameter
    Description of each of the parameters
    Note:
    To make it easier to keep the comments synchronized with changes to the parameters, 
    the preferred location for parameter documentation comments is not here, 
    but within the param block, directly above each parameter.

.PARAMETER SecondParameter
    Description of each of the parameters

.INPUTS
    Description of objects that can be piped to the script

.OUTPUTS
    Description of objects that are output by the script

.EXAMPLE
    Example of how to run the script

.LINK
    Links to further documentation

.NOTES
    Additional notes.
#>
function Confirm-ValidFormat
{
   
    param(
        [parameter(Mandatory=$true)]
        [AllowNull()]
        [PSObject]$ServerDataObject
    )

    begin {
        [array]$Columns = 'ServerNo','IPAddress','Port','QueryPort','IntIPAddress','PlayerCount','InstallationDir','appID','MapRandom','BattlemetricsServerID','CoreAffinity','Mods','ModSheetID'
        $ValidData = New-Object PSObject
        $ValidData | Add-Member NoteProperty Bool $true
        $ValidData | Add-Member NoteProperty Errors 0
        $ValidData | Add-Member NoteProperty ErrorMessage @()
    }
    process {
        if($ServerDataObject -eq $null)
        {
            $ValidData.Bool=$false
            $ValidData.ErrorMessage += "`$ServerDataObject is null."
            $ValidData.Errors++
        } else {
            foreach($Column in $Columns)
            {
                if(!([bool]($ServerDataObject.PSObject.Properties.name -match $Column)))
                    {
                        $ValidData.Bool=$false
                        $ValidData.ErrorMessage += "Missing column `'$Column`'."
                        $ValidData.Errors++
                    } else {
                    switch ($Column) {
                        'ServerNo' { 
                            if(!([int]$ServerDataObject.$($Column)))
                            { 
                                $ValidData.Bool=$false
                                $ValidData.ErrorMessage += "`'ServerNo - ($($ServerDataObject.$($Column)))`' value is not an integer."
                                $ValidData.Errors++
                            }; break
                        }
                        'IPAddress' { 
                            if(!([ipaddress]$ServerDataObject.$($Column))) 
                            { 
                                $ValidData.Bool=$false
                                $ValidData.ErrorMessage += "`'IPAddress - ($($ServerDataObject.$($Column)))`' value is not a valid IP address."
                                $ValidData.Errors++ 
                            } ; break
                        }
                        'Port' { 
                            if(!([int]$ServerDataObject.$($Column)))
                            { 
                                $ValidData.Bool=$false
                                $ValidData.ErrorMessage += "`'Port - ($($ServerDataObject.$($Column)))`' value is not an integer."
                                $ValidData.Errors++  
                            } ; break
                        }
                        'QueryPort' { 
                            if(!([int]$ServerDataObject.$($Column)))
                            { 
                                $ValidData.Bool=$false 
                                $ValidData.ErrorMessage += "`'QueryPort - ($($ServerDataObject.$($Column)))`' value is not an integer."
                                $ValidData.Errors++ 
                            } ; break
                        }
                        'IntIPAddress' { 
                            if(!([ipaddress]$ServerDataObject.$($Column))) 
                            { 
                                $ValidData.Bool=$false 
                                $ValidData.ErrorMessage += "`'IntIPAddress - ($($ServerDataObject.$($Column)))`' value is not a valid IP address."
                                $ValidData.Errors++ 
                            } ; break
                        }
                        'PlayerCount' { 
                            if(!([int]$ServerDataObject.$($Column)))
                            { 
                                $ValidData.Bool=$false 
                                $ValidData.ErrorMessage += "`'PlayerCount - ($($ServerDataObject.$($Column)))`' value is not an integer"
                                $ValidData.Errors++ 
                            } ; break
                        }
                        'InstallationDir' { 
                            if(!([System.IO.FileInfo]$ServerDataObject.$($Column))) 
                            {
                                $ValidData.Bool=$false 
                                $ValidData.ErrorMessage += "`'InstalltionDir - ($($ServerDataObject.$($Column)))`' value is not a valid file path."
                                $ValidData.Errors++ 
                            } ; break
                        }
                        'appID' { 
                            if(!([int]$ServerDataObject.$($Column))) 
                            { 
                                $ValidData.Bool=$false
                                $ValidData.ErrorMessage += "`'appID - ($($ServerDataObject.$($Column)))`' value is not an integer"
                                $ValidData.Errors++  
                            } ; break
                        }
                        'MapRandom' { 
                            if((!([string]$ServerDataObject.$($Column))))
                            { 
                                $ValidData.Bool=$false
                                $ValidData.ErrorMessage += "`'MapRandom - ($($ServerDataObject.$($Column)))`' value is not an string"
                                $ValidData.Errors++  
                            } elseif (!($($ServerDataObject.$($Column)) -in 'ALWAYS','FIRST','NONE')) {
                                $ValidData.Bool=$false
                                $ValidData.ErrorMessage += "`'MapRandom - ($($ServerDataObject.$($Column)))`' value is not one of 'ALWAYS', 'FIRST', 'NONE'"
                                $ValidData.Errors++  
                            } ; break
                        }
                        'BattlemetricsServerID' { 
                            if(!(([int]$ServerDataObject.$($Column)) -or ($ServerDataObject.$($Column)) -eq 0)) 
                            {
                                $ValidData.Bool=$false 
                                $ValidData.ErrorMessage += "`'BattlemetricsServerID - ($($ServerDataObject.$($Column)))`' value is not an integer."
                                $ValidData.Errors++ 
                            } ; break
                        }
                        'CoreAffinity' { 
                            if(!([int]$ServerDataObject.$($Column))) 
                            {
                                $ValidData.Bool=$false 
                                $ValidData.ErrorMessage += "`'CoreAffinity - ($($ServerDataObject.$($Column)))`' value is not an int."
                                $ValidData.Errors++ 
                            } ; break
                        }
                        'Mods' { 
                            if(!($ServerDataObject.$($Column) -in 'Y','N'))
                            {
                                $ValidData.Bool=$false 
                                $ValidData.ErrorMessage += "`'Mods - ($($ServerDataObject.$($Column)))`' value is not one of 'Y','N'."
                                $ValidData.Errors++ 
                            } ; break
                        }
                        'ModSheetID' { 
                            if($ServerDataObject.Mods -eq 'Y')
                            {
                                if(!($ServerDataObject.$($Column).Length -eq 44))
                                {
                                    $ValidData.Bool=$false 
                                    $ValidData.ErrorMessage += "`'ModSheetID - ($($ServerDataObject.$($Column)))`' entry is invalid. ($($ServerDataObject.$($Column).Length))"
                                    $ValidData.Errors++ 
                                } ; break
                            }
                        }
                    }
                }
            }
        }
    }
    end {
        return $ValidData
    }
}

#############################################################################################################################
<#
    
.SYNOPSIS
    A brief description of the function or script.

.DESCRIPTION
    A longer description.

.PARAMETER FirstParameter
    Description of each of the parameters
    Note:
    To make it easier to keep the comments synchronized with changes to the parameters, 
    the preferred location for parameter documentation comments is not here, 
    but within the param block, directly above each parameter.

.PARAMETER SecondParameter
    Description of each of the parameters

.INPUTS
    Description of objects that can be piped to the script

.OUTPUTS
    Description of objects that are output by the script

.EXAMPLE
    Example of how to run the script

.LINK
    Links to further documentation

.NOTES
    Additional notes.
#>
function Convert-WebContent
{
 
    param(
        [parameter(Mandatory=$true)]
        [PSObject[]]$ServerRawWebContent
    )
    begin {
        $PlayerCount = @()
        $MaxScore = @()
        $ServerWebContent = New-Object PSObject
        $ServerWebContent | Add-Member NoteProperty PlayerCount $null
        $ServerWebContent | Add-Member NoteProperty MaxScore $null
    }
    process {
        foreach($RawWebContent in $ServerRawWebContent)
            {
                $WebContent = New-Object PSObject
                $WebContent | Add-Member NoteProperty BaseURL $RawWebContent.BaseURL
                $WebContent | Add-Member NoteProperty PlayerCount $null
                $WebContent | Add-Member NoteProperty MaxScore $null
                $WebContent | Add-Member NoteProperty JSON $($($RawWebContent.RawWebData.Content) | Out-String | ConvertFrom-Json)
                $WebContent | Add-Member NoteProperty FullURL $RawWebContent.FullURL
                $WebContent | Add-Member NoteProperty RawWebData $RawWebContent.RawWebData
                if($null -ne $WebContent.JSON)
                {
                    switch ($RawWebContent.BaseURL) {
                        'rcon.tog.ninja' {
                                $MaxScore += $($WebContent.JSON.player.Conn.Frags | Measure-Object -Maximum).Maximum
                                $WebContent.MaxScore = $MaxScore[-1]
                                $PlayerCount += $($($WebContent.JSON.player.Conn).Count,$($WebContent.JSON.ServerInfo.Players-$WebContent.JSON.BuggedPlayerCount),$WebContent.JSON.PlayerCount | Measure-Object -Minimum).Minimum
                                $WebContent.PlayerCount = $PlayerCount[-1]
                        }
                        'api.battlemetrics.com' {
                                $PlayerCount += $WebContent.JSON.data.attributes.players
                                $WebContent.PlayerCount = $PlayerCount[-1]
                        }
                    }
                }
                $ServerWebContent | Add-Member NoteProperty $RawWebContent.BaseURL $WebContent
            }
            $ServerWebContent.PlayerCount = $($PlayerCount | Measure-Object -Average).Average
            $ServerWebContent.MaxScore = $($MaxScore | Measure-Object -Average).Average
        }
    end {
        return $ServerWebContent
    }
}

#############################################################################################################################
<#
    
.SYNOPSIS
    A brief description of the function or script.

.DESCRIPTION
    A longer description.

.PARAMETER FirstParameter
    Description of each of the parameters
    Note:
    To make it easier to keep the comments synchronized with changes to the parameters, 
    the preferred location for parameter documentation comments is not here, 
    but within the param block, directly above each parameter.

.PARAMETER SecondParameter
    Description of each of the parameters

.INPUTS
    Description of objects that can be piped to the script

.OUTPUTS
    Description of objects that are output by the script

.EXAMPLE
    Example of how to run the script

.LINK
    Links to further documentation

.NOTES
    Additional notes.
#>
function Get-GameServerAPIData
{
    
    [CmdletBinding(DefaultParameterSetName="DataObject")]
    param(
        [parameter(ParameterSetName="DataObject",Mandatory=$true,ValueFromPipeline=$true)]
        [PSObject]$ServerDataObject,
        [parameter(ParameterSetName="CSVFile",Mandatory=$true)]
        [int]$ServerNo,
        [parameter(ParameterSetName="CSVFile",Mandatory=$true)]
        [ValidateScript({ Test-Path $_ })]
        [string]$ServerCSVFile,
        [parameter(Mandatory=$false)]
        [string[]]$APIDataSource=@('rcon.tog.ninja','api.battlemetrics.com')
    )

    begin {
        if($PSCmdlet.ParameterSetName -eq "CSVFile")
        {
            [PSObject]$ServerDataObject = Import-Csv -Path $ServerCSVFile | Where-Object {$_.ServerNo -eq $ServerNo}
        }
        $validformat = Confirm-ValidFormat -ServerDataObject $ServerDataObject
    }

    process {
        if($($validformat).Bool)
        {
            $APIurl = Get-GameServerAPIurl -ServerDataObject $ServerDataObject -APIDataSource $APIDataSource
            $ServerRawWebContent=@()
            foreach($API in $APIurl)
            {
                $object = New-Object PSObject
                $object | Add-Member NoteProperty BaseURL $API.BaseURL
                $object | Add-Member NoteProperty FullURL $API.FullURL
                $object | Add-Member NoteProperty RawWebData $(Invoke-WebRequest $API.FullURL -UseBasicParsing)
                $ServerRawWebContent += $object
            }
            $ServerWebContent = Convert-WebContent -ServerRawWebContent $ServerRawWebContent
        }
    }

    end {
        if($($validformat).Bool)
        {
            return $ServerWebContent
        } else {
            #Throw Format Error
            Write-Error "Server data object does not meet specifications required. Number of errors: $($($validformat.Errors | Measure-Object -Maximum).Maximum)" 
            return $validformat
        }
    }
}

#############################################################################################################################
<#
.SYNOPSIS
    A brief description of the function or script.

.DESCRIPTION
    A longer description.

.PARAMETER FirstParameter
    Description of each of the parameters
    Note:
    To make it easier to keep the comments synchronized with changes to the parameters, 
    the preferred location for parameter documentation comments is not here, 
    but within the param block, directly above each parameter.

.PARAMETER SecondParameter
    Description of each of the parameters

.INPUTS
    Description of objects that can be piped to the script

.OUTPUTS
    Description of objects that are output by the script

.EXAMPLE
    Example of how to run the script

.LINK
    Links to further documentation

.NOTES
    Additional notes.
#>
function Start-GameServer
{
    
    [CmdletBinding(DefaultParameterSetName="DataObject")]
    param(
        [parameter(ParameterSetName="DataObject",Mandatory=$true,ValueFromPipeline=$true)]
        [PSObject]$ServerDataObject,

        [parameter(ParameterSetName="CSVFile",Mandatory=$true)]
        [int]$ServerNo,
        [parameter(ParameterSetName="CSVFile",Mandatory=$true)]
        [ValidateScript({ Test-Path $_ })]
        [string]$ServerCSVFile,

        [parameter(ParameterSetName="DataObject",Mandatory=$false)]
        [parameter(ParameterSetName="CSVFile",Mandatory=$false)]
        [switch]$NoIp,

        [parameter(ParameterSetName="InputParams",Mandatory=$true)]
        [ValidateScript({ Test-Path $_ })]
        [string]$GameServerPath,
        [parameter(ParameterSetName="InputParams",Mandatory=$false)]
        [ipaddress]$IP,
        [parameter(ParameterSetName="InputParams",Mandatory=$false)]
        [int]$Port,
        [parameter(ParameterSetName="InputParams",Mandatory=$false)]
        [int]$QueryPort,
        [parameter(ParameterSetName="InputParams",Mandatory=$false)]
        [ValidateSet('ALWAYS','FIRST','NONE')]
        [string]$MapMode, 
        [parameter(ParameterSetName="InputParams",Mandatory=$false)]
        [int]$MaxPlayers,

        [parameter(Mandatory=$false)]
        [int]$MaxTickRate=50,
        [parameter(Mandatory=$false)]
        [ValidateSet('Idle','BelowNormal','Normal','AboveNormal','High','RealTime')]
        [string]$Priority='Normal',
        [parameter(Mandatory=$false)]
        [switch]$FullCrashDump,
        [parameter(Mandatory=$false)]
        [switch]$Log
    )

    begin {
        if($PSCmdlet.ParameterSetName -eq "CSVFile")
        {
            [PSObject]$ServerDataObject = Import-Csv -Path $ServerCSVFile | Where-Object {$_.ServerNo -eq $ServerNo}
        }
        $validformat = Confirm-ValidFormat -ServerDataObject $ServerDataObject

        if($($validformat).Bool)
        {
            $ServerPathToExe = Get-PathToEXE -ServerAppID $ServerDataObject.appID
            $ServerInstallDir = $ServerDataObject.InstallationDir
            if($ServerInstallDir.Substring($ServerInstallDir.Length-1,1) -ne '\') { $ServerInstallDir = $ServerInstallDir + '\' }
            $GameServerPath = $ServerInstallDir + $ServerPathToExe
            if(!($NoIp)) { $IP=$($ServerDataObject.IntIPAddress) }
            $Port=$($ServerDataObject.Port)
            $QueryPort=$($ServerDataObject.QueryPort)
            $MaxPlayers=$($ServerDataObject.PlayerCount)
            $MapMode=$($ServerDataObject.MapRandom)
            $CoreAffinity=[int]$($ServerDataObject.CoreAffinity)
        }

        $LaunchSquad = "& $GameServerPath"
        if($IP) 
        { $LaunchSquad += " MULTIHOME=$IP" }
        if($Port) 
        { $LaunchSquad += " Port=$Port" }
        if($QueryPort) 
        { $LaunchSquad += " QueryPort=$QueryPort" }
        if($MaxPlayers) 
        { $LaunchSquad += " FIXEDMAXPLAYERS=$MaxPlayers" }
        if($MaxTickRate) 
        { $LaunchSquad+= " FIXEDMAXTICKRATE=$MaxTickRate" }
        if($MapMode) 
        { $LaunchSquad += " RANDOM=$MapMode" }
        if($FullCrashDump) 
        { $LaunchSquad += " -fullcrashdump" }
        if($Log) 
        { $LaunchSquad += " -log" }
    }

    process {
        if($($validformat).Bool)
        {
            $SquadProcess = Get-Process | Where-Object { $_.Path -like $GameServerPath }
            if($null -ne $SquadProcess)
            {
                Write-Error "Squad Process is already running under PID: $($SquadProcess.Id)" 
            } else {
                Invoke-Expression $LaunchSquad
                $SquadProcess = Get-Process | Where-Object { $_.Path -like $GameServerPath }
                if($null -ne $SquadProcess)
                {
                    if($SquadProcess.PriorityClass -ne $Priority)
                    {
                        $(Get-Process -Id $SquadProcess.Id).PriorityClass = $Priority
                    }
                    if($SquadProcess.ProcessorAffinity -ne $CoreAffinity)
                    {
                        $(Get-Process -Id $SquadProcess.Id).ProcessorAffinity = $CoreAffinity
                    }
                } else {
                    Write-Error "Could not launch Squad process under Path: $GameServerPath" 
                }
            }
        }
    }
    end {
        if($($validformat).Bool)
        {
            return $SquadProcess
        } else {
            #Throw Format Error
            Write-Error "Server data object does not meet specifications required. Number of errors: $($($validformat.Errors | Measure-Object -Maximum).Maximum)" 
            return $validformat
        }
    }
}

#############################################################################################################################
<#
.SYNOPSIS
    A brief description of the function or script.

.DESCRIPTION
    A longer description.

.PARAMETER FirstParameter
    Description of each of the parameters
    Note:
    To make it easier to keep the comments synchronized with changes to the parameters, 
    the preferred location for parameter documentation comments is not here, 
    but within the param block, directly above each parameter.

.PARAMETER SecondParameter
    Description of each of the parameters

.INPUTS
    Description of objects that can be piped to the script

.OUTPUTS
    Description of objects that are output by the script

.EXAMPLE
    Example of how to run the script

.LINK
    Links to further documentation

.NOTES
    Additional notes.
#>
function Update-GameServer
{
    
    [CmdletBinding(DefaultParameterSetName="DataObject")]
    param(
        [parameter(ParameterSetName="DataObject",Mandatory=$true,ValueFromPipeline=$true)]
        [PSObject]$ServerDataObject,

        [parameter(ParameterSetName="CSVFile",Mandatory=$true)]
        [int]$ServerNo,
        [parameter(ParameterSetName="CSVFile",Mandatory=$true)]
        [ValidateScript({ Test-Path $_ })]
        [string]$ServerCSVFile,

        [parameter(ParameterSetName="InputParams",Mandatory=$true)]
        [string]$ServerInstallDir,

        [parameter(Mandatory=$false)]
        [ValidateScript({ Test-Path $_ })]
        [string]$SteamCMD="Z:\steamcmd\steamcmd.exe"

    )

    begin {
        if($PSCmdlet.ParameterSetName -eq "CSVFile")
        {
            [PSObject]$ServerDataObject = Import-Csv -Path $ServerCSVFile | Where-Object { $_.ServerNo -eq $ServerNo }
        }
        $validformat = Confirm-ValidFormat -ServerDataObject $ServerDataObject

        if(($($validformat).Bool) -or ($PSCmdlet.ParameterSetName -eq "InputParams")) 
        {
            $ServerPathToExe = Get-PathToEXE -ServerAppID $ServerDataObject.appID
            $ServerInstallDir = $ServerDataObject.InstallationDir
            if($ServerInstallDir.Substring($ServerInstallDir.Length-1,1) -ne '\') { $ServerInstallDir = $ServerInstallDir + '\' }
            $GameServerPath = $ServerInstallDir + $ServerPathToExe
        }
        $Install = "& `"$SteamCMD`" +login anonymous +force_install_dir `"$ServerInstallDir`" +app_update 403240 validate +quit"
    }

    process {
        if((($($validformat).Bool) -or ($PSCmdlet.ParameterSetName -eq "InputParams")) -and (Test-Path -Path $SteamCMD))
        {
            if(Test-Path $GameServerPath)
            {
                $SquadProcess = Get-Process | Where-Object { $_.Path -like $GameServerPath }
            }
            if($null -ne $SquadProcess)
            {
                #Get-Process | Where-Object { $_.Path -like $GameServerPath } | Stop-Process -Force
            }
            $n=0
            while(Test-Path $ServerInstallDir)
            {
                Remove-Item $($ServerInstallDir) -Recurse -Force
                if($n -gt 0) { Start-Sleep -Seconds 2 }
                $n++
                if($n -gt 5) { Write-Error "Unable to remove server files"; exit }
            }
            if(!(Test-Path $ServerInstallDir -PathType Container)) { New-Item $ServerInstallDir -ItemType "directory" | Out-Null }
            if(Test-Path $ServerInstallDir -PathType Container)
            {
                Invoke-Expression $Install
            }
        }
    }
    end {
        if(($($validformat).Bool) -or ($PSCmdlet.ParameterSetName -eq "InputParams"))
        {
            return $SquadProcess
        } else {
            #Throw Format Error
            Write-Error "Server data object does not meet specifications required. Number of errors: $($($validformat.Errors | Measure-Object -Maximum).Maximum)" 
            return $validformat
        }
    }
}

#############################################################################################################################
<#
.SYNOPSIS
    A brief description of the function or script.

.DESCRIPTION
    A longer description.

.PARAMETER FirstParameter
    Description of each of the parameters
    Note:
    To make it easier to keep the comments synchronized with changes to the parameters, 
    the preferred location for parameter documentation comments is not here, 
    but within the param block, directly above each parameter.

.PARAMETER SecondParameter
    Description of each of the parameters

.INPUTS
    Description of objects that can be piped to the script

.OUTPUTS
    Description of objects that are output by the script

.EXAMPLE
    Example of how to run the script

.LINK
    Links to further documentation

.NOTES
    Additional notes.
#>
function Test-RestartStatus
{
    
    [CmdletBinding(DefaultParameterSetName="DataObject")]
    param(
        [parameter(ParameterSetName="DataObject",Mandatory=$true,ValueFromPipeline=$true)]
        [PSObject]$ServerDataObject,
        [parameter(ParameterSetName="CSVFile",Mandatory=$true)]
        [int]$ServerNo,
        [parameter(ParameterSetName="CSVFile",Mandatory=$true)]
        [ValidateScript({ Test-Path $_ })]
        [string]$ServerCSVFile,
        [parameter(Mandatory=$true)]
        [int]$hours,
        [parameter(Mandatory=$true)]
        [int]$minplayers,
        [parameter(Mandatory=$false)]
        [string[]]$APIDataSource=@('rcon.tog.ninja','api.battlemetrics.com')
    )

    begin
    {
        if($PSCmdlet.ParameterSetName -eq "CSVFile")
        {
            [PSObject]$ServerDataObject = Import-Csv -Path $ServerCSVFile | Where-Object {$_.ServerNo -eq $ServerNo}
        }
    }
    process 
    {
        if($($validformat).Bool)
        {
            $validformat = Confirm-ValidFormat -ServerDataObject $ServerDataObject
            $RestartStatus = New-Object PSObject
            $RestartStatus | Add-Member NoteProperty Bool $false
            $RestartStatus | Add-Member NoteProperty LogMessage ''

            $ServerPathToExe = Get-PathToEXE -ServerAppID $ServerDataObject.appID

            #check the squad process
            $SquadProcess = Get-Process | Where-Object { $_.Path -like $($ServerDataObject.InstallationDir + '\' + $ServerPathToExe) }

            if($null -ne $SquadProcess)
            {
                $StartTime = $SquadProcess.StartTime
                #check the start time of the process was more than $hours ago
                if($StartTime -lt $(Get-Date).AddHours(-$hours))
                {
                    $GameServerAPIData = $null
                    $GameServerAPIData = Get-GameServerAPIData -ServerDataObject $ServerDataObject
                    if($GameServerAPIData)
                    {
                        $RestartStatus.LogMessage = "Connected Players: $($GameServerAPIData.PlayerCount). "
                        #define criteria for a restart
                        if ($($GameServerAPIData.PlayerCount) -eq 0)
                        {
                            $RestartStatus.Bool = $true
                        } elseif (($($GameServerAPIData.PlayerCount) -lt $minplayers) `
                                -and ($($GameServerAPIData.MaxScore) -eq 0) `
                                -and ($null -ne $($GameServerAPIData.MaxScore)))
                        {
                            $RestartStatus.LogMessage += "Max Score 1: $($GameServerAPIData.MaxScore). "
                            Start-Sleep -Seconds 600
                            $GameServerAPIData = Get-GameServerAPIData -ServerDataObject $ServerDataObject
                            $RestartStatus.LogMessage += " / Player count: $($GameServerAPIData.PlayerCount). Max Score 2: $($GameServerAPIData.MaxScore)."
                            if ((($($GameServerAPIData.PlayerCount) -lt $minplayers) `
                                    -and ($($GameServerAPIData.MaxScore) -eq 0) `
                                    -and ($null -ne $($GameServerAPIData.MaxScore))) `
                                    -or ($($GameServerAPIData.PlayerCount) -eq 0))
                            {
                                $RestartStatus.Bool = $true
                            } else {
                                $RestartStatus.Bool = $false
                            }
                        }
                    }
                } else {
                    #When process age is less than required time

                }
            }

        } else {
            #Throw Format Error
            Write-Error "Server data object does not meet specifications required. Number of errors: $($($validformat.Errors | Measure-Object -Maximum).Maximum)" 
            return $validformat
        }
    }
    end 
    {
        return $RestartStatus
    }
}
    
#############################################################################################################################
<# 
.Synopsis 
    Write-Log writes a message to a specified log file with the current time stamp. 
.DESCRIPTION 
    The Write-Log function is designed to add logging capability to other scripts. 
    In addition to writing output and/or verbose you can write to a log file for 
    later debugging. 
.NOTES 
    Created by: Jason Wasser @wasserja 
    Modified: 11/24/2015 09:30:19 AM   
 
    Changelog: 
    * Code simplification and clarification - thanks to @juneb_get_help 
    * Added documentation. 
    * Renamed LogPath parameter to Path to keep it standard - thanks to @JeffHicks 
    * Revised the Force switch to work as it should - thanks to @JeffHicks 
 
    To Do: 
    * Add error handling if trying to create a log file in a inaccessible location. 
    * Add ability to write $Message to $Verbose or $Error pipelines to eliminate 
        duplicates. 
.PARAMETER Message 
    Message is the content that you wish to add to the log file.  
.PARAMETER Path 
    The path to the log file to which you would like to write. By default the function will  
    create the path and file if it does not exist.  
.PARAMETER Level 
    Specify the criticality of the log information being written to the log (i.e. Error, Warning, Informational) 
.PARAMETER NoClobber 
    Use NoClobber if you do not wish to overwrite an existing file. 
.EXAMPLE 
    Write-Log -Message 'Log message'  
    Writes the message to c:\Logs\PowerShellLog.log. 
.EXAMPLE 
    Write-Log -Message 'Restarting Server.' -Path c:\Logs\Scriptoutput.log 
    Writes the content to the specified log file and creates the path and file specified.  
.EXAMPLE 
    Write-Log -Message 'Folder does not exist.' -Path c:\Logs\Script.log -Level Error 
    Writes the message to the specified log file as an error message, and writes the message to the error pipeline. 
.LINK 
    https://gallery.technet.microsoft.com/scriptcenter/Write-Log-PowerShell-999c32d0 
#> 
function Write-Log 
{ 

    [CmdletBinding()] 
    Param 
    ( 
        [Parameter(Mandatory=$false, 
                    ValueFromPipelineByPropertyName=$true)] 
        [Alias("LogContent")] 
        [string]$Message, 
 
        [Parameter(Mandatory=$false)] 
        [Alias('LogPath')] 
        [string]$Path="Z:\Admin\Restarts\Restart_Log_$($(Get-Date).ToString('yyyy-MM-dd')).txt", 
         
        [Parameter(Mandatory=$false)] 
        [ValidateSet("Error","Warn","Info")] 
        [string]$Level="Info", 
         
        [Parameter(Mandatory=$false)] 
        [ValidateSet("Querying","Stopping","Stopped","Starting","Started","Updating","Format","Testing","Running")] 
        [string]$Event, 
         
        [Parameter(Mandatory=$true)] 
        [int]$ServerNo, 
         
        [Parameter(Mandatory=$false)] 
        [bool]$Force=$false, 
         
        [Parameter(Mandatory=$false)] 
        [switch]$NoClobber 
    ) 

    begin { 
        # Set VerbosePreference to Continue so that verbose messages are displayed. 
        $VerbosePreference = 'Continue' 
    } 
    process { 
        foreach($Msg in $Message)
        {
            # If the file already exists and NoClobber was specified, do not write to the log. 
            if ((Test-Path $Path) -AND $NoClobber) { 
                Write-Error "Log file $Path already exists, and you specified NoClobber. Either delete the file or specify a different name." 
                Return 
            } 
 
            # If attempting to write to a log file in a folder/path that doesn't exist create the file including the path. 
            elseif (!(Test-Path $Path)) { 
                Write-Verbose "Creating $Path." 
                New-Item $Path -Force -ItemType File | Out-Null 
            } 
 
            else { 
                # Nothing to see here yet. 
            } 
 
            # Format Date for our Log File 
            $FormattedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss" 
 
            # Write message to error, warning, or verbose pipeline and specify $LevelText 
            switch ($Level) { 
                'Error' { 
                    if($Msg) { Write-Error $Msg }
                    $LevelText = ':ERROR' 
                } 
                'Warn' { 
                    if($Msg) { Write-Warning $Msg }
                    $LevelText = ':WARN' 
                } 
                'Info' { 
                    if($Msg) { Write-Verbose $Msg }
                    $LevelText = ':INFO' 
                } 
            } 
         
            # Write log entry to $Path 
            [string]$OutText = $FormattedDate
            $OutText += $LevelText.PadRight(6,' ')
            $OutText += " - "
            $OutText += $("(Force: $Force)").PadRight(14,' ')
            if($Event) 
            {
                $OutText += " "
                $OutText += $Event.PadRight(8,' ')
            }
            $OutText += " - "
            $OutText += "Squad Server: $ServerNo."
            $OutText += " "
            $OutText += $Msg
            $OutText | Out-File -FilePath $Path -Append 
        }
    } 
    end {
        # no return ?
    } 
}

#############################################################################################################################
<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
function Restart-SquadProcess
{
    [CmdletBinding(DefaultParameterSetName='DataObject', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  ConfirmImpact='Medium')]
    [Alias()]
    param(
        [parameter(ParameterSetName="DataObject",
                   Mandatory=$true,
                   ValueFromPipeline=$true)]
        [PSObject]$ServerDataObject,

        [parameter(ParameterSetName="CSVFile",
                   Mandatory=$true)]
        [string]$ServerNo,
        [parameter(ParameterSetName="CSVFile",
                   Mandatory=$true)]
        [ValidateScript({ Test-Path $_ -PathType Leaf })]
        [string]$ServerCSVFile,
        
        [parameter(Mandatory=$false)]
        [int]$GameID=393380,
        [parameter(Mandatory=$false)]
        [int]$hours=8,
        [parameter(Mandatory=$false)]
        [int]$minplayers=5,
        [parameter(Mandatory=$false)]
        [string]$log,
        [parameter(Mandatory=$false)]
        [ValidateScript({ Test-Path $_ -PathType Container })]
        [string]$ModCache,
        [parameter(Mandatory=$false)]
        [string[]]$ExcludedModFolders,
        [parameter(Mandatory=$false)]
        [switch]$Force
    )

    Begin
    {
        if($PSCmdlet.ParameterSetName -eq "CSVFile")
        {
            [PSObject]$ServerDataObject = Import-Csv -Path $ServerCSVFile | Where-Object { $_.ServerNo -eq $ServerNo }
        }
    }
    Process
    {
        if ($pscmdlet.ShouldProcess("Target", "Operation"))
        {
            $validformat = Confirm-ValidFormat -ServerDataObject $ServerDataObject
            if($validformat.Bool)
            {
                if($PSCmdlet.ParameterSetName -ne "CSVFile")
                {
                    $ServerNo = $ServerDataObject.ServerNo 
                }
                $ServerPathToExe = Get-PathToEXE -ServerAppID $ServerDataObject.appID
                $ServerInstallDir = $ServerDataObject.InstallationDir
                if($ServerInstallDir.Substring($ServerInstallDir.Length-1,1) -ne '\') { $ServerInstallDir = $ServerInstallDir + '\' }
                $ServerProcessPath = $ServerInstallDir + $ServerPathToExe
                #check the squad process
                $SquadProcess = Get-Process | Where-Object { $_.Path -like $ServerProcessPath }

                #check restart criteria are met
                $RestartStatus = Test-RestartStatus -ServerDataObject $ServerDataObject -hours $hours -minplayers $minplayers
                if($Force) { $RestartStatus.Bool = $true }
                if([bool]($log) -and [bool]($RestartStatus.LogMessage)) { Write-Log -Path $log -Level Info -Event Querying -Force $Force -ServerNo $ServerNo -Message $RestartStatus.LogMessage }

                #if met stop process and confirm stopped
                if(($RestartStatus.Bool) -and ($null -ne $SquadProcess))
                {
                    $SquadProcess | Stop-Process -Force
                    if([bool]($log))
                    {
                        Write-Log -Path $log -Level Info -Event Stopping -Force $Force -ServerNo $ServerNo -Message "(Process Start Time: $($($SquadProcess.StartTime).ToString('yyyy-MM-dd HH:mm:ss')))."
                    }
                    Start-Sleep -Seconds 1
                    $SquadProcess = Get-Process | Where-Object { $_.Path -like $ServerProcessPath }
                    if ($null -eq $SquadProcess)
                    {
                        if([bool]($log))
                        {
                            Write-Log -Path $log -Level Info -Event Stopped -Force $Force -ServerNo $ServerNo -Message ""
                        }
                    }
                }

                #check process is stopped and start
                $SquadProcess = Get-Process | Where-Object { $_.Path -like $ServerProcessPath }
                if ($null -eq $SquadProcess)
                {
                    if(($ServerDataObject.Mods -eq 'Y') -and ([bool]($ModCache)))
                    {
                        if(Test-Path $ModCache)
                        {
                            if([bool]($ServerDataObject.ModSheetID))
                            {
                                $GoogleSheetObject = Import-GoogleSheetData -GoogleSheetID $ServerDataObject.ModSheetID
                                $CheckGoogleSheetObject = Confirm-ValidGoogleSheetInput -GoogleSheetObject $GoogleSheetObject
                                if($CheckGoogleSheetObject.Bool)
                                {
                                    $SquadModFolderRoot = $ServerDataObject.InstallationDir + '\SquadGame\Plugins\Mods\'
                                    $ModFolderRoot = $ModCache + '\steamapps\workshop\content\' + $GameID + '\'
                                    if(Test-Path $ModFolderRoot)
                                    {
                                        if([bool]($log))
                                        {
                                            Write-Log -Path $log -Level Info -Event Updating -Force $Force -ServerNo $ServerNo -Message "(Updating Mods from ModCache: $ModFolderRoot)"
                                        }
                                        Get-ChildItem $SquadModFolderRoot | Where-Object { $_.Name -notin $ExcludedModFolders } | Remove-Item -Recurse -Force
                                        foreach($ModID  in $($($($GoogleSheetObject.feed.entry | 
                                            Where-Object { 
                                                $_.'gsx$ipaddress'.'$t' -eq $ServerDataObject.IPAddress `
                                                -and $_.'gsx$gameport'.'$t' -eq $ServerDataObject.Port `
                                                -and $_.'gsx$queryport'.'$t' -eq $ServerDataObject.QueryPort `
                                                -and $_.'gsx$battlemetricsid'.'$t' -eq $ServerDataObject.BattlemetricsServerID 
                                            }).'gsx$modnumbers'.'$t'.Split(",",[System.StringSplitOptions]::RemoveEmptyEntries)).Trim() | 
                                            Select-Object -Unique))
                                        {
                                            if([bool]($log))
                                            {
                                                Write-Log -Path $log -Level Info -Event Updating -Force $Force -ServerNo $ServerNo -Message "(Updating Mod ID: $ModID)"
                                            }
                                            $SquadModPathFolder = $SquadModFolderRoot + $ModID
                                            $ModPathFolder = $ModFolderRoot + $ModID
                    
                                            # This takes 2 seconds copying it each time takes 124 milliseconds
                                            # $SquadModPathFiles = Get-ChildItem –Path $SquadModPathFolder -Recurse | foreach  {Get-FileHash –Path $_.FullName}
                                            # $ModPathFiles = Get-ChildItem –Path $ModPathFolder -Recurse | foreach  {Get-FileHash –Path $_.FullName}
                                            # Compare-Object -ReferenceObject $SquadModPathFiles.Hash -DifferenceObject $ModPathFiles.Hash

                                            if(Test-Path -Path $SquadModPathFolder -PathType Container)
                                            {
                                                Remove-Item $SquadModPathFolder -Recurse
                                            }
                                            Copy-Item -Path $ModPathFolder -Destination $SquadModPathFolder -Recurse -Force
                                        }

                                    } else {
                                        if([bool]($log))
                                        {
                                            Write-Log -Path $log -Level Error -Event Testing -Force $Force -ServerNo $ServerNo -Message "(Path $ModFolderRoot does not exist)"
                                        }
                                        Write-Error "Path $ModFolderRoot does not exist."
                                    }
                                } else {
                                    #Write log error message
                                    if([bool]($log))
                                    {
                                        Write-Log -Path $log -Level Error -Event Format -Force $Force -ServerNo $ServerNo -Message "($($CheckGoogleSheetObject.ErrorMessage))"
                                    }
                                    Write-Error $CheckGoogleSheetObject.ErrorMessage
                                }
                            }
                        } else {
                            if([bool]($log))
                            {
                                Write-Log -Path $log -Level Error -Event Testing -Force $Force -ServerNo $ServerNo -Message "(Path $ModCache does not exist)"
                            }
                            Write-Error "Path $ModCache does not exist."
                        }
                    }
                    
                    #CHANGE Start-SquadServer to have meaningful parameters
                    Start-GameServer -ServerDataObject $ServerDataObject -FullCrashDump -Log
                    if([bool]($log))
                    {
                        Write-Log -Path $log -Level Info -Event Starting -Force $Force -ServerNo $ServerNo -Message ""
                    }
                    Start-Sleep -Seconds 1
                    $SquadProcess = Get-Process | Where-Object { $_.Path -like $ServerProcessPath }
                    if ($null -ne $SquadProcess)
                    {
                        if([bool]($log))
                        {
                            Write-Log -Path $log -Level Info -Event Started -Force $Force -ServerNo $ServerNo -Message "(Process Start Time: $($($SquadProcess.StartTime).ToString('yyyy-MM-dd HH:mm:ss')))."
                        }
                    }
                }
            } else {
                if([bool]($log))
                {
                    Write-Log -Path $log -Level Error -Event Format -Force $Force -ServerNo $ServerNo -Message "($($validformat.ErrorMessage))"
                }
            }
        }
    }
    End
    {
        Return $SquadProcess
    }
}


#############################################################################################################################
<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
function Confirm-ValidGoogleSheetInput
{
    [CmdletBinding(DefaultParameterSetName='GoogleSheetObject', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  ConfirmImpact='Medium')]
    [Alias()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='GoogleSheetObject')]
        [AllowNull()]
        [Alias("SheetObject")] 
        $GoogleSheetObject
    )

    Begin
    {
        [array]$gsxExpectedVals='gsx$battlemetricsid','gsx$ipaddress','gsx$gameport','gsx$queryport','gsx$servername','gsx$modnumbers'
        $ValidData = New-Object PSObject
        $ValidData | Add-Member NoteProperty Bool $true
        $ValidData | Add-Member NoteProperty Errors 0
        $ValidData | Add-Member NoteProperty ErrorMessage @()
    }
    Process
    {
        if ($pscmdlet.ShouldProcess("Target", "Operation"))
        {
            if($null -eq $GoogleSheetObject)
            {
                $ValidData.Bool=$false
                $ValidData.ErrorMessage += "`$GoogleSheetObject is null."
                $ValidData.Errors++
            } else {
                foreach($GoogleSheetRow in $GoogleSheetObject.feed.entry)
                {
                    $gsxVals=$($GoogleSheetRow | Get-Member -MemberType NoteProperty).Name | Where-Object { $_ -like "gsx$*" }

                    if(!$([bool]$(Compare-Object -ReferenceObject $gsxVals -DifferenceObject $gsxExpectedVals)))
                    {
                        foreach($gsxExpectedVal in $gsxExpectedVals)
                        {
                            switch($gsxExpectedVal) {
                                'gsx$battlemetricsid' {
                                    if(!([int]$GoogleSheetRow.$($gsxExpectedVal).'$t'))
                                    { 
                                        $ValidData.Bool=$false 
                                        $ValidData.ErrorMessage += "`'BattlemetricsID`' value ($($GoogleSheetRow.$($gsxExpectedVal).'$t')) is not an integer."
                                        $ValidData.Errors++ 
                                    } ; break
                                }
                                'gsx$ipaddress' {
                                    if(!([ipaddress] $GoogleSheetRow.$($gsxExpectedVal).'$t')) 
                                    { 
                                        $ValidData.Bool=$false 
                                        $ValidData.ErrorMessage += "`'IPAddress`' value ($($GoogleSheetRow.$($gsxExpectedVal).'$t')) is not a valid IP address."
                                        $ValidData.Errors++ 
                                    } ; break
                                }
                                'gsx$gameport' {
                                    if(!([int]$GoogleSheetRow.$($gsxExpectedVal).'$t'))
                                    { 
                                        $ValidData.Bool=$false 
                                        $ValidData.ErrorMessage += "`'GamePort`' value ($($GoogleSheetRow.$($gsxExpectedVal).'$t')) is not an integer."
                                        $ValidData.Errors++ 
                                    } ; break
                                }
                                'gsx$queryport' {
                                    if(!([int]$GoogleSheetRow.$($gsxExpectedVal).'$t'))
                                    { 
                                        $ValidData.Bool=$false 
                                        $ValidData.ErrorMessage += "`'QueryPort`' value ($($GoogleSheetRow.$($gsxExpectedVal).'$t')) is not an integer."
                                        $ValidData.Errors++ 
                                    } ; break
                                }
                                'gsx$servername' {
                                    if((!([string]$GoogleSheetRow.$($gsxExpectedVal).'$t')))
                                    { 
                                    $ValidData.Bool=$false
                                    $ValidData.ErrorMessage += "`'ServerName`' value ($($GoogleSheetRow.$($gsxExpectedVal).'$t')) is not an string"
                                    $ValidData.Errors++  
                                    } ; break
                                }
                                'gsx$modnumbers' {
                                    if($GoogleSheetRow.$($gsxExpectedVal).'$t')
                                    {
                                        if($GoogleSheetRow.$($gsxExpectedVal).'$t' -notlike "*,*")
                                        {
                                            if(!([int]$GoogleSheetRow.$($gsxExpectedVal).'$t'))
                                            {
                                                $ValidData.Bool=$false 
                                                $ValidData.ErrorMessage += "`'ModNumbers`' value ($($GoogleSheetRow.$($gsxExpectedVal).'$t')) is not an integer."
                                                $ValidData.Errors++ 
                                            }
                                        } else {
                                            if($GoogleSheetRow.$($gsxExpectedVal).'$t'.Split(',') | ForEach-Object { if([int]!($_)) { $false } } )
                                            {
                                                $ValidData.Bool=$false 
                                                $ValidData.ErrorMessage += "`'ModNumbers`' value ($($GoogleSheetRow.$($gsxExpectedVal).'$t')) is not comma seperated integers."
                                                $ValidData.Errors++ 
                                            }
                                        }
                                    } ; break
                                }
                                default {
                                    # Other values shouldn't matter
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    End
    {
        return $ValidData
    }
}

#############################################################################################################################
<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
function Import-GoogleSheetData
{
    [CmdletBinding(DefaultParameterSetName='GoogleSheetID', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  ConfirmImpact='Medium')]
    [Alias()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='GoogleSheetID')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ $_.Length -eq 44 })]
        [Alias("SheetID")] 
        $GoogleSheetID
    )

    Begin
    {
    }
    Process
    {
        if ($pscmdlet.ShouldProcess("Target", "Operation"))
        {
            $URL='https://spreadsheets.google.com/feeds/list/' + $GoogleSheetID + '/od6/public/values?alt=json'
            $RawWebResponse=Invoke-WebRequest -Uri $URL -UseBasicParsing
            if($RawWebResponse)
            {
                $GoogleSheetObject=$RawWebResponse.Content | ConvertFrom-Json
            }
        }
    }
    End
    {
        return $GoogleSheetObject
    }
}

#############################################################################################################################
<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
function Get-SteamWorkshopDetails
{
    [CmdletBinding(DefaultParameterSetName='WorkshopID', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  ConfirmImpact='Medium')]
    [Alias()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='WorkshopID')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [Alias("p1")] 
        [int]
        $WorkshopID,

        # Param2 help description
        [Parameter(Mandatory=$false, 
                   ParameterSetName='WorkshopID')]
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [int]
        $itemcount=1
    )

    Begin
    {
        $SteamAPIURL='https://api.steampowered.com/ISteamRemoteStorage/GetPublishedFileDetails/v1/'
    }
    Process
    {
        if ($pscmdlet.ShouldProcess("Target", "Operation"))
        {
            $postParams = @{itemcount=$itemcount;'publishedfileids[0]'=$WorkshopID}
            $SteamAPIRawReturn=Invoke-WebRequest -Uri $SteamAPIURL -Method POST -Body $postParams -UseBasicParsing
            if($SteamAPIRawReturn)
            {
                $SteamAPIReturn=$SteamAPIRawReturn.Content | ConvertFrom-Json
            }
        }
    }
    End
    {
        Return $SteamAPIReturn.response
    }
}
#############################################################################################################################
