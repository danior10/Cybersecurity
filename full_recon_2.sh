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
echo ---------------------------------------------------------------------------------------------------------- >> ${NET}_${MASK}/_raport.txt
echo 'Tworzenie listy hostów:'
echo 'nmap -sn'
echo 'Tworzenie listy hostów:'>> ${NET}_${MASK}/_raport.txt
echo 'nmap '>> ${NET}_${MASK}/_raport.txt
nmap -sn ${NET}/${MASK}| grep for | awk -F " " '{print $5}' >> ${NET}_${MASK}/nmap_hosts.txt
cat ${NET}_${MASK}/nmap_hosts.txt >> ${NET}_${MASK}/_raport.txt
echo 'fping -s -g'
echo ---------------------------------------------------------------------------------------------------------- >> ${NET}_${MASK}/_raport.txt
echo 'fping -s -g'>> ${NET}_${MASK}/_raport.txt
fping -s -g ${NET}/${MASK} | grep alive >> ${NET}_${MASK}/fping.txt
cat ${NET}_${MASK}/fping.txt | awk -F " " '{print $1}' >> ${NET}_${MASK}/fping_hosts.txt
cat ${NET}_${MASK}/fping_hosts.txt >> ${NET}_${MASK}/_raport.txt
rm ${NET}_${MASK}/fping.txt
clear

network=$(echo ${NET}| awk -F "." '{print $1"."$2}')
cat ${NET}_${MASK}/nmap_hosts.txt >> ${NET}_${MASK}/hosts_tmp.txt
cat ${NET}_${MASK}/fping_hosts.txt >> ${NET}_${MASK}/hosts_tmp.txt
cat ${NET}_${MASK}/hosts_tmp.txt | awk -F " " '{print $1}' | grep ${network} | awk '!a[$0]++' >> ${NET}_${MASK}/hosts.txt
rm ${NET}_${MASK}/hosts_tmp.txt

#----------------------------------------------------------------------------------------------------------
if [[ -f ${NET}_${MASK}/hosts.txt && -s ${NET}_${MASK}/hosts.txt ]];
then

#-----------------------------------------------------------------------------------------------------------
echo ---------------------------------------------------------------------------------------------------------- >> ${NET}_${MASK}/_raport.txt
echo 'Uruchamianie metasploita i przeszukiwanie sieci'
echo 'Uruchamianie metasploita i przeszukiwanie sieci' >> ${NET}_${MASK}/_raport.txt
echo 'trwa skanowanie... to może chwilę potrwać...'

#----------------------------------------------------------------------------------------------------------
echo ---------------------------------------------------------------------------------------------------------- >> ${NET}_${MASK}/_raport.txt
echo 'use auxiliary/scanner/ftp/ftp_version' >> ${NET}_${MASK}/ftp.rc
echo 'set rhosts '${NET}/${MASK} >> ${NET}_${MASK}/ftp.rc
echo 'set threads 10000' >> ${NET}_${MASK}/ftp.rc
echo 'run' >> ${NET}_${MASK}/ftp.rc
echo 'exit' >> ${NET}_${MASK}/ftp.rc

echo 'Uruchamianie metasploita i szukanie serwerów FTP'
echo 'Uruchamianie metasploita i szukanie serwerów FTP' >> ${NET}_${MASK}/_raport.txt
msfconsole -r ${NET}_${MASK}/ftp.rc | grep '\[+\]'>> ${NET}_${MASK}/ftp.txt
cat ${NET}_${MASK}/ftp.txt >> ${NET}_${MASK}/_raport.txt
rm ${NET}_${MASK}/ftp.rc
clear

