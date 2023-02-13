#Requires -RunAsAdministrator
# 执行./Hyperv-Gpu-Vitrual.ps1 "虚拟机名称"
# 1.打开显卡虚拟化
# 2.开启虚拟机虚拟化

# 宿主机文件
# C:\Windows\System32\DriverStore\FileRepository\
# 虚拟机文件路径
# 需手动创建 HostDriverStore 文件夹 并添加everyone权限
# C:\Windows\System32\HostDriverStore\FileRepository\
# Nvidia-api驱动文件
# 拷贝到对应路径中
# C:\Windows\System32\nvapi64.dll
# =======================================================

$vm = Read-Host "Please enter vmHostName"
Write-Output "1. Open GPU Vitrual"
Write-Output "2. Open Host Vitrual"
Write-Output "3. Open All!"


function GPU
{
    Add-VMGpuPartitionAdapter -VMName $vm
    Set-VMGpuPartitionAdapter -VMName $vm -MinPartitionVRAM 0 -MaxPartitionVRAM 1000000000 -OptimalPartitionVRAM 1000000000 -MinPartitionEncode 0 -MaxPartitionEncode 18446744073709551615 -OptimalPartitionEncode 18446744073709551615 -MinPartitionDecode 0 -MaxPartitionDecode 1000000000 -OptimalPartitionDecode 1000000000 -MinPartitionCompute 0 -MaxPartitionCompute 1000000000 -OptimalPartitionCompute 1000000000
    Set-VM -GuestControlledCacheTypes $true -VMName $vm
    Set-VM -LowMemoryMappedIoSpace 1Gb -VMName $vm
    Set-VM -HighMemoryMappedIoSpace 12GB -VMName $vm
    Write-Output "The [ $vm ] Register Complete!"
}

function Vitrual
{
    # 打开虚拟化
    Set-VMProcessor $vm -ExposeVirtualizationExtensions $true
    Write-Output "The [ $vm ] Opened Vitrual!"
}

$num = Read-Host "Please enter num:"
switch($num)  
{  
    1{ GPU }  
    2{ Vitrual }  
    3{ GPU 
        Vitrual }
}