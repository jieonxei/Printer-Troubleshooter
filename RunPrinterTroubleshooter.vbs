Set shell = CreateObject("Shell.Application")

psPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
scriptPath = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName) & "\PrinterTroubleshooter.ps1"

shell.ShellExecute psPath, _
    "-NoProfile -ExecutionPolicy Bypass -File """ & scriptPath & """", _
    "", "runas", 1