#----------------------------------------------------------------------------------------------------------
echo ---------------------------------------------------------------------------------------------------------- >> ${NET}_${MASK}/_raport.txt
echo 'use auxiliary/scanner/ftp/anonymous' >> ${NET}_${MASK}/ftp.rc
echo 'set rhosts '${NET}/${MASK} >> ${NET}_${MASK}/ftp.rc
echo 'set threads 10000' >> ${NET}_${MASK}/ftp.rc
echo 'run' >> ${NET}_${MASK}/ftp.rc
echo 'exit' >> ${NET}_${MASK}/ftp.rc

echo 'Weryfikacja logowania anoniomowego do serwerów FTP'
echo 'Weryfikacja logowania anoniomowego do serwerów FTP' >> ${NET}_${MASK}/_raport.txt
msfconsole -r ${NET}_${MASK}/ftp.rc |grep '\[+\]' >> ${NET}_${MASK}/ftp_anonymous.txt
cat ${NET}_${MASK}/ftp_anonymous.txt >> ${NET}_${MASK}/_raport.txt
rm ${NET}_${MASK}/ftp.rc
clear

#----------------------------------------------------------------------------------------------------------
echo ---------------------------------------------------------------------------------------------------------- >> ${NET}_${MASK}/_raport.txt
echo 'use auxiliary/scanner/ssh/ssh_version' >> ${NET}_${MASK}/ssh.rc
echo 'set rhosts '${NET}/${MASK} >> ${NET}_${MASK}/ssh.rc
echo 'set threads 10000' >> ${NET}_${MASK}/ssh.rc
echo 'run' >> ${NET}_${MASK}/ssh.rc
echo 'exit' >> ${NET}_${MASK}/ssh.rc

echo 'Uruchamianie metasploita i szukanie serwerów SSH'
echo 'Uruchamianie metasploita i szukanie serwerów SSH' >> ${NET}_${MASK}/_raport.txt
msfconsole -r ${NET}_${MASK}/ssh.rc | grep '\[+\]' >> ${NET}_${MASK}/ssh.txt
cat ${NET}_${MASK}/ssh.txt >> ${NET}_${MASK}/_raport.txt
rm ${NET}_${MASK}/ssh.rc
clear

#----------------------------------------------------------------------------------------------------------
echo ---------------------------------------------------------------------------------------------------------- >> ${NET}_${MASK}/_raport.txt
echo 'use auxiliary/scanner/telnet/telnet_version' >> ${NET}_${MASK}/telnet.rc
echo 'set rhosts '${NET}/${MASK} >> ${NET}_${MASK}/telnet.rc
echo 'set threads 10000' >> ${NET}_${MASK}/telnet.rc
echo 'run' >> ${NET}_${MASK}/telnet.rc
echo 'exit' >> ${NET}_${MASK}/telnet.rc

echo 'Uruchamianie metasploita i szukanie serwerów TELNET'
echo 'Uruchamianie metasploita i szukanie serwerów TELNET' >> ${NET}_${MASK}/_raport.txt
msfconsole -r ${NET}_${MASK}/telnet.rc | grep '\[+\]'>> ${NET}_${MASK}/telnet.txt
cat ${NET}_${MASK}/telnet.txt >> ${NET}_${MASK}/_raport.txt
rm ${NET}_${MASK}/telnet.rc
clear

#----------------------------------------------------------------------------------------------------------
echo ---------------------------------------------------------------------------------------------------------- >> ${NET}_${MASK}/_raport.txt
echo 'use auxiliary/scanner/smtp/smtp_version' >> ${NET}_${MASK}/smtp.rc
echo 'set rhosts '${NET}/${MASK} >> ${NET}_${MASK}/smtp.rc
echo 'set threads 10000' >> ${NET}_${MASK}/smtp.rc
echo 'run' >> ${NET}_${MASK}/smtp.rc
echo 'exit' >> ${NET}_${MASK}/smtp.rc

