Moje IP:10.0.0.181 


1. Wykonałem skan nmap -sn 10.0.0.0/24 w celu znalezienia aktywnych urządzeń w sieci. Znalazłem urządzenia z końcówkami 1,180 oraz 182( moje urządzenie)
2.Wykonuję nmap -A -T4 -Pn -p- -o ~/Dokumenty/nmap_initial 10.0.0.180


Po wykonaniu komendy curl http://10.0.0.180
otrzymałem poniższą flagę:
<! --Good job! part_6_h== -->

Skan nmap trwa wyjątkowo długo


Skan nmap znalazł otwarte porty: 21,22,23,25,53,80,443,3128,3306,9090
#PORT 21
1. Pierwszy otwarty port 21 ftp możliwe logowanie anonimowe, ftp 10.0.0.180 połączenie udane z uzyciem anonymous, znaleziony plik part_4_bU po uzyciu cat
Good job!  


#PORT 22,23 
port SSH - chciałem wykonać brute force z użyciem hydry i wordlisty rockyou w /usr/share/wordlist, ale była spakowana, przy próbie odpakowania dostałem komunikat o braku uprawnień
- telnet i ssh nie udało mi się zalogować z podstawowymi danymi, jako login próbowałem root i admin, jako haseł password, root, toor, admin


#PORT 80 
dirbuster znalazł /cgi-bin/ w środku którego szukałem plików o rozszerzeniu php,sh,py,cgi,nic nie znalazłem,  oraz /icons w którym też nic ciekawego nie było

nmap na porcie 80 dał znać o potencjalnie niebezpiecznej metodzie TRACE
curl z metoda trace nic nie zwrócił 
```
└─$ curl --insecure -v -X TRACE 10.0.0.180
*   Trying 10.0.0.180:80...
* Connected to 10.0.0.180 (10.0.0.180) port 80 (#0)
> TRACE / HTTP/1.1
> Host: 10.0.0.180
> User-Agent: curl/7.74.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Date: Tue, 11 May 2021 12:39:54 GMT
< Server: Apache/2.4.37 (centos)
< Transfer-Encoding: chunked
< Content-Type: message/http
<
TRACE / HTTP/1.1
Host: 10.0.0.180
User-Agent: curl/7.74.0
Accept: */*

* Connection #0 to host 10.0.0.180 left intact

```

-searchsploit na apache 2.4 znalazł z interesujących rzeczy tylko privilege escalation

#PORT 25
uruchomiłem scanner w metasplot smtp_enum, który znalazł poniższych użytkowników

```
Users found: , adm, admin, avahi, bin, chrony, cockpit-ws, colord, daemon, dbus, dnsmasq, fax, ftp, games, gdm, geoclue, gnome-initial-setup, gopher, halt, libstoragemgmt, lp, mail, mysql, news, nobody, ntp, operator, polkitd, postfix, postgres, postmaster, pulse, rpc, rpcuser, rtkit, setroubleshoot, shutdown, sshd, sssd, sync, systemd-coredump, systemd-resolve, tcpdump, tss, uucp, webmaster, www

```

#PORT 53 DNS

```
└─$ dig 10.0.0.180                                                                                                                                                                                                                       1 ⚙

; <<>> DiG 9.16.12-Debian <<>> 10.0.0.180
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 10646
;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;10.0.0.180.                    IN      A

;; AUTHORITY SECTION:
.                       9136    IN      SOA     a.root-servers.net. nstld.verisign-grs.com. 2021051100 1800 900 604800 86400

;; Query time: 0 msec
;; SERVER: 10.0.0.1#53(10.0.0.1)
;; WHEN: wto maj 11 14:56:52 CEST 2021
;; MSG SIZE  rcvd: 114

```
nslookup nie dał mi pomocnych informacji


#PORT 3306 SQL
użyłem sqlmap 10.0.0.180, nie zapisałem wyniku ale nie było tam nic interesującego, nie miałem dość czasu na szukanie exploitów na MySQL 8.0.21 

#PORT 3128 
- port 3128 strona z błędem

#PORT 9090
próbowałem sprawdzić na Firefoxie dany port, nie znalazłem nic

#FLAGI
Udało mi się odnaleźć jedynie dwie flagi, 4 oraz 6:
```
<! --Good job! part_6_h== -->
part_4_bU - Good job!  
```
flaga 6 - port 80 komentarz na stronie
flaga 4 - plik udostępniony w ftp