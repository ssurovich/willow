## Windows Willow Flasher
## Create a folder called willow on the C: drive (c:\willow) and copy your willow-dist.bin to the folder before running this script
## Set your script execution to remotesigned before running this script or it will fail to execute (set-executionpolicy remotesigned)

clear-host
Write-Output "***************************************************"
Write-Output "*            Willow Windows Flasher               *"
Write-Output "***************************************************"
Write-Output ""

## Look for the willow directory on the C: drive

$dir_check = Test-Path -Path 'C:\willow\'
if ($dir_check -eq $false) {
  Write-Output "ERROR! C:\willow directory missing.  Please create a diectory called c:\willow and run the script again."
  Write-Output ""

}else{

  ## Look for the willow-dist.bin file before continuing

  Write-Output "Looking for willow-dist.bin..."
  $firmware_check = Test-Path -Path 'C:\willow\willow-dist.bin' -PathType Leaf
  Write-Output ""

  ## If firmware isnt found, warn the user and exit - If its found, continue the script

  if ($firmware_check -eq $false) {
    Write-Output "ERROR! willow-dist.bin not found.  Please copy your willow-dist.bin firmware to the c:\willow directory and run the script again."
    Write-Output ""

  }else{

    ## Ask user for the ESP32 COM port and store it in $comport
    Write-Output "Found willow-dist.bin!"
    Write-Output ""

    $comport = Read-Host -Prompt 'What COM Port is the ESP32 connected to (ie: com5): '

    ## Download Python 3.7 and install it to c:\willow

    Write-Output ""
    Write-Output "Checking for the Python 3.7 Binary - it will be downloaded if it doesn't exist in the c:\willow directory"
    Write-Output ""

    ## Check to see if the Python Binary exists to avoid reinstall it if the script is rerun for any updates

    $python_check = Test-Path -Path 'C:\willow\python-3.7.0.exe' -PathType Leaf    
    if ($python_check -eq $false) {
      Write-Output ""
      Write-Output "Downloading and Installing Python 3.7 to c:\willow - and Upgrading PIP to latest after installation completes"
      Write-Output "This may take a few minutes, depending on your Internet speed"
      Write-Output ""
    
      [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
      Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.7.0/python-3.7.0.exe" -OutFile "c:/willow/python-3.7.0.exe"
      c:/willow/python-3.7.0.exe /quiet InstallAllUsers=0 PrependPath=1 Include_test=0 TargetDir=c:\willow
       
      ## Upgrade PIP or ESPTOOL may fail
      c:\willow\python.exe -m pip install --upgrade pip

    }else{
  
      Write-Output ""
      Write-Output "Python 3.7 binary already exists, skipping download"
      Write-Output ""    

    }

    ## Download and install ESPTOOL

    Write-Output ""
    Write-Output "Installing ESPTOOL"
    Write-Output ""

    c:\willow\scripts\pip3.7.exe install esptool

    ## Erase the Flash first

    Write-Output ""
    Write-Output "Erasing ESP32"
    Write-Output ""

    c:\willow\scripts\esptool.exe --port $comport erase_flash

    ## Flash the BIN using esptool.py

    Write-Output ""
    Write-Output "Flashing Willow to the ESP32"
    Write-Output ""
    
    c:\willow\scripts\esptool.exe --port $comport write_flash 0x0 .\willow-dist.bin

    Write-Output ""
    Write-Output "Flashing script complete.   Reset or power cycle the ESP32 and Willow will start up."
    Write-Output ""
    Write-Putput "NOTE:"
    Write-Output "If the flash fails, we suggest trying to re-flash the firmware using Download Mode.  To enter download mode, unplug your ESP32 then press and hold the"
    Write-Output "The button on the top, left-hand side of the ESP32 device - keeping holding the button and plug the ESP32 back into your computer.  The screen should be blank after you plug it back in and it powers up."
    Write-Output "Then, re-run the script to flash Willow on your device"
    Write-Output ""

  }
}
