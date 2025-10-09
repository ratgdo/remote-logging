# remote-logging
Scripts useful for remote logging data from ratgdo

# Usage
## macOS & *nix

1. Download or clone this repository
1. Open a shell prompt (Terminal.app in macOS)
1. `cd <path_where_downloaded>`
1. ./ratgdo-logger.sh <ratgdo_ip_or_hostname> > ratgdo.log

Use ctrl+c to stop the capture.

This will log the output to `ratgdo.log` which you can then open later with a text editor or log viewer. 

## Windows PowerShell

1. Download or clone this repository
1. Open a powershell prompt (Start Menu -> all apps -> Terminal, or search for PowerShell)
1. `cd <path_where_downloaded>`
1. .\ratgdo-logger.ps1 -HostName <ratgdo_ip_or_hostname> > logfile.log

Use ctrl+c to stop the capture.

This will log the output to `ratgdo.log` which you can then open later with a text editor or log viewer. 
