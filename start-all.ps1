param([switch]$CheckOnly)
$ErrorActionPreference = 'Stop'
$names = @('Identity','Delivery','Dispatch','Finance','Reporting','Communication')
$started = @()
$oldEnvironment = $env:ASPNETCORE_ENVIRONMENT
Push-Location $PSScriptRoot
try {
    foreach ($port in 5001..5006) {
        $listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, $port)
        try { $listener.Start() }
        catch { throw "Port $port is busy. Stop the existing API first." }
        finally { $listener.Stop() }
    }
    dotnet build DeliveryPlatform.sln --nologo
    if ($LASTEXITCODE -ne 0) { throw 'Build failed.' }
    $env:ASPNETCORE_ENVIRONMENT = 'Development'
    $logs = Join-Path $PSScriptRoot '.local-logs'
    New-Item -ItemType Directory -Path $logs -Force | Out-Null
    $runId = [Guid]::NewGuid().ToString('N')
    for ($i = 0; $i -lt $names.Count; $i++) {
        $name = $names[$i]
        $directory = Join-Path $PSScriptRoot "Services/$name.API"
        $dll = Join-Path $directory "bin/Debug/net10.0/$name.API.dll"
        $url = "http://localhost:$($i + 5001)"
        $process = Start-Process dotnet -ArgumentList @("`"$dll`"", '--urls', $url) -WorkingDirectory $directory -WindowStyle Hidden -PassThru -RedirectStandardOutput "$logs/$name-$runId.log" -RedirectStandardError "$logs/$name-$runId.error.log"
        $started += [pscustomobject]@{ Name=$name; Process=$process; Url=$url }
    }
    foreach ($service in $started) {
        $ready = $false
        $deadline = [DateTime]::UtcNow.AddSeconds(30)
        while ([DateTime]::UtcNow -lt $deadline) {
            if ($service.Process.HasExited) { throw "$($service.Name) exited. See .local-logs." }
            try {
                $response = Invoke-RestMethod "$($service.Url)/api/health" -TimeoutSec 2
                if ($response.service -eq $service.Name -and $response.status -eq 'Running') { $ready=$true; break }
            } catch { Start-Sleep -Milliseconds 250 }
        }
        if (-not $ready) { throw "$($service.Name) is not ready. See .local-logs." }
        Write-Host "READY $($service.Name): $($service.Url)/api/health" -ForegroundColor Green
    }
    if (-not $CheckOnly) {
        Write-Host 'All 6 APIs running. Press Ctrl+C to stop all. Logs: .local-logs'
        while ($true) {
            foreach ($service in $started) {
                if ($service.Process.HasExited) { throw "$($service.Name) stopped. See .local-logs." }
            }
            Start-Sleep -Milliseconds 500
        }
    }
} finally {
    foreach ($service in $started) {
        if (-not $service.Process.HasExited) {
            $service.Process.Kill()
            $service.Process.WaitForExit()
        }
        $service.Process.Dispose()
    }
    $env:ASPNETCORE_ENVIRONMENT = $oldEnvironment
    Pop-Location
    Write-Host 'Stopped APIs started by this script.'
}
