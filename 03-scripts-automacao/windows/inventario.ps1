# Coleta informações da máquina e acrescenta uma linha em inventario.csv
$os    = Get-CimInstance Win32_OperatingSystem
$cs    = Get-CimInstance Win32_ComputerSystem
$disco = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
$ip    = (Get-NetIPAddress -AddressFamily IPv4 |
          Where-Object { $_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.254.*" } |
          Select-Object -First 1).IPAddress

$dados = [PSCustomObject]@{
    DataColeta     = Get-Date -Format "yyyy-MM-dd HH:mm"
    Computador     = $env:COMPUTERNAME
    UsuarioLogado  = $env:USERNAME
    Fabricante     = $cs.Manufacturer
    Modelo         = $cs.Model
    SistemaOp      = $os.Caption
    VersaoSO       = $os.Version
    RAM_GB         = [math]::Round($cs.TotalPhysicalMemory / 1GB, 1)
    DiscoC_TotalGB = [math]::Round($disco.Size / 1GB, 1)
    DiscoC_LivreGB = [math]::Round($disco.FreeSpace / 1GB, 1)
    IP             = $ip
}

$saida = Join-Path $PSScriptRoot "inventario.csv"
$dados | Export-Csv -Path $saida -Append -NoTypeInformation -Delimiter ";" -Encoding UTF8
Write-Host "Inventario gravado em $saida" -ForegroundColor Green
$dados | Format-List
