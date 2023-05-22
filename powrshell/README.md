# Flashing Willow in Windows  
The current version assumes you have followed the firmware creation steps and have a willow-dist.bin file.

Before flashing your device with Willow, you will need to know the COM port that the ESP32 is using.  If you dont know the COM port, open device manager and look under ports.  You should see at least one port listed as COMx - if you have mulitple ports, you may have to try flashing using each one to find the port the ESP32 is on. 
  
It is suggested the you put the ESP32 in download mode before running the flashing scripts.  This works more reliably.  To enter download mode, with the device powered off, press the top button on the left hand side and hold it while plugging it in.  The screen will remain blank when in download mode.

1. Create a new folder on your C: drive called willow  (C:\willow)
2. Copy willow-dist.bin to the C:\willow directory
3. Run a new Powershell window as administrator - This is required to set the execution policy
4. Run the following command to set the execution policy to remotesigned  
 ```  
   set-executionpolicy remotesigned 
 ```
5. Change your directory to c:\willow (cd \willow)
6. Execute the willow-flash.ps1 script and follow the on-sceen directions