echo 'Uruchamianie metasploita i szukanie serwerów SMTP'
echo 'Uruchamianie metasploita i szukanie serwerów SMTP' >> ${NET}_${MASK}/_raport.txt
msfconsole -r ${NET}_${MASK}/smtp.rc | grep '\[+\]'>> ${NET}_${MASK}/smtp.txt
cat ${NET}_${MASK}/smtp.txt >> ${NET}_${MASK}/_raport.txt
rm ${NET}_${MASK}/smtp.rc
clear

#----------------------------------------------------------------------------------------------------------
echo ---------------------------------------------------------------------------------------------------------- >> ${NET}_${MASK}/_raport.txt
echo 'use auxiliary/scanner/smtp/smtp_relay' >> ${NET}_${MASK}/smtp.rc
echo 'set rhosts '${NET}/${MASK} >> ${NET}_${MASK}/smtp.rc
echo 'set extended true' >> ${NET}_${MASK}/smtp.rc
echo 'set mailto janik.m@dagma.pl' >> ${NET}_${MASK}/smtp.rc
echo 'set threads 10000' >> ${NET}_${MASK}/smtp.rc
echo 'run' >> ${NET}_${MASK}/smtp.rc
echo 'exit' >> ${NET}_${MASK}/smtp.rc

echo 'Weryfikacja open-relay dla serwera pocztowego'
echo 'Weryfikacja open-relay dla serwera pocztowego' >> ${NET}_${MASK}/_raport.txt
msfconsole -r ${NET}_${MASK}/smtp.rc | grep '\[+\] >> ${NET}_${MASK}/smtp_open_relay.txt
cat ${NET}_${MASK}/smtp_open_relay.txt '>> ${NET}_${MASK}/_raport.txt
rm ${NET}_${MASK}/smtp.rc
clear

#----------------------------------------------------------------------------------------------------------
echo ---------------------------------------------------------------------------------------------------------- >> ${NET}_${MASK}/_raport.txt
echo 'use auxiliary/scanner/smb/smb_version' >> ${NET}_${MASK}/smb.rc
echo 'set rhosts '${NET}/${MASK} >> ${NET}_${MASK}/smb.rc
echo 'set threads 10000' >> ${NET}_${MASK}/smb.rc
echo 'run' >> ${NET}_${MASK}/smb.rc
echo 'exit' >> ${NET}_${MASK}/smb.rc

echo 'Uruchamianie metasploita i weryfikacja wersji SMB'
echo 'Uruchamianie metasploita i weryfikacja wersji SMB' >> ${NET}_${MASK}/_raport.txt
msfconsole -r ${NET}_${MASK}/smb.rc | grep '\[+\]' >> ${NET}_${MASK}/smb_version.txt
cat ${NET}_${MASK}/smb_version.txt >> ${NET}_${MASK}/_raport.txt
rm ${NET}_${MASK}/smb.rc
clear

#----------------------------------------------------------------------------------------------------------
#echo ---------------------------------------------------------------------------------------------------------- >> ${NET}_${MASK}/_raport.txt

#echo 'Listowanie hostów na serwerze DNS'
#echo 'Odnalezione serwery DNS:' >> ${NET}_${MASK}/_raport.txt
#cat ${NET}_${MASK}/dns.txt >> ${NET}_${MASK}/_raport.txt
#echo 'Listowanie hostów na serwerze DNS' >> ${NET}_${MASK}/_raport.txt
#while read ADDRESS;
#do
#dnsrecon -n ${ADDRESS} -r ${NET}/${MASK} -v | grep -v Trying >> ${NET}_${MASK}/dns_hosts.txt
#done < ${NET}_${MASK}/dns.txt
#clear


#----------------------------------------------------------------------------------------------------------
echo ---------------------------------------------------------------------------------------------------------- >> ${NET}_${MASK}/_raport.txt
echo 'use auxiliary/scanner/mssql/mssql_ping' >> ${NET}_${MASK}/mssql.rc
echo 'set rhosts '${NET}/${MASK} >> ${NET}_${MASK}/mssql.rc
echo 'set threads 10000' >> ${NET}_${MASK}/mssql.rc
echo 'run' >> ${NET}_${MASK}/mssql.rc
echo 'exit' >> ${NET}_${MASK}/mssql.rc

