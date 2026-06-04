# Automated Printer Troubleshooter

A PowerShell-based Windows Forms application for diagnosing and repairing common printer problems automatically.

This tool provides an interactive GUI for IT helpdesk technicians and system administrators, including an integrated local AI assistant powered by Ollama + Llama 3.

---

# Application Preview

<img width="1200" height="711" alt="image" src="https://github.com/user-attachments/assets/1f2a803a-8307-41e7-a8ce-f60bdb3f7d36" />

---

# Features

* Automatic printer discovery
* Print queue monitoring
* Restart Print Spooler service
* Clear stuck print jobs
* Network connectivity testing
* Full automated printer diagnostics
* Integrated AI helpdesk assistant
* Local AI analysis using Ollama + Llama 3
* Real-time logging console
* Progress indicators and status updates

---

# Technologies Used

* PowerShell
* Windows Forms (.NET)
* Ollama
* Llama 3
* Windows PrintManagement module

---

# Screenshots

## Main Dashboard

* Printer selection
* Diagnostic controls
* Live logs
* AI assistant panel

> Add screenshots inside the `/assets` folder and link them here.

Example:

```md
![Dashboard](assets/dashboard.png)
```

---

# Requirements

## Windows

* Windows 10 / 11
* PowerShell 5.1 or later

---

# Required PowerShell Module

The following module must be available:

```powershell
Get-Module PrintManagement -ListAvailable
```

---

# Optional AI Integration

Install Ollama for local AI support:

https://ollama.com

Install the Llama 3 model:

```bash
ollama pull llama3
```

---

# Installation

## Clone Repository

```bash
git clone https://github.com/jieonxei/automated-printer-troubleshooter.git
```

## Run the Application

Open PowerShell as Administrator:

```powershell
Set-ExecutionPolicy Bypass -Scope Process
.\PrinterTroubleshooter.ps1
```

Or launch using:

```text
RunPrinterTroubleshooter.vbs
```

---

# Application Functions

## Check Status

* Displays printer status
* Shows queue information

## Restart Spooler

* Restarts the Windows Print Spooler service

## Clear Queue

* Removes stuck print jobs

## Connectivity Test

* Tests printer network communication

## Full System Diagnostic

Runs all troubleshooting tasks automatically and sends issues to the AI assistant for analysis.

---

# AI Assistant

The integrated AI assistant:

* Analyzes printer errors
* Suggests likely causes
* Provides recommended fixes
* Uses local offline AI processing

## Example AI Output

```text
Summary:
Printer is unreachable on the network.

Likely Cause:
Printer IP address is offline or disconnected.

Recommended Actions:
1. Verify printer power/network connection
2. Ping printer IP manually
3. Restart printer and router
```

---

# Project Structure

```text
.
├── PrinterTroubleshooter.ps1
├── RunPrinterTroubleshooter.vbs
├── README.md
└── assets/
```

---

# Security Notes

* Runs locally only
* No cloud API usage
* AI processing remains offline through Ollama
* Requires administrator privileges for spooler operations

---

# Future Improvements

* Export diagnostic reports
* Automatic driver repair
* SNMP printer monitoring
* Remote printer management
* Multi-printer diagnostics
* PDF report generation
* Cloud AI integration
* Event Viewer log analysis

---

# License

MIT License

---

# Author

* jieonxei - Developer 
 (https://github.com/jieonxei)
