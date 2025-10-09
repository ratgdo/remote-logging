param(
  [Parameter(Mandatory = $true)]
  [string]$HostName
)

Write-Host "Pinging $HostName..."
if (-not (Test-Connection -ComputerName $HostName -Count 1 -Quiet -ErrorAction SilentlyContinue)) {
  Write-Host -ForegroundColor Red "Host $HostName is unreachable."
  exit 1
}
else {
  Write-Host -ForegroundColor Green "Host $HostName is reachable."
}

$Url = "http://$HostName/events"
Write-Host "Checking firmware type..."

try {
  $statusCode = (Invoke-WebRequest -Uri $Url -Method Head -TimeoutSec 5).StatusCode
}
catch {
  if ($_.Exception.Response) {
    $statusCode = [int]$_.Exception.Response.StatusCode
  } else {
    Write-Host -ForegroundColor Red "A connection error occurred: $($_.Exception.Message)"
    exit 1
  }
}

if ($statusCode -eq 200) {
  Write-Host -ForegroundColor Green "ratgdo-esphome detected"
}
else {
  Write-Host -ForegroundColor Red "unknown firmware type (Received HTTP Status: $statusCode)"
  exit 1
}

Write-Host "Starting log capture from $Url... Press Ctrl+C to stop."
Write-Host "---"

try {
  $printNextLine = $false
  
  curl.exe -s --no-buffer $Url | ForEach-Object {
    if ($printNextLine) {
      $timestamp = (Get-Date).ToUniversalTime().ToString("s") + "Z"
      
      # --- THIS IS THE KEY CHANGE ---
      # Changed Write-Host to Write-Output to enable file redirection.
      Write-Output "$timestamp $_"
      
      $printNextLine = $false
    }
    if ($_ -eq 'event: log') {
      $printNextLine = $true
    }
  }
}
catch {
  Write-Host -ForegroundColor Red "An error occurred during log capture: $($_.Exception.Message)"
}
finally {
  Write-Host "---"
  Write-Host "Log capture stopped."
}