' Launches mem_writer.ps1 fully hidden (wscript is a GUI host - no console window flash).
CreateObject("WScript.Shell").Run "powershell -NoProfile -ExecutionPolicy Bypass -File ""tools\memory_stats\mem_writer.ps1""", 0, False
