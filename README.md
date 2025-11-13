# 🌙 Moontool

A cross-platform CLI tool for Moonraker/Klipper 3D printers. Control your printer from the command line with simple commands - home axes, set temperatures, send G-code, check status, and cool down. Works on Linux, macOS, and Windows (Git Bash). No dependencies except curl. Modular design for easy expansion.

## 📋 Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Modules](#modules)
- [Requirements](#requirements)
- [Credits](#credits)
- [License](#license)

## ✨ Features

- **Simple Commands**: No more complex curl commands - just straightforward CLI
- **Cross-Platform**: Works on Linux, macOS, and Windows (with Git Bash)
- **Modular Design**: Easy to extend with new functionality
- **Zero Dependencies**: Only requires curl (included with Git Bash)
- **Human-Readable Output**: Clean, formatted responses instead of raw JSON

## 🚀 Installation

### Linux / macOS

1. Download moontoolinstaller-linux.sh
2. Run the install script (moontoolinstaller-linux.sh)

### Windows

1. Install [Git for Windows](https://git-scm.com/download/win) (includes Git Bash)
2. Download 'moontoolinstaller-windows.exe' from the Releases section
3. Run `moontoolinstaller-windows.exe`
4. Follow the steps given by the installer
5. ensure run moontool.bat is checked - otherwise the program will not install

## 📖 Usage

### Basic Command Structure

**Linux/macOS:**
```bash
./moontool.sh <module> [function] --<ip:port> [args...]
```

**Windows:**
```cmd
moontool.bat <module> [function] --<ip:port> [args...]
```

### Examples

```bash
# Home all axes
moontool home --192.168.1.100:7125

# Set hotend temperature
moontool temps set --192.168.1.100:7125 hotend 200

# Check printer status
moontool status --192.168.1.100:7125

# Send custom G-code
moontool gcode --192.168.1.100:7125 G28 X Y

# Cool down everything
moontool cooling --192.168.1.100:7125

# Get current temperatures
moontool temps --192.168.1.100:7125
```

## 🔧 Modules

### `cooling`
Set all temperatures (hotend and bed) to 0°C.

```bash
moontool cooling --<ip:port>
```

### `gcode`
Send any G-code command to the printer.

```bash
moontool gcode --<ip:port> <gcode_command>
```

Examples:
```bash
moontool gcode --192.168.1.100:7125 G28
moontool gcode --192.168.1.100:7125 "G1 X100 Y100 F3000"
moontool gcode --192.168.1.100:7125 M104 S200
```

### `home`
Home all axes (runs G28).

```bash
moontool home --<ip:port>
```

### `status`
Get current printer status with clean, formatted output.

```bash
moontool status --<ip:port>
```

Output example:
```
Status: Printing
File: test_print.gcode
Hotend: 210°C / 210°C
Bed: 60°C / 60°C
```

### `temps`
Get or set temperatures for hotend and bed.

**Get temperatures:**
```bash
moontool temps --<ip:port>
moontool temps get --<ip:port>
```

**Set temperatures:**
```bash
moontool temps set --<ip:port> hotend <temperature>
moontool temps set --<ip:port> bed <temperature>
```

Examples:
```bash
moontool temps set --192.168.1.100:7125 hotend 200
moontool temps set --192.168.1.100:7125 bed 60
```

## 📦 Requirements

- **Linux/macOS**: bash, curl (usually pre-installed)
- **Windows**: [Git for Windows](https://git-scm.com/download/win) (includes Git Bash and curl)

## 💡 Credits

**Project Concept, Design & Direction**: Created by the repository owner

**Implementation**: Built with AI assistance (Claude by Anthropic)

**This project was made by AI, but the idea was mine.** The concept, architecture, feature requirements, and design decisions are entirely original human work. AI was used as a development tool to implement the vision.

## 🛠️ Project Structure

```
moontool/
├── moontool.sh          # Main controller (Linux/macOS)
├── moontool.bat         # Windows wrapper
├── modules/
│   ├── cooling/
│   │   └── main.sh      # Cooling module
│   ├── gcode/
│   │   └── main.sh      # G-code sender
│   ├── home/
│   │   └── main.sh      # Homing module
│   ├── status/
│   │   └── main.sh      # Status checker
│   └── temps/
│       ├── get.sh       # Get temperatures
│       └── set.sh       # Set temperatures
└── README.md
```
