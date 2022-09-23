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
    Set-VMGpuPartitionAdapter -VMName $vm -MinPartitionVRAM 80000000 -MaxPartitionVRAM 100000000 -OptimalPartitionVRAM 100000000 -MinPartitionEncode 80000000 -MaxPartitionEncode 100000000 -OptimalPartitionEncode 100000000 -MinPartitionDecode 80000000 -MaxPartitionDecode 100000000 -OptimalPartitionDecode 100000000 -MinPartitionCompute 80000000 -MaxPartitionCompute 100000000 -OptimalPartitionCompute 100000000
    Set-VM -GuestControlledCacheTypes $true -VMName $vm
    Set-VM -LowMemoryMappedIoSpace 1Gb -VMName $vm
    Set-VM -HighMemoryMappedIoSpace 32GB -VMName $vm
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