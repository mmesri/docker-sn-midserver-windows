$MID_HOME="C:\Program Files\ServiceNow\agent"
$CONF_FILE="$MID_HOME\config.xml"
$WRAPPER_FILE="$MID_HOME\conf\wrapper-override.conf"
$SET_PARAM='C:\Program Files\ServiceNow\Set-Parameter.ps1'

# Mandatory ENV
$SN_URL=$Env:SN_URL
$SN_USER=$Env:SN_USER
$SN_PASSWD=$Env:SN_PASSWD
$SN_MID_NAME=$Env:SN_MID_NAME

# Optional ENV
$SN_MID_NAME_STATIC=$Env:SN_MID_NAME_STATIC
$SN_MAX_THREADS=$Env:SN_MAX_THREADS
$SN_JVM_SIZE=$Env:SN_JVM_SIZE
$SN_PROXY_HOST=$Env:SN_PROXY_HOST
$SN_PROXY_PORT=$Env:SN_PROXY_PORT
$SN_PROXY_USERNAME=$Env:SN_PROXY_USERNAME
$SN_PROXY_PASSWORD=$Env:SN_PROXY_PASSWORD

# Generate Random UUID
$APPEND_UUID=Get-Random

# Combine SN_MID_NAME and Random UUID
if ( $SN_MID_NAME_STATIC -eq $true )
{
    $SN_MID_NAME_UNIQUE=$SN_MID_NAME
}
else
{
    $SN_MID_NAME_UNIQUE=-join($SN_MID_NAME, "-", $APPEND_UUID)
}

# Setup "config.xml"
& $SET_PARAM -ConfigFile $CONF_FILE -Name name -Value $SN_MID_NAME_UNIQUE
& $SET_PARAM -ConfigFile $CONF_FILE -Name mid.instance.username -Value $SN_USER
& $SET_PARAM -ConfigFile $CONF_FILE -Name mid.instance.password -Value $SN_PASSWD
& $SET_PARAM -ConfigFile $CONF_FILE -Name url -Value $SN_URL

# Set "threads.max" Parameter If Defined
if ( $SN_MAX_THREADS -ne $null )
{
    & $SET_PARAM -ConfigFile $CONF_FILE -Name threads.max -Value $SN_MAX_THREADS
}

# Add Proxy Settings If Defined
if ( $SN_PROXY_HOST -ne $null )
{
    & $SET_PARAM -ConfigFile $CONF_FILE -Name mid.proxy.use_proxy -Value true
    & $SET_PARAM -ConfigFile $CONF_FILE -Name mid.proxy.host -Value $SN_PROXY_HOST
    & $SET_PARAM -ConfigFile $CONF_FILE -Name mid.proxy.port -Value $SN_PROXY_PORT
}

# Add Proxy Credentials If Defined
if ( $SN_PROXY_USERNAME -ne $null )
{
    & $SET_PARAM -ConfigFile $CONF_FILE -Name mid.proxy.username -Value $SN_PROXY_USERNAME
    & $SET_PARAM -ConfigFile $CONF_FILE -Name mid.proxy.password -Value $SN_PROXY_PASSWORD
}

# Update JVM Size If Defined
if ( $SN_JVM_SIZE -ne $null )
{
    Add-Content -Path $WRAPPER_FILE -Value "wrapper.java.maxmemory=$SN_JVM_SIZE"
}

& $MID_HOME\bin\InstallMID-NT.bat
Start-Service -name snc_mid