echo 'Uruchamianie metasploita i szukanie serwerów MSSQL'
echo 'Uruchamianie metasploita i szukanie serwerów MSSQL' >> ${NET}_${MASK}/_raport.txt
msfconsole -r ${NET}_${MASK}/mssql.rc | grep '\[+\]'>> ${NET}_${MASK}/mssql.txt
cat ${NET}_${MASK}/mssql.txt >> ${NET}_${MASK}/_raport.txt
rm ${NET}_${MASK}/mssql.rc
clear

#----------------------------------------------------------------------------------------------------------
echo ---------------------------------------------------------------------------------------------------------- >> ${NET}_${MASK}/_raport.txt
echo 'use auxiliary/scanner/rdp/rdp_scanner' >> ${NET}_${MASK}/rdp.rc
echo 'set rhosts '${NET}/${MASK} >> ${NET}_${MASK}/rdp.rc
echo 'set threads 10000' >> ${NET}_${MASK}/rdp.rc
echo 'run' >> ${NET}_${MASK}/rdp.rc
echo 'exit' >> ${NET}_${MASK}/rdp.rc

echo 'Uruchamianie metasploita i szukanie hostów z pulpitem zdalnym'
echo 'Uruchamianie metasploita i szukanie hostów z pulpitem zdalnym' >> ${NET}_${MASK}/_raport.txt
msfconsole -r ${NET}_${MASK}/rdp.rc | grep -a 'Detected'>> ${NET}_${MASK}/rdp.txt
cat ${NET}_${MASK}/rdp.txt >> ${NET}_${MASK}/_raport.txt
rm ${NET}_${MASK}/rdp.rc
clear

#----------------------------------------------------------------------------------------------------------
echo ---------------------------------------------------------------------------------------------------------- >> ${NET}_${MASK}/_raport.txt
echo 'use auxiliary/scanner/mysql/mysql_version' >> ${NET}_${MASK}/mysql.rc
echo 'set rhosts '${NET}/${MASK} >> ${NET}_${MASK}/mysql.rc
echo 'set threads 10000' >> ${NET}_${MASK}/mysql.rc
echo 'run' >> ${NET}_${MASK}/mysql.rc
echo 'exit' >> ${NET}_${MASK}/mysql.rc

echo 'Uruchamianie metasploita i szukanie serwerów MYSQL'
echo 'Uruchamianie metasploita i szukanie serwerów MYSQL' >> ${NET}_${MASK}/_raport.txt
msfconsole -r ${NET}_${MASK}/mysql.rc | grep 'is running MySQL'>> ${NET}_${MASK}/mysql.txt
cat ${NET}_${MASK}/mysql.txt >> ${NET}_${MASK}/_raport.txt
rm ${NET}_${MASK}/mysql.rc
clear

#----------------------------------------------------------------------------------------------------------
echo 'use auxiliary/scanner/portscan/syn' >> ${NET}_${MASK}/port_scan.rc
echo 'set rhosts '${NET}/${MASK} >> ${NET}_${MASK}/port_scan.rc
echo 'set ports 80,443,3128,8080' >> ${NET}_${MASK}/port_scan.rc
echo 'set threads 10000' >> ${NET}_${MASK}/port_scan.rc
echo 'run' >> ${NET}_${MASK}/port_scan.rc
echo 'exit' >> ${NET}_${MASK}/port_scan.rc

#-----------------------------------------------------------------------------------------------------------
echo ---------------------------------------------------------------------------------------------------------- >> ${NET}_${MASK}/_raport.txt
echo 'Przeszukiwanie sieci (80,443,3128,8080)'
echo 'Przeszukiwanie sieci (80,443,3128,8080)' >> ${NET}_${MASK}/_raport.txt
msfconsole -r ${NET}_${MASK}/port_scan.rc | grep '\[+\]'>> ${NET}_${MASK}/port_scan.txt
cat ${NET}_${MASK}/port_scan.txt >> ${NET}_${MASK}/_raport.txt

