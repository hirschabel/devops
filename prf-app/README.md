# Programrendszerek fejlesztése projekt infrastruktúra leírása Terraform segítségével

Ez a minta segít bemutatni, hogyan kell egy komplexebb alkalmazás (kliens, szerver, adatbázis) infrastruktúráját leírni Terraform segítségével. Mindent Docker konténerekkel valósítottam meg.

## Projekt leírása

Az egész alapját az alábbi projekt képezi: https://github.com/jankiz/Program-systems-development/tree/release/devops
branch: release/devops

Az egyes rendszerelemekben átírásra kerültek a végpontok és a portok IP-szinten. A rendszer valamennyi komponense a 172.100.0.0/16 alhálózaton foglal helyet.

> Ha nginx mögé szeretnénk betenni a projektet, és domain-ekkel dolgozni IP-címek helyett, akkor gondoskodni kell arról, hogy a megfelelő domain-ekre hivatkozzunk, és azokra vonatkozóan legyen megoldott a DNS feloldás is.

## MongoDB

IP: 172.100.0.30
Port: 27017
Dockerfile: Dockerfile_mongodb

Ehhez nem indokolt a Dockerfile, de a tisztánlátás végett készítettem egyet mindenféle felülírás nélkül.

## NodeJS szerver

IP: 172.100.0.10
Port: 5000

A szerver kódban az alábbi átírások történtek:
- server/src/index.ts: 15. sor: dbUrl értéke (MongoDB elérési útvonal)
- server/src/index.ts: 25. sor: whiteList értéke (Angular alkalmazás engedélyezése a cross-origin kérésekben)

Futtatás:
A pm2-runtime-ot használjuk a futtatáshoz, azonban ehhez build-elni kell előbb a TypeScript kódot. A build-elt kód a server/build mappában foglal helyet.

## Angular alkalmazás

IP: 172.100.0.20
Port: 4200

A kliens kódban az alábbi átírások történtek:
- client/my-first-project/src/app/shared/services/auth.service.ts: 23. sor: NodeJS szerver végponthoz megfelelő IP-cím és port megadása
- client/my-first-project/src/app/shared/services/auth.service.ts: 39. sor: NodeJS szerver végponthoz megfelelő IP-cím és port megadása
- client/my-first-project/src/app/shared/services/auth.service.ts: 43. sor: NodeJS szerver végponthoz megfelelő IP-cím és port megadása
- client/my-first-project/src/app/shared/services/auth.service.ts: 47. sor: NodeJS szerver végponthoz megfelelő IP-cím és port megadása
- client/my-first-project/src/app/shared/services/user.service.ts: 13. sor: NodeJS szerver végponthoz megfelelő IP-cím és port megadása
- client/my-first-project/src/app/shared/services/user.service.ts: 17. sor: NodeJS szerver végponthoz megfelelő IP-cím és port megadása

Futtatás:
A best practice-t követve nem ng serve paranccsal futtatjuk, hanem itt is a pm2-runtime-ot használjuk a http-server modullal együtt. Ehhez build-elni kell a kódot egy ng build paranccsal, aminek az eredménye a client/my-first-project/dist/my-first-project/browser mappába kerül.

## Terraform leírás

Minden rendszerelemet külön Terraform modulban definiáltam. Minden konténer egy példányban fut, és a megfelelő Dockerfile-ból indul ki. A külső Terraform leírásban (fő main.tf fájlban) a modulok sorrendjét a felépítés sorrendjében raktam össze. Először az adatbázis jön létre, azt követően a szerver, ami rácsatlakozik, végül a kliens, amin keresztül kéréseket tudunk indítani a szerver felé. A portok ki lettek szervezve Terraform változók formájában.

## Az indításhoz szükséges parancsok

```sh
$ terraform init
$ terraform plan
$ terraform apply
```

## A leállításhoz és minden infrastruktúra elem megszüntetéséhez szükséges parancsok

```sh
$ terraform destroy
```

Szerző: Dr. Jánki Zoltán R.