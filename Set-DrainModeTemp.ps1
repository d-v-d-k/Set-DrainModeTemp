param([Parameter(Mandatory=$true)][int]$Hours)

if((cmd.exe /c chglogon.exe /query '2>&1') -eq "Session logins are currently ENABLED")
{
    chglogon.exe /drain

    $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddHours($Hours)
    $action = New-ScheduledTaskAction -Execute "chglogon.exe" -Argument "/enable"
    $settings = New-ScheduledTaskSettingsSet -Compatibility V1 -DeleteExpiredTaskAfter (New-TimeSpan -Seconds 0)
    Register-ScheduledTask -TaskName "Drain Mode - Enable" -Trigger $trigger -Action $action -Settings $settings -User "SYSTEM" -Force

    Write-Host "Remote Desktop sessions set to drain, will be enabled in $Hours hours."
}
else
{
    Write-Host "Remote Desktop sessions are not enabled, skipping script."
}