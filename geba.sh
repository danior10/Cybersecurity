#!/bin/bash
echo facebook.com >> url.txt
echo mail.google.com >> url.txt
echo allegro.pl >> url.txt
echo youtube.com >> url.txt
echo amtso.org/feature-settings-check-drive-by-download/ >> url.txt
echo pornhub.com >> url.txt
echo wetransfer.com >> url.txt

while IFS="/" read NET MASK;
do
clear
echo 'Tworzenie folderu:' ${NET}_${MASK}
mkdir ${NET}_${MASK}
echo 'Start:'$(date) > ${NET}_${MASK}/_raport.txt
echo 'Tworzenie folderu:' ${NET}_${MASK} >> ${NET}_${MASK}/_raport.txt

#----------------------------------------------------------------------------------------------------------
echo 'Tworzenie listy hostów:'
echo 'nmap -p 445'
nmap -p 445 $NET/$MASK -oA ${NET}_${MASK}/port_smb | awk '/is up/ {print up}; {gsub (/\(|\)/,""); up = $NF}' > ${NET}_${MASK}/smb.txt
#----------------------------------------------------------------------------------------------------------

echo 'fping -s -g'
fping -g -A -a ${NET}/${MASK} >> ${NET}_${MASK}/fping.txt
clear

#----------------------------------------------------------------------------------------------------------

echo 'Tworzenie pliku hosts.txt'

cat ${NET}_${MASK}/fping.txt >> ${NET}_${MASK}/hosts.txt
cat ${NET}_${MASK}/smb.txt >> ${NET}_${MASK}/hosts.txt
sort ${NET}_${MASK}/hosts.txt | uniq >> ${NET}_${MASK}/hosts_sorted.txt 

#----------------------------------------------------------------------------------------------------------

echo 'use auxiliary/scanner/ftp/anonymous' >> ${NET}_${MASK}/ftp.rc
echo 'set rhosts '${NET}/${MASK} >> ${NET}_${MASK}/ftp.rc
echo 'set threads 10000' >> ${NET}_${MASK}/ftp.rc
echo 'run' >> ${NET}_${MASK}/ftp.rc
echo 'exit' >> ${NET}_${MASK}/ftp.rc

echo 'Weryfikacja logowania anoniomowego do serwerów FTP'
msfconsole -r ${NET}_${MASK}/ftp.rc |grep '\[+\]' >> ${NET}_${MASK}/ftp_anonymous.txt
rm ${NET}_${MASK}/ftp.rc
clear

#----------------------------------------------------------------------------------------------------------

echo 'use auxiliary/scanner/smtp/smtp_relay' >> ${NET}_${MASK}/smtp.rc
echo 'set rhosts '${NET}/${MASK} >> ${NET}_${MASK}/smtp.rc
echo 'set threads 10000' >> ${NET}_${MASK}/smtp.rc
echo 'run' >> ${NET}_${MASK}/smtp.rc
echo 'exit' >> ${NET}_${MASK}/smtp.rc

echo 'Weryfikacja open-relay dla serwera pocztowego'
msfconsole -r ${NET}_${MASK}/smtp.rc >> ${NET}_${MASK}/smtp_open_relay.txt
rm ${NET}_${MASK}/smtp.rc
clear

#----------------------------------------------------------------------------------------------------------
echo 'use auxiliary/scanner/rdp/rdp_scanner' >> ${NET}_${MASK}/rdp.rc
echo 'set rhosts '${NET}/${MASK} >> ${NET}_${MASK}/rdp.rc
echo 'set threads 10000' >> ${NET}_${MASK}/rdp.rc
echo 'run' >> ${NET}_${MASK}/rdp.rc
echo 'exit' >> ${NET}_${MASK}/rdp.rc

echo 'Uruchamianie metasploita i szukanie hostów z pulpitem zdalnym'
msfconsole -r ${NET}_${MASK}/rdp.rc | grep 'Detected'>> ${NET}_${MASK}/rdp.txt
rm ${NET}_${MASK}/rdp.rc
clear

#----------------------------------------------------------------------------------------------------------

