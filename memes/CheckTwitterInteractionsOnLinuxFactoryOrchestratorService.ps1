$c = new-factoryorchestratorclient 127.0.0.1
Write-Host "Connecting to Factory Orchestrator service running on your Windows Subsystem for Linux instance..."
$c.Connect()
Start-Sleep 1
Write-Host "Connected!"
Write-Host ""
$str = "Factory Orchestrator service version: " + $c.GetServiceVersionString()
Write-Host $str
Start-Sleep 1
$a = Read-Host "Do you wish to check your Twitter interactions?"
Write-Host "Running the CheckTwitterInteractions TaskList with Factory Orchestrator on Linux version $($c.GetOSVersionString())..."
$tl = $c.QueryTaskList("9810e793-02b0-4eda-bc96-2ffbd343dab3")
$c.RunTaskList("9810e793-02b0-4eda-bc96-2ffbd343dab3")
foreach ($t in $tl.Tasks)
{
    $r = $c.QueryTaskRun($t.LatestTaskRunGuid)
    $last = 0
    Write-Host "    Task $($t.Name) is running.... Real-time output:`n"
    while (-not $r.TaskRunComplete)
    {
        while ($last -lt  $r.TaskOutput.Count)
        {
            Write-Host $r.TaskOutput[$last++]
        }

        $r = $c.QueryTaskRun($t.LatestTaskRunGuid)
    }

    while ($last -lt  $r.TaskOutput.Count)
    {
        Write-Host $r.TaskOutput[$last++]
    }

    Write-Host "`n    Task $($t.Name) is complete!"
}

Write-Host "Thanks for using Factory Orchestrator :)"