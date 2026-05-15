# Printer-Troubleshooter
A printer troubleshooter that can be use for checking your printers,

Automated Printer Troubleshooter

A modern PowerShell-based Windows Forms application for diagnosing and repairing common printer problems automatically.
This tool provides an interactive GUI for IT helpdesk technicians and system administrators, including an integrated local AI assistant powered by Ollama + Llama 3.

Features
Modern dark-themed Windows Forms interface
Automatic printer discovery
Print queue monitoring
Restart Print Spooler service
Clear stuck print jobs
Network connectivity testing
Full automated printer diagnostics
Integrated AI helpdesk assistant
Local AI analysis using Ollama + Llama 3
Real-time logging console
Progress indicators and status updates
Technologies Used
PowerShell
Windows Forms (.NET)
Ollama
Llama 3
Windows PrintManagement module
Screenshots
Main Dashboard
Printer selection
Diagnostic controls
Live logs
AI assistant panel
Requirements
Windows
Windows 10/11
PowerShell 5.1 or later
Required PowerShell Modules

The following module must be available:

Get-Module PrintManagement -ListAvailable
Optional AI Integration

Install Ollama for local AI support:

https://ollama.com

Install Llama 3 model:

ollama pull llama3
Installation
Clone Repository
git clone https://github.com/yourusername/automated-printer-troubleshooter.git
Run Script

Open PowerShell as Administrator:

Set-ExecutionPolicy Bypass -Scope Process
.\PrinterTroubleshooter.ps1
Application Functions
Check Status
Displays printer status
Shows queue information
Restart Spooler
Restarts Windows Print Spooler service
Clear Queue
Removes stuck print jobs
Connectivity Test
Tests printer network communication
Full System Diagnostic

Runs all troubleshooting tasks automatically and sends issues to the AI assistant for analysis.

AI Assistant

The integrated AI assistant:

Analyzes printer errors
Suggests likely causes
Provides recommended fixes
Uses local offline AI processing

Example AI output:

Summary:
Printer is unreachable on the network.

Likely Cause:
Printer IP address is offline or disconnected.

Recommended Actions:
1. Verify printer power/network connection
2. Ping printer IP manually
3. Restart printer and router
Project Structure
.
├── PrinterTroubleshooter.ps1
├── README.md
└── assets/
Security Notes
Runs locally only
No cloud API usage
AI processing remains offline through Ollama
Requires administrator privileges for spooler operations
Future Improvements
Export diagnostic reports
Auto driver repair
SNMP printer monitoring
Remote printer management
Multi-printer diagnostics
PDF report generation
License

MIT License

Author

Developed for IT Helpdesk automation and printer troubleshooting workflows.
