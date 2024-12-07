# Felhő és DevOps alapok

## Projektmunka

### Előfeltételek
* docker
* `terraform` parancs beállítva a gyakorlat mintájára
* nyitott portok:
  * 80 *(nginx)*
  * 4200 *(frontend)*
  * 10050 *(frontend)*
  * 5000 *(backend)*
  * 27017 *(mongodb - prf)*
  * 8080 *(zabbix - web)*
  * 8443 *(zabbix - web)*
  * 5044 *(graylog)*
  * 5140 *(graylog)*
  * 5555 *(graylog)*
  * 9000 *(graylog)*
  * 12201 *(graylog)*
  * 13302 *(graylog)*
  * 10051 *(zabbix - mysql)*
  * 8999 *(graylog - datanode)*
  * 9200 *(graylog - datanode)*
  * 9300 *(graylog - datanode)*
  * 10052 *(zabbix - gateway)*
  * 3306 *(mysql)*

### Projekt elindítása
1. navigálj a `pdf-app` mappába
2. add ki a `terraform init` parancsot
3. add ki a `terraform plan` parancsot
4. add ki a `terraform apply` parancsot

### Projekt leírás

A kiinduló projekt a fórumon megosztott terraformba helyezett prf (angular-mongo-nodejs) app.

Ez kibővítve egy futó Nginx szerverrel ami a kiinduló alkalmazás egyszerűbb elérését biztosítja. Logolásra Graylog, monitorozásra Zabbix szolgáltatások futnak, az angular-app  és a nodejs-app összeköthető velük.

TODO: nodejs-app logolásra és monitorozásra kötése

### Nginx
TODO

### Graylog
TODO

### Zabbix
TODDO
