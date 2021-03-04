Param
(
    [Microsoft.FactoryOrchestrator.Client.FactoryOrchestratorClientSync]$client
)

Write-Host "Connecting to Factory Orchestrator service running on your Windows Subsystem for Linux instance..."
$client.Connect()
Start-Sleep 1
Write-Host "Connected!"
Write-Host ""
$client.ResetService()
$client.LoadTaskListsFromXmlFile('/home/jafriedm/FactoryOrchestrator/memes/LinuxTasks.xml')

$str = "Factory Orchestrator service version: " + $client.GetServiceVersionString()
Write-Host $str
Start-Sleep 1
$a = Read-Host "Do you wish to run your daily Linux checkup?"
$ver = $client.GetOSVersionString()
Write-Host "Running the LinuxTasks TaskList with Factory Orchestrator on Linux version $ver..."
$tlguid = [guid]"9810e793-02b0-4eda-bc96-2ffbd343dab3"
$tl = $client.QueryTaskList($tlguid)
$client.RunTaskList($tlguid)
Start-Sleep 2
$tl = $client.QueryTaskList($tlguid)
foreach ($t in $tl.Tasks)
{
    $r = $client.QueryTaskRun($t.LatestTaskRunGuid)
    $last = 0
    Write-Host "    Task $($t.Name) is running on $ver.... Real-time output:`n"
    while (-not $r.TaskRunComplete)
    {
        while ($last -lt  $r.TaskOutput.Count)
        {
            Write-Host $r.TaskOutput[$last++]
        }

        $r = $client.QueryTaskRun($t.LatestTaskRunGuid)
    }

    while ($last -lt  $r.TaskOutput.Count)
    {
        Write-Host $r.TaskOutput[$last++]
    }

    Write-Host "`n    Task $($t.Name) is complete!"
}

Write-Host "Thanks for using Factory Orchestrator :)"