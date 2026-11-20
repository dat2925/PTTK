param([switch]$Stop)

$ErrorActionPreference = 'Stop'
$project = Split-Path -Parent $PSScriptRoot
$state = Join-Path $env:LOCALAPPDATA 'CineManDev'
$mysqlHome = 'C:\Program Files\MySQL\MySQL Server 9.4'
$mysqlData = Join-Path $state 'mysql'
$tomcatHome = Join-Path $state 'apache-tomcat-11.0.29'
$tomcatBase = Join-Path $state 'tomcat-base'
$appCredentialFile = Join-Path $state 'mysql-app.xml'
$url = 'http://127.0.0.1:8085/CineMan/'

function Get-DemoListener([int]$Port, [string]$ExpectedPath) {
    $listener = Get-NetTCPConnection -State Listen -LocalPort $Port -ErrorAction SilentlyContinue |
        Select-Object -First 1
    if ($listener) {
        $process = Get-CimInstance Win32_Process -Filter "ProcessId=$($listener.OwningProcess)"
        if ($listener.LocalAddress -ne '127.0.0.1' -or
            -not $process.CommandLine -or -not $process.CommandLine.Contains($ExpectedPath)) {
            throw "Port $Port is in use by a different process."
        }
    }
    return $listener
}

if (-not (Test-Path -LiteralPath $appCredentialFile)) {
    throw 'The prepared demo is unavailable for this Windows account. See README.md for setting up MySQL and Tomcat.'
}
$tomcat = Get-DemoListener 8085 $tomcatBase
$mysql = Get-DemoListener 3317 $mysqlData

if ($Stop) {
    if ($tomcat) {
        $socket = [Net.Sockets.TcpClient]::new('127.0.0.1', 8086)
        try {
            $token = Get-Content -Raw -LiteralPath (Join-Path $state 'tomcat-shutdown.txt')
            $bytes = [Text.Encoding]::ASCII.GetBytes($token.Trim())
            $socket.GetStream().Write($bytes, 0, $bytes.Length)
        } finally {
            $socket.Dispose()
        }
        Wait-Process -Id $tomcat.OwningProcess -Timeout 20 -ErrorAction SilentlyContinue
        if (Get-DemoListener 8085 $tomcatBase) { throw 'Tomcat did not shut down.' }
    }
    if ($mysql) {
        $admin = Import-Clixml -LiteralPath (Join-Path $state 'mysql-admin.xml')
        $previousPassword = [Environment]::GetEnvironmentVariable('MYSQL_PWD', 'Process')
        try {
            $env:MYSQL_PWD = $admin.GetNetworkCredential().Password
            & (Join-Path $mysqlHome 'bin/mysqladmin.exe') --host=127.0.0.1 --port=3317 --protocol=TCP --user=root shutdown
            if ($LASTEXITCODE -ne 0) { throw 'Demo MySQL did not shut down.' }
        } finally {
            [Environment]::SetEnvironmentVariable('MYSQL_PWD', $previousPassword, 'Process')
        }
    }
    Write-Output 'CineMan demo stopped.'
    return
}

