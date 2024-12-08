# Felhő és DevOps alapok

## Projektmunka

### Előfeltételek
* docker
* **[CSAK MANUÁLIS FUTTATÁS ESETÉN]** `terraform` parancs beállítva a gyakorlat mintájára
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
  * 8090 *(jenkins)*
  * 50000 *(jenkins)*

### Projekt elindítása
Fontos lehet, hogy sudo nélkül tudnod kell docker-t futtatni (`sudo usermod -aG docker $USER`, majd restart)

1. Navigálj a `jenkins` mappába
2. Addi ki a `docker compose up --build` parancsot
3. Várd meg míg elindul a jenkins
4. Navigálj a kedvenc webböngésződben a `localhost:8090` címre, ahol megtalálod a jenkins-t
5. Nem engedett mindent felcommitolni, lehet rászorul a jenkins egy plugin oldalon install plugins nyomásra, de a fontos pluginok amik kellenek:
  * `Docker pipeline`
  * `Terraform Plugin`
6. Indítsd el a `In a completely sane world, madness is the only freedom` nevű job-ot és nézegesd a logokat amíg dolgozik
7. Örömmel ünnepelj miután egy zöld pipát és `Pipeline completed successfully.` üzenetet látsz
8. Ha le akarod állítani, akkor sajnos terminálban kell kiadnod a `terraform destroy` parancsot

Manuális indítás (ha a jenkins nagyon nem menne [nálam ment]):
1. navigálj a `pdf-app` mappába
2. add ki a `terraform init` parancsot
3. add ki a `terraform plan` parancsot
4. add ki a `terraform apply` parancsot

### Projekt elérése
Az applikációt eléred a webböngésződben az URL-be `localhost` beírásával (**port nélkül**). Itt tudsz regisztrálni, belépni és nézegetni a fakebook felhasználódat.

A monitorozó applikációkat eléred a
* Graylog: `localhost:9000` URL-en
  * Belépéshez szükséges adatok:
    * username: `admin`
    * password: meg kell sajnos nézned ezzel a paranccsal: `docker logs graylog`, innen kell bemásolni a generált jelszót
  * Használata
    1. Pörgesd végig a kezdeti lépéseket, várd meg míg átadja a cert-et a datanode-nak, majd nyomj a `Resume startup` gombra
    2. A modern felületen lépj be ezzel a felhasználóval:
      * username: `admin`
      * password: `admin`
    3. Navigálj a `System/Inputs` menüre
    4. Válaszd ki a `Syslog UDP` opciót, majd nyomj a `Launch new input` gombra
    4. Állítsd be a portot 5140-re!!!
    5. Nevezd el, állíts be tetszőleges időzónát, majd hozd létre a `Launch input` gombbal
    6. Nézd, hogy jönnek a logok a forntend és backend felől is
    7. Többet láthatsz a `Search` menüpontban, ahol a nodejs és angular hostnammel ellátott containerek is küldenek logokat ha nyomogatod a logint valid adatokkal
* Zabbix: `localhost:8080` URL-en
  * Belépéshez szükséges adatok:
    * username: `Admin`
    * password: `zabbix`
  * Használata:
    1. Navigálj a `Monitoring/Hosts` menüre
    2. Jobb fent -> `Create host`
    3. Ismételd meg kétszer ezekkel a paraméterekkel:
      * Host name: `prf-project-angular`, `prf-project-nodejs`
      * Templates: `Linux by Zabbix agent active`
      * Host groups: `Linux servers`
      * Interfaces: Fel fogja a hostname alapján ismerni, nem kell megadni az ip-ket (amúgy `172.100.0.20 (angular)` és `172.100.0.10 (nodejs)` lenne default proton)
    4. Várd meg míg kizöldül a ZBX icon, utána tudod nézegetni a dashboardját

### Projekt leírás

A projekt a saját prf "fakebook" projektem. Kiindultam a gyak dokumentumokba feltöltött tf fájlokból, átírtam a saját git repom-ra, javítottam a mappákat és így indul a projekt. Működik a csatlakozás a frontend - backend - mongodb között.

Ez kibővítve egy futó Nginx szerverrel ami a kiinduló alkalmazás egyszerűbb elérését biztosítja. Logolásra Graylog, monitorozásra Zabbix szolgáltatások futnak, az angular-app  és a nodejs-app összeköthető velük.

Az egész jenkinsből egy jobot futtatva szépen előáll, igazából a jenkins compose fájlja futtatása után csak egy job futtatást igényel.

### Fakebook
Át lett módosítva sok fájl benne, minden ami localhost-ra mutatott, már szépen az ip-re mutat.

Erről többet itt találsz: https://github.com/hirschabel/fakebook/tree/devops

Commit: https://github.com/hirschabel/fakebook/commit/1bd19cfce288265a47b717c39c0cd3c2306aa513

Egy rákövetkező commit megoldotta a csatlakozási problémákat a backend és mongodb között, most már sikeres a kommunikáció. 

### Nginx
Annyit csinál, hogy a localhost-t beírva (localhost:80) átirányítja a user-t a localhost:4200-on futó angular felé.

A `http://test-app.test`-re érkező kéréseket is továbbítja, de nem tartozik hozzá dns szerver, magunknak kell felvenni, vagy nem felvenni.

### Graylog és Zabbix
Fentebb található a leírás a beüzemelésről.

A projektbe bevonásuk trükkös volt.

A tett lépések:
1. Dockerfileokba (angular, node) bekerült az extra 10050 port nyitása
2. Dockerfileokba bekerült a zabbax agent és rsyslog config a gyakanyagnak megfelelően.
3. Dockerfileokba át lett másolva egy start.sh (`start-angular.sh` és `start-nodejs.sh`)
  * Ezek érdekesek, az angular szinte megegyezik a gyakanyaggal, logolás átirányítása és zabbix agent indítása van benne
  * A node ennek a másolata, az utolsó sor változott, mivel máshogy kell indítani. ugyanúgy átirányítjuk a logokat
4. 2 új terraform modul jött létre:
  * graylog és zabbix
  * frissítve lettek az ip-k, hogy ne ütközzenek a már meglévőkkel

## Használt tool-ok
* Terraform
* Nginx
* Graylog
* Zabbix
* Jenkins

