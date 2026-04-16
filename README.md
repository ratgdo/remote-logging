Scripts for remote logging data from ratgdo

## macOS & Linux
* Usage: `./ratgdo-logger.sh <RATGDO HOSTNAME OR IP> [OPTIONAL OUTPUT LOG FILE]`
* To capture to a file append the optional `[OPTIONAL OUTPUT LOG FILE]`.
* Optionally, you can specify the ratgdo hostname/ip and output log file by
  setting the environment variables `HOST` and `LOG_FILE`, respectively.

**Example:**
```bash
$ ./ratgdo-logger.sh 10.0.1.191
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

## Windows PowerShell
* Usage: `.\ratgdo-logger.ps1 -HostName <RATGDO HOSTNAME OR IP>`
* To capture to a file append the command with: ` > my.log`

## Docker

**Launch background log collector:**

```bash
docker run -d -e HOST="<RATGDO HOSTNAME OR IP>" \
    -v ratgdo-log:/log \
    --name ratgdo-logger \
    --restart unless-stopped \
    ghcr.io/ratgdo/remote-logging:latest
```

**Show logs:**

```bash
# add -f for live logs
docker logs ratgdo-logger
# or
docker run --rm -v ratgdo-log:/l busybox cat /l/ratgdo.log
```

**Stop collection:**

```bash
docker stop ratgdo-logger
```

<details>
<summary><b>Compose/stack example</b></summary>

```yaml
version: "3.8"
services:
  ratgdo-logger:
    image: ghcr.io/ratgdo/remote-logging:latest
    environment:
      HOST: "<RATGDO HOSTNAME OR IP>"
    volumes:
      - ratgdo-log:/log
    restart: unless-stopped
volumes:
  ratgdo-log:
```
</details>