if ($tomcat) { Write-Output $url; return }
if (-not $env:JAVA_HOME) { throw 'Set JAVA_HOME to JDK 17 or newer. See README.md.' }
if (-not (Test-Path (Join-Path $tomcatHome 'bin/bootstrap.jar'))) {
    throw 'The prepared Tomcat 11 installation is missing. See README.md.'
}
Push-Location $project
try {
    mvn -B -ntp package
    if ($LASTEXITCODE -ne 0) { throw 'Maven could not build CineMan.' }
} finally {
    Pop-Location
}
if (-not $mysql) {
    Start-Process -FilePath (Join-Path $mysqlHome 'bin/mysqld.exe') -ArgumentList @(
        '--no-defaults', ('--basedir="' + $mysqlHome + '"'), ('--datadir="' + $mysqlData + '"'),
        ('--log-error="' + (Join-Path $state 'mysql.log') + '"'),
        '--port=3317', '--bind-address=127.0.0.1', '--mysqlx=OFF'
    ) -WindowStyle Hidden
    for ($attempt = 0; $attempt -lt 30 -and -not (Get-DemoListener 3317 $mysqlData); $attempt++) {
        Start-Sleep -Milliseconds 500
    }
    if (-not (Get-DemoListener 3317 $mysqlData)) { throw 'Demo MySQL did not start.' }
}
foreach ($directory in @('conf','logs','webapps','temp','work')) {
    New-Item -ItemType Directory -Path (Join-Path $tomcatBase $directory) -Force | Out-Null
}
Copy-Item -Path (Join-Path $tomcatHome 'conf/*') -Destination (Join-Path $tomcatBase 'conf') -Force
$token = [Guid]::NewGuid().ToString('N')
$token | Set-Content -LiteralPath (Join-Path $state 'tomcat-shutdown.txt')
@"
<?xml version="1.0" encoding="UTF-8"?>
<Server address="127.0.0.1" port="8086" shutdown="$token">
  <Service name="Catalina">
    <Connector address="127.0.0.1" port="8085" protocol="HTTP/1.1" URIEncoding="UTF-8"/>
    <Engine name="Catalina" defaultHost="localhost">
      <Host name="localhost" appBase="webapps" unpackWARs="false" autoDeploy="false"/>
    </Engine>
  </Service>
</Server>
"@ | Set-Content -Encoding ascii -LiteralPath (Join-Path $tomcatBase 'conf/server.xml')
Copy-Item -LiteralPath (Join-Path $project 'target/CineMan.war') -Destination (Join-Path $tomcatBase 'webapps/CineMan.war') -Force

$credential = Import-Clixml -LiteralPath $appCredentialFile
$launch = @{
    FilePath = Join-Path $env:JAVA_HOME 'bin/java.exe'
    ArgumentList = @(
        ('-Dcatalina.home="' + $tomcatHome + '"'), ('-Dcatalina.base="' + $tomcatBase + '"'),
        ('-Djava.io.tmpdir="' + (Join-Path $tomcatBase 'temp') + '"'), '-Dfile.encoding=UTF-8',
        ('-cp "' + $tomcatHome + '\bin\bootstrap.jar;' + $tomcatHome + '\bin\tomcat-juli.jar"'),
        'org.apache.catalina.startup.Bootstrap', 'start'
    )
    RedirectStandardOutput = Join-Path $state 'tomcat-stdout.log'
    RedirectStandardError = Join-Path $state 'tomcat-stderr.log'
    WindowStyle = 'Hidden'
}
$variables = @('CINEMAN_DB_URL','CINEMAN_DB_USER','CINEMAN_DB_PASSWORD')
$previous = @{}
foreach ($name in $variables) {
    $previous[$name] = [Environment]::GetEnvironmentVariable($name, 'Process')
}
try {
    $env:CINEMAN_DB_URL = 'jdbc:mysql://127.0.0.1:3317/cineman?sslMode=REQUIRED&connectionTimeZone=Asia%2FHo_Chi_Minh'
    $env:CINEMAN_DB_USER = $credential.UserName
    $env:CINEMAN_DB_PASSWORD = $credential.GetNetworkCredential().Password
    Start-Process @launch
} finally {
    foreach ($name in $variables) {
        [Environment]::SetEnvironmentVariable($name, $previous[$name], 'Process')
    }
}
for ($attempt = 0; $attempt -lt 30; $attempt++) {
    if (Get-DemoListener 8085 $tomcatBase) {
        try {
            $res = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 3
            if ($res.StatusCode -eq 200) { Write-Output $url; return }
        } catch {}
    }
    Start-Sleep -Milliseconds 500
}
throw "CineMan did not start. Check $state\tomcat-stderr.log."
