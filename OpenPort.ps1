# PowerShell脚本：添加或删除Windows入站端口
# 设置输出编码为 UTF-8
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# 设置控制台输出编码为 UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
# 清屏
Clear-Host

#region 强制以管理员权限运行
$currentWi = [Security.Principal.WindowsIdentity]::GetCurrent() 
$currentWp = [Security.Principal.WindowsPrincipal]$currentWi 

if( -not $currentWp.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) 
{ 
  $boundPara = ($MyInvocation.BoundParameters.Keys | foreach{
     '-{0} {1}' -f  $_ ,$MyInvocation.BoundParameters[$_]} ) -join ' '
  $currentFile = (Resolve-Path  $MyInvocation.InvocationName).Path 

 $fullPara = $boundPara + ' ' + $args -join ' '
 Start-Process "$psHome\powershell.exe"   -ArgumentList "$currentFile $fullPara"   -verb runas 
 return
} 
#endregion

# 函数：添加入站端口规则
function Add-InboundPort {
    param (
        [string]$Port,
        [string]$Name
    )

    $protocols = @("TCP", "UDP")
    foreach ($protocol in $protocols) {
        try {
            New-NetFirewallRule -DisplayName $Name -Direction Inbound -Protocol $protocol -LocalPort $Port -Action Allow
            Write-Host "入站端口规则 '$Name' ($protocol) 已成功添加。" -ForegroundColor Green
        } catch {
            Write-Host "添加入站端口规则时出错：$_" -ForegroundColor Red
        }
    }
}

# 函数：删除入站端口规则
function Remove-InboundPort {
    param (
        [string]$Name
    )

    try {
        Remove-NetFirewallRule -DisplayName $Name
        Write-Host "入站端口规则 '$Name' 已成功删除。" -ForegroundColor Green
    } catch {
        Write-Host "删除入站端口规则时出错：$_" -ForegroundColor Red
    }
}

function Main {
    Write-Host "Windows入站端口管理脚本！"
    Write-Host "请选择操作："
    Write-Host "1. 添加入站端口规则"
    Write-Host "2. 删除入站端口规则"
    $choice = Read-Host "请输入选项 (1 或 2)"

    switch ($choice) {
        1 {
            $Port = Read-Host "请输入端口号"
            $Name = "Port-$Port"
            Add-InboundPort -Port $Port -Name $Name
        }
        2 {
            $port = Read-Host "请输入要删除的端口号"
            $Name = "Port-$Port"
            Remove-InboundPort -Name $Name
        }
        Default {
            Write-Host "无效选项！" -ForegroundColor Red
        }
    }
}

Main