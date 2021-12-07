$menu = @"
        GET INFORMATION ABOUT YOUR PC
    CPU -- basic CPU info
    GPU -- basic GPU info
    bat -- basic battery info
    dr -- basic drives info
    RAM -- basic RAM info
    OS -- basic OS info

    blu -- list bluetooth devices
    net -- list saved network interfaces 

    weth -- weather report just for fun :)

    q -- quit program

"@

cls
$menu 

while (([string]$in = Read-Host "enter command") -ne "q")
{
    cls

    Switch ($in)
    {
        "CPU"
        {
            Get-WmiObject Win32_processor | `
            ft Name, NumberOfCores, L3CacheSize, L2CacheSize, MaxClockSpeed , loadPercentage -AutoSize
            Read-Host -Prompt "Press Enter to continue"
            break
        }
        "GPU"
        {
            Get-WmiObject Win32_videoController | `
            ft DeviceId, Name, DriverVersion, @{name = "GPU RAM (GB)"; expression = {($_.AdapterRAM)/1024/1024/1024}}
            Read-Host -Prompt "Press Enter to continue"
            break
        }
        "bat"
        {
            Get-WmiObject Win32_battery | `
            ft Name, Status, @{name = "battery percentage"; expression = {$_.EstimatedChargeRemaining}}
            Read-Host -Prompt "Press Enter to continue"
            break
        }
        "dr"
        {
            Get-WmiObject Win32_logicalDisk | `
            ft  @{name = "Drive name" ; Expression = {$_.deviceID}}, `
            @{name = "Size (GB)"; expression = {[math]::Round(($_.size)/1024/1024/1024, 2)}}, `
            @{name = "Free space (GB)"; expression = {[math]::Round(($_.freeSpace)/1024/1024/1024, 2)}}
            Read-Host -Prompt "Press Enter to continue"
            break
        }
        "RAM"
        {
            Get-WmiObject Win32_physicalMemory | `
            ft Tag, @{name = "capacity (GB)" ; expression = {($_.capacity)/1024/1024/1024}},  Speed -AutoSize
            Read-Host -Prompt "Press Enter to continue"
            break
        }
        "OS"
        {
            Get-WmiObject Win32_operatingSystem | `
            ft @{name = "OS name"; expression = {$_.caption}}, `
            @{name = "Architecture"; expression = {$_.OSarchitecture}}, version -AutoSize
            Read-Host -Prompt "Press Enter to continue"
            break
        }
        "blu"
        {
            Get-PnpDevice -Class "bluetooth" | `
            ft @{name = "Name"; expression = {$_.FriendlyName}}, Status
            Read-Host -Prompt "Press Enter to continue"
            break
        }
        "net"
        {
            netsh.exe wlan show profiles 
            Read-Host -Prompt "Press Enter to continue"
            break
        }
        "weth"
        {
            (Invoke-WebRequest http://wttr.in/).Content
            Read-Host -Prompt "Press Enter to continue"
            break
        }
        Default 
        {
            "WRONG INPUT! Try again"
            Read-Host -Prompt "Press Enter to continue"
            break
        }
    }

    cls
    $menu

}