$c = new-factoryorchestratorclient 127.0.0.1 -Port 47685
Write-Host "Connecting to Factory Orchestrator service running on the Windows 10 host..."
$c.Connect()
Start-Sleep 1
Write-Host "Connected!"
Write-Host ""
$str = "Factory Orchestrator service version: " + $c.GetServiceVersionString()
Write-Host $str
Start-Sleep 1
Write-Host "Running the SendMemes TaskList with Factory Orchestrator on Windows 10 version $($c.GetOSVersionString())..."
$tl = $c.QueryTaskList("9810e793-02b0-4eda-bc96-2ffbd343dab0")
$c.RunTaskList("9810e793-02b0-4eda-bc96-2ffbd343dab0")
Write-Host "Memes incoming!"