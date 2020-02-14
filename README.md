# GeoIP Updater  
This Docker image is based on the current stable Debian version and contains `geoipupdater` package as well as `crond` to run periodical MaxMind's GeoDB updates.

MaxMind's account is required [website](https://www.maxmind.com/en/geolite2/signup) you have to register in order to get Account ID and License Key.  

### Variables default values
GeoIP Updater configuration file path  
`GeoIP_Conf=/etc/GeoIP.conf`  

GeoIP Updater Account ID  
`GeoIP_AccountID=000000`  

GeoIP Updater License Key  
`GeoIP_LicenseKey=null`  

GeoIP Database Directory path  
`GeoIP_DatabaseDirectory=/usr/share/GeoIP`  

GeoIP Updates Host  
`GeoIP_Host=updates.maxmind.com`

GeoIP Updater Preserve File Times  
`GeoIP_PreserveFileTimes=0`  

GeoIP Updater HTTP Proxy parameters (used only when declared)  
`GeoIP_Proxy=127.0.0.1:8888`  
`GeoIP_ProxyUserPass=username:password`

Cron jobs list may contain several jobs, one per line, as in the example below (try to avoid special characters it may not work correctly):
```yaml
environment:
  - JOBS_LIST="*/30 * * * * root /usr/bin/geoipupdate -v" 
              "* */12 * * * root /usr/bin/geoipupdate"
```

### Example docker-compose.yml  
```yaml
version: "2"

volumes:
  geoipdb:

services:
  geoipupdater:
    image: kefirgames/geoipupdate-cron:latest
    environment:
      - GeoIP_AccountID=12345
      - GeoIP_LicenseKey=keypassphrase
      - JOBS_LIST="* */12 * * * root /usr/bin/geoipupdate"
    volumes:
      - geoipdb:/usr/share/GeoIP

  http:
    image: nginx
    volumes:
      - /var/www:/var/www
      - geoipdb:/usr/share/GeoIP:ro
    ports:
      - 80:80

```

