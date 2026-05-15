# =============================
# HIDE CONSOLE WINDOW
# =============================
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
}
"@
$hwnd = (Get-Process -Id $PID).MainWindowHandle
[Win32]::ShowWindow($hwnd, 0)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# =============================
# COLORS & THEME
# =============================
$bgColor     = [System.Drawing.Color]::FromArgb(45,45,48)
$panelColor  = [System.Drawing.Color]::FromArgb(28,28,28)
$aiBgColor   = [System.Drawing.Color]::FromArgb(18,18,18)
$accentColor = [System.Drawing.Color]::FromArgb(0,122,204)
$textColor   = [System.Drawing.Color]::White

# =============================
# GLOBAL STATE
# =============================
$global:selectedPrinterName = $null
$global:aiContext = @()

# =============================
# FORM
# =============================
$form = New-Object System.Windows.Forms.Form
$form.Text = "Automated Printer Troubleshooter"
$form.Size = '980,620'
$form.StartPosition = "CenterScreen"
$form.BackColor = $bgColor
$form.ForeColor = $textColor
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false

# =============================
# AI ASSISTANT PANEL (LEFT)
# =============================
$aiPanel = New-Object System.Windows.Forms.Panel
$aiPanel.Location = '10,10'
$aiPanel.Size = '280,560'
$aiPanel.BackColor = $panelColor
$form.Controls.Add($aiPanel)

$lblAI = New-Object System.Windows.Forms.Label
$lblAI.Text = "AI Local Helpdesk Assistant"
$lblAI.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)
$lblAI.ForeColor = 'White'
$lblAI.Location = '10,10'
$lblAI.AutoSize = $true
$aiPanel.Controls.Add($lblAI)

$txtAI = New-Object System.Windows.Forms.RichTextBox
$txtAI.Location = '10,40'
$txtAI.Size = '260,500'
$txtAI.ReadOnly = $true
$txtAI.BackColor = $aiBgColor
$txtAI.ForeColor = 'LightSkyBlue'
$txtAI.BorderStyle = "None"
$txtAI.Font = New-Object System.Drawing.Font("Segoe UI",9)
$txtAI.Text = "AI will automatically analyze issues and suggest fixes."
$aiPanel.Controls.Add($txtAI)

# =============================
# PRINTER SELECTION
# =============================
$lblPrinter = New-Object System.Windows.Forms.Label
$lblPrinter.Text = "Target Printer:"
$lblPrinter.Location = '310,15'
$form.Controls.Add($lblPrinter)

$cmbPrinters = New-Object System.Windows.Forms.ComboBox
$cmbPrinters.Location = '420,12'
$cmbPrinters.Size = '380,25'
$cmbPrinters.DropDownStyle = "DropDownList"
$form.Controls.Add($cmbPrinters)

$btnRefresh = New-Object System.Windows.Forms.Button
$btnRefresh.Text = "Refresh"
$btnRefresh.Location = '815,11'
$btnRefresh.Size = '140,28'
$btnRefresh.BackColor = $accentColor
$btnRefresh.FlatStyle = "Flat"
$btnRefresh.FlatAppearance.BorderSize = 0
$form.Controls.Add($btnRefresh)

# =============================
# LOG BOX (RIGHT)
# =============================
$txtLog = New-Object System.Windows.Forms.RichTextBox
$txtLog.Location = '310,50'
$txtLog.Size = '645,300'
$txtLog.ReadOnly = $true
$txtLog.BackColor = $panelColor
$txtLog.ForeColor = 'LightGray'
$txtLog.BorderStyle = "None"
$txtLog.Font = New-Object System.Drawing.Font("Consolas",10)
$form.Controls.Add($txtLog)

# =============================
# PROGRESS BAR
# =============================
$progress = New-Object System.Windows.Forms.ProgressBar
$progress.Location = '310,360'
$progress.Size = '645,10'
$form.Controls.Add($progress)

# =============================
# BUTTON FACTORY
# =============================
function New-StyledButton($text,$x,$y,$color){
    $b = New-Object System.Windows.Forms.Button
    $b.Text = $text
    $b.Location = "$x,$y"
    $b.Size = '150,45'
    $b.BackColor = [System.Drawing.ColorTranslator]::FromHtml($color)
    $b.FlatStyle = "Flat"
    $b.FlatAppearance.BorderSize = 0
    $b.Font = New-Object System.Drawing.Font("Segoe UI",9,[System.Drawing.FontStyle]::Bold)
    $form.Controls.Add($b)
    return $b
}

$btnCheckStatus      = New-StyledButton "Check Status"      310 380 "#455A64"
$btnRestartSpooler   = New-StyledButton "Restart Spooler"   470 380 "#546E7A"
$btnClearQueue       = New-StyledButton "Clear Queue"       630 380 "#78909C"
$btnTestConnectivity = New-StyledButton "Connectivity"      790 380 "#007ACC"

$btnFull = New-Object System.Windows.Forms.Button
$btnFull.Text = "RUN FULL SYSTEM DIAGNOSTIC"
$btnFull.Location = '310,440'
$btnFull.Size = '645,55'
$btnFull.BackColor = [System.Drawing.Color]::FromArgb(60,60,60)
$btnFull.FlatStyle = "Flat"
$btnFull.FlatAppearance.BorderColor = $accentColor
$btnFull.FlatAppearance.BorderSize = 2
$btnFull.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)
$form.Controls.Add($btnFull)

