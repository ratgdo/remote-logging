# remote-logging
Scripts for remote logging data from ratgdo

## macos & linux
* Usage: `./ratgdo-logger.sh <RATGDO HOSTNAME OR IP>`
* To capture to a file append the command with: ` > my.log`

```
mbpm3:remote-logging paul$ ./ratgdo-logger.sh 10.0.1.191
Pinging 10.0.1.191...
✅ Host 10.0.1.191 is reachable.
Checking firmware type...
✅ ratgdo-esphome detected
2025-08-01T12:20:03Z data: [D][ratgdo_secplus2:322]: Received packet: : [55 01 00 94 3F 38 DA FC 72 BE FF 91 12 E9 D0 02 A9 74 9C]
2025-08-01T12:20:03Z data: [D][ratgdo:120]: Door state=CLOSED
2025-08-01T12:20:03Z data: [D][ratgdo:229]: Light state=OFF
2025-08-01T12:20:03Z data: [D][ratgdo:235]: Lock state=UNLOCKED
2025-08-01T12:20:03Z data: [D][ratgdo:214]: Learn state=INACTIVE
```