#-----------------------------------------------------------------------------------------------------------
echo 'Parsowanie wyników'
echo 'Parsowanie wyników' >> ${NET}_${MASK}/_raport.txt
cat ${NET}_${MASK}/port_scan.txt | grep ':80' | awk '{print $4}' |  awk -F ':' '{print $1}' >> ${NET}_${MASK}/http.txt
cat ${NET}_${MASK}/port_scan.txt | grep ':443' | awk '{print $4}' |  awk -F ':' '{print $1}' >> ${NET}_${MASK}/https.txt
count_80=$(cat ${NET}_${MASK}/http.txt | grep "" -c )
count_443=$(cat ${NET}_${MASK}/https.txt | grep "" -c )
clear

#-----------------------------------------------------------------------------------------------------------
echo ---------------------------------------------------------------------------------------------------------- >> ${NET}_${MASK}/_raport.txt
echo 'Tworzenie podfolderu z wynikami skanowania'
echo 'Tworzenie podfolderu z wynikami skanowania' >> ${NET}_${MASK}/_raport.txt
mkdir ${NET}_${MASK}/Zrzuty_ekranu
mkdir ${NET}_${MASK}/Zrzuty_ekranu/Kontrola_dostępu_do_stron

#-----------------------------------------------------------------------------------------------------------
echo ---------------------------------------------------------------------------------------------------------- >> ${NET}_${MASK}/_raport.txt
echo 'Wykonywanie zrzutów ekranu dla HTTP' >> ${NET}_${MASK}/_raport.txt
while read ADDRESS;
do
echo 'Wykonywanie zrzutów ekranu dla HTTP'
echo 'Host numer: '${run}'/'${count_80} 
echo ${ADDRESS} >> ${NET}_${MASK}/_raport.txt 
cutycapt --url=http://${ADDRESS} --out=${NET}_${MASK}/Zrzuty_ekranu/${ADDRESS}_80.png --insecure --delay=5000 
clear
run=$((run+1))
done < ${NET}_${MASK}/http.txt

run=1

#-----------------------------------------------------------------------------------------------------------
echo ---------------------------------------------------------------------------------------------------------- >> ${NET}_${MASK}/_raport.txt
echo 'Wykonywanie zrzutów ekranu dla HTTPS' >> ${NET}_${MASK}/_raport.txt
while read ADDRESS;
do
echo 'Wykonywanie zrzutów ekranu dla HTTPS'
echo 'Host numer: '${run}'/'${count_443} 
echo ${ADDRESS} >> ${NET}_${MASK}/_raport.txt 
cutycapt --url=https://${ADDRESS} --out=${NET}_${MASK}/Zrzuty_ekranu/${ADDRESS}_443.png --insecure --delay=5000
clear
run=$((run+1))
done < ${NET}_${MASK}/https.txt

run=1

#-----------------------------------------------------------------------------------------------------------
echo ---------------------------------------------------------------------------------------------------------- >> ${NET}_${MASK}/_raport.txt
echo 'Wykonywanie zrzutów ekranu dla kontroli dostępu do stron' >> ${NET}_${MASK}/_raport.txt
while read ADDRESS;
do
echo 'Wykonywanie zrzutów ekranu dla kontroli dostępu do stron'
echo ${ADDRESS} >> ${NET}_${MASK}/_raport.txt 
cutycapt --url=https://${ADDRESS} --out=${NET}_${MASK}/Zrzuty_ekranu/Kontrola_dostępu_do_stron/${ADDRESS}.png --insecure --delay=5000
clear
done < url.txt