# =============================
# UTILITIES
# =============================
function Show-Loading {
    for($i=0;$i -le 100;$i+=20){
        $progress.Value=$i
        $form.Refresh()
        Start-Sleep -Milliseconds 100
    }
    $progress.Value=0
}

function Ensure-PrinterSelected {
    if(-not $global:selectedPrinterName){
        Log-Message "No printer selected." "error"
        return $false
    }
    return $true
}

# =============================
# LOGGING + AI CONTEXT
# =============================
function Log-Message($msg,$type="info"){
    switch($type){
        "success" { $txtLog.SelectionColor='LimeGreen' }
        "error"   { 
            $txtLog.SelectionColor='IndianRed'
            $global:aiContext += $msg
        }
        "loading" { $txtLog.SelectionColor='SkyBlue' }
        default   { $txtLog.SelectionColor='White' }
    }
    $txtLog.AppendText("[$((Get-Date).ToString('HH:mm:ss'))] $msg`r`n")
    $txtLog.ScrollToCaret()
}

# =============================
# AI ASSISTANT (AUTO)
# =============================
function Invoke-AIAssistant {
    if(-not (Get-Command ollama -ErrorAction SilentlyContinue)){ return }
    if($global:aiContext.Count -eq 0){ return }

    $context = $global:aiContext -join "`n"
    $txtAI.Text = "Analyzing issues..."

    $prompt = @"
You are a senior IT Helpdesk engineer.
Analyze the issues below and provide:
• Summary
• Likely cause
• Recommended action (max 3 steps)
Use simple language.

ISSUES:
$context
"@

    Start-Job {
        param($p)
        $p | ollama run llama3
    } -ArgumentList $prompt | Register-ObjectEvent StateChanged -Action {
        if($sender.State -eq 'Completed'){
            $result = Receive-Job $sender
            Remove-Job $sender
            $form.Invoke([Action]{
                $txtAI.Text = "AI Insight:`r`n$result"
            })
        }
    } | Out-Null

    $global:aiContext = @()
}

# =============================
# CORE FUNCTIONS
# =============================
function Load-Printers {
    $cmbPrinters.Items.Clear()
    Get-Printer | ForEach-Object { $cmbPrinters.Items.Add($_.Name) | Out-Null }
    Log-Message "Select a printer to begin."
}

function Get-PrintQueue {
    $jobs = Get-PrintJob -PrinterName $global:selectedPrinterName -ErrorAction SilentlyContinue
    if(!$jobs){
        Log-Message "No active print jobs." "success"
    } else {
        Log-Message "Queue contains $($jobs.Count) job(s):"
        foreach($j in $jobs){
            Log-Message " - $($j.DocumentName) ($($j.JobStatus))"
        }
    }
}

function Check-PrinterStatus {
    if(-not (Ensure-PrinterSelected)){ return }
    Show-Loading
    $p = Get-Printer -Name $global:selectedPrinterName
    Log-Message "Printer: $($p.Name)" "success"
    Log-Message "Status: $($p.PrinterStatus)"
    Get-PrintQueue
}

function Restart-Spooler {
    Show-Loading
    Restart-Service Spooler -Force
    Log-Message "Print Spooler restarted." "success"
}

function Clear-PrintQueue {
    if(-not (Ensure-PrinterSelected)){ return }
    Show-Loading
    Stop-Service Spooler -Force
    Remove-Item "C:\Windows\System32\spool\PRINTERS\*" -Force -ErrorAction SilentlyContinue
    Start-Service Spooler
    Log-Message "Print queue cleared." "success"
}

function Test-Connectivity {
    if(-not (Ensure-PrinterSelected)){ return }
    Show-Loading
    $p = Get-Printer -Name $global:selectedPrinterName
    if($p.PortName -match "USB|LPT"){
        Log-Message "Local printer detected. Network test skipped."
        return
    }
    if(Test-Connection $p.PortName -Count 1 -Quiet){
        Log-Message "Network connectivity OK." "success"
    } else {
        Log-Message "Network connectivity FAILED." "error"
    }
}

function Full-Troubleshoot {
    Check-PrinterStatus
    Restart-Spooler
    Clear-PrintQueue
    Test-Connectivity
    Log-Message "Diagnostic complete." "success"
    Invoke-AIAssistant
}

# =============================
# EVENTS
# =============================
$btnRefresh.Add_Click({ Load-Printers })

$cmbPrinters.Add_SelectedIndexChanged({
    $global:selectedPrinterName = $cmbPrinters.SelectedItem
    Log-Message "Selected: $global:selectedPrinterName" "success"
    Get-PrintQueue
})

$btnCheckStatus.Add_Click({ Check-PrinterStatus })
$btnRestartSpooler.Add_Click({ Restart-Spooler })
$btnClearQueue.Add_Click({ Clear-PrintQueue })
$btnTestConnectivity.Add_Click({ Test-Connectivity })
$btnFull.Add_Click({ Full-Troubleshoot })

# =============================
# START
# =============================
Load-Printers
[void]$form.ShowDialog()