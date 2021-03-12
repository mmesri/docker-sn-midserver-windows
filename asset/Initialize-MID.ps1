$SERVICE_INSTALLED=Get-Service -name snc_mid -ErrorAction SilentlyContinue

# Start MID Server If Installed, Otherwise Proceed to Configure
if ( $SERVICE_INSTALLED -ne $null )
{
    Start-Service -name snc_mid
    return
}

& 'C:\Program Files\ServiceNow\Setup-MID.ps1'