#-----------------------------------------------------------------------------------------------------------
#echo ---------------------------------------------------------------------------------------------------------- >> ${NET}_${MASK}/_raport.txt
#echo 'Listowanie użytkowników w domenie' >> ${NET}_${MASK}/_raport.txt
#while read ADDRESS;
#do
#echo 'Listowanie użytkowników w domenie'
#enum4linux -U -l ${ADDRESS} | grep -Po '(?<=(user:\[)).*(?=\] )' >> ${NET}_${MASK}/domain_users_${ADDRESS}.txt
#cat ${NET}_${MASK}/domain_users_${ADDRESS}.txt >> username.txt
#run=$((run+1))
#clear
#done < ${NET}_${MASK}/ldap.txt

#-----------------------------------------------------------------------------------------------------------
#echo ---------------------------------------------------------------------------------------------------------- >> ${NET}_${MASK}/_raport.txt
#echo 'Wyszukiwanie udostępnionych folderów oraz atak bruteforce' >> ${NET}_${MASK}/_raport.txt
#while read ADDRESS;
#do
#echo 'Wyszukiwanie udostępnionych folderów oraz atak bruteforce'
#echo 'enum4linux' 
#enum4linux -a -v ${ADDRESS} > ${NET}_${MASK}/SMB/Enum/${ADDRESS}.txt
#echo 'hydra'
#hydra -I -L username.txt -P password.txt ${ADDRESS} smb -V -f -o ${NET}_${MASK}/${ADDRESS}_hydra.txt
#cat ${NET}_${MASK}/${ADDRESS}_hydra.txt| grep '[445][smb]' >> ${NET}_${MASK}/_raport.txt
#hosts="${ADDRESS} ${hosts}"
#run=$((run+1))
#clear
#done < ${NET}_${MASK}/smb.txt

#grep -iR "login" ${NET}_${MASK}/ | awk -F " " '{print $3 " " $5 " " $7 }' >> ${NET}_${MASK}/logins.txt
#cat ${NET}_${MASK}/logins.txt >> ${NET}_${MASK}/_raport.txt

#echo 'Listowanie zasobów' >> ${NET}_${MASK}/_raport.txt
#while IFS=" " read HOST USER PASS;
#do
#clear
#echo 'Listowanie zasobów'
#echo 'use auxiliary/scanner/smb/smb_enumshares' > ${NET}_${MASK}/enum_shares.rc
#echo 'set rhosts '${HOST} >> ${NET}_${MASK}/enum_shares.rc
#echo 'set SMBPass '${PASS} >> ${NET}_${MASK}/enum_shares.rc
#echo 'set SMBUser '${USER} >> ${NET}_${MASK}/enum_shares.rc
#echo 'set threads 10000' >> ${NET}_${MASK}/enum_shares.rc
#echo 'run' >> ${NET}_${MASK}/enum_shares.rc
#echo 'exit' >> ${NET}_${MASK}/enum_shares.rc

#msfconsole -r ${NET}_${MASK}/enum_shares.rc >> ${NET}_${MASK}/${HOST}_enumshares.txt
#cat ${NET}_${MASK}/${HOST}_enumshares.txt | grep :445 >> ${NET}_${MASK}/smb_shares_${HOST}.txt
#rm ${NET}_${MASK}/enum_shares.rc
#cat ${NET}_${MASK}/smb_shares_${HOST}.txt >> ${NET}_${MASK}/_raport.txt
#done < ${NET}_${MASK}/logins.txt