echo 'Przeszukiwanie sieci (80,81,82,88,443,3128,8000,8001,8080,8081,8443)'
nmap -p 80,81,82,88,443,3128,8000,8001,8080,8081,8443 ${NET}/${MASK} -oG ${NET}_${MASK}/${NET}_${MASK}_sieci.gnmap
cat ${NET}_${MASK}/${NET}_${MASK}_sieci.gnmap | grep '80/open' | awk '{print $2}' >> ${NET}_${MASK}/${NET}_${MASK}_http.txt
cat ${NET}_${MASK}/${NET}_${MASK}_sieci.gnmap | grep '81/open' | awk '{print $2}' >> ${NET}_${MASK}/${NET}_${MASK}_http.txt
cat ${NET}_${MASK}/${NET}_${MASK}_sieci.gnmap | grep '82/open' | awk '{print $2}' >> ${NET}_${MASK}/${NET}_${MASK}_http.txt
cat ${NET}_${MASK}/${NET}_${MASK}_sieci.gnmap | grep '88/open' | awk '{print $2}' >> ${NET}_${MASK}/${NET}_${MASK}_http.txt
cat ${NET}_${MASK}/${NET}_${MASK}_sieci.gnmap | grep '443/open' | awk '{print $2}' >> ${NET}_${MASK}/${NET}_${MASK}_http.txt
cat ${NET}_${MASK}/${NET}_${MASK}_sieci.gnmap | grep '3128/open' | awk '{print $2}' >> ${NET}_${MASK}/${NET}_${MASK}_http.txt
cat ${NET}_${MASK}/${NET}_${MASK}_sieci.gnmap | grep '8000/open' | awk '{print $2}' >> ${NET}_${MASK}/${NET}_${MASK}_http.txt
cat ${NET}_${MASK}/${NET}_${MASK}_sieci.gnmap | grep '8001/open' | awk '{print $2}' >> ${NET}_${MASK}/${NET}_${MASK}_http.txt
cat ${NET}_${MASK}/${NET}_${MASK}_sieci.gnmap | grep '8080/open' | awk '{print $2}' >> ${NET}_${MASK}/${NET}_${MASK}_http.txt
cat ${NET}_${MASK}/${NET}_${MASK}_sieci.gnmap | grep '8081/open' | awk '{print $2}' >> ${NET}_${MASK}/${NET}_${MASK}_http.txt
cat ${NET}_${MASK}/${NET}_${MASK}_sieci.gnmap | grep '8443/open' | awk '{print $2}' >> ${NET}_${MASK}/${NET}_${MASK}_http.txt
clear

#-----------------------------------------------------------------------------------------------------------

echo 'Tworzenie podfolderu z wynikami skanowania'
mkdir ${NET}_${MASK}/Zrzuty_ekranu

#-----------------------------------------------------------------------------------------------------------

while read ADDRESS;
do
echo 'Wykonywanie zrzutów ekranu dla HTTP'
cutycapt --url=http://${ADDRESS} --out=${NET}_${MASK}/Zrzuty_ekranu/${ADDRESS}_http.png --delay=5000 --max-wait=10000
cutycapt --url=https://${ADDRESS} --out=${NET}_${MASK}/Zrzuty_ekranu/${ADDRESS}_https.png --insecure --delay=5000 --max-wait=10000
clear
done < ${NET}_${MASK}/${NET}_${MASK}_http.txt

#-----------------------------------------------------------------------------------------------------------

echo "Weryfikacja portów i podatności dla aktywnych hostów w sieci"
nmap -A -T 4 -sV --script vulners ${NET}/${MASK} -oX ${NET}_${MASK}/${NET}_${MASK}_vulners.xml -oG ${NET}_${MASK}/${NET}_${MASK}_vulners.gnmap
xsltproc ${NET}_${MASK}/${NET}_${MASK}_vulners.xml -o ${NET}_${MASK}/${NET}_${MASK}_vulners.html
clear

#-----------------------------------------------------------------------------------------------------------

echo "grepowanie pliku gnmap dla otwartych portow 389 (LDAP)"
cat ${NET}_${MASK}/${NET}_${MASK}_vulners.gnmap | grep '389/open' | awk '{print $2}' >> ${NET}_${MASK}/ldap.txt

while read ADDRESS;
do
echo 'Listowanie użytkowników w domenie'
enum4linux -U -l ${ADDRESS} | grep -Po '(?<=(user:\[)).*(?=\] )' >> ${NET}_${MASK}/domain_users_${ADDRESS}.txt
clear
done < ${NET}_${MASK}/ldap.txt



done < sieci.txt