#-----------------------------------------------------------------------------------------------------------
#echo ---------------------------------------------------------------------------------------------------------- >> ${NET}_${MASK}/_raport.txt
#echo 'Listowanie użytkowników' >> ${NET}_${MASK}/_raport.txt
#while IFS=" " read HOST USER PASS;
#do
#clear
#echo 'Listowanie użytkowników'
#echo 'use auxiliary/scanner/smb/smb_enumusers' >> ${NET}_${MASK}/enum_users.rc
#echo 'set rhosts '${HOST} >> ${NET}_${MASK}/enum_users.rc
#echo 'set SMBPass '${PASS} >> ${NET}_${MASK}/enum_users.rc
#echo 'set SMBUser '${USER} >> ${NET}_${MASK}/enum_users.rc
#echo 'set threads 10000' >> ${NET}_${MASK}/enum_users.rc
#echo 'run' >> ${NET}_${MASK}/enum_users.rc
#echo 'exit' >> ${NET}_${MASK}/enum_users.rc

#msfconsole -r ${NET}_${MASK}/enum_users.rc >> ${NET}_${MASK}/${HOST}_enumusers.txt
#cat ${NET}_${MASK}/${HOST}_enumusers.txt | grep :445 |grep -Po '(?<=(\[ )).*(?= \])' >> ${NET}_${MASK}/${HOST}_users.txt 
#tr " " "\n" < ${NET}_${MASK}/${HOST}_users.txt  >> ${NET}_${MASK}/${HOST}_tmp_logins.txt
#tr "," " " < ${NET}_${MASK}/${HOST}_tmp_logins.txt >> ${NET}_${MASK}/smb_logins_${HOST}.txt
#rm ${NET}_${MASK}/*_tmp_*
#rm ${NET}_${MASK}/${HOST}_enumusers.txt
#rm ${NET}_${MASK}/${HOST}_users.txt
#rm ${NET}_${MASK}/enum_users.rc
#cat ${NET}_${MASK}/smb_logins_${HOST}.txt >> ${NET}_${MASK}/_raport.txt
#done < ${NET}_${MASK}/logins.txt

#run=1

#-----------------------------------------------------------------------------------------------------------
#echo ---------------------------------------------------------------------------------------------------------- >> ${NET}_${MASK}/_raport.txt
#echo 'Wyszukane hosty z serwerem VNC'
#clear
#echo 'Wyszukane hosty z serwerem VNC' >> ${NET}_${MASK}/_raport.txt
#cat ${NET}_${MASK}/vnc.txt >> ${NET}_${MASK}/_raport.txt

#-----------------------------------------------------------------------------------------------------------
echo ---------------------------------------------------------------------------------------------------------- >> ${NET}_${MASK}/_raport.txt
echo 'Weryfikacja portów i podatności dla aktywnych hostów w sieci'
echo 'Weryfikacja portów i podatności dla aktywnych hostów w sieci'>> ${NET}_${MASK}/_raport.txt
nmap -A -T 4 -sV --script vulners ${NET}/${MASK} -oX ${NET}_${MASK}/${NET}_${MASK}_vulners.xml -oG ${NET}_${MASK}/${NET}_${MASK}_vulners.gnmap
xsltproc ${NET}_${MASK}/${NET}_${MASK}_vulners.xml -o ${NET}_${MASK}/${NET}_${MASK}_vulners.html
clear

#-----------------------------------------------------------------------------------------------------------
echo ---------------------------------------------------------------------------------------------------------- >> ${NET}_${MASK}/_raport.txt
echo 'Sprzątanie'
echo 'Sprzątanie' >> ${NET}_${MASK}/_raport.txt
rm ${NET}_${MASK}/*.rc
rm ${NET}_${MASK}/port_scan.*
rm ${NET}_${MASK}/*_enumshares.txt
rm ${NET}_${MASK}/*_hydra.txt
rm url.txt

#-----------------------------------------------------------------------------------------------------------
else
echo 'Skanowanie nie wykryło żadnych hostów'
echo 'Skanowanie nie wykryło żadnych hostów' >> ${NET}_${MASK}/_raport.txt
fi

run=1
clear
echo 'Skanowanie zakończone'
echo 'Skanowanie zakończone' >> ${NET}_${MASK}/_raport.txt
echo 'Koniec:'$(date) >> ${NET}_${MASK}/_raport.txt
done < sieci.txt

