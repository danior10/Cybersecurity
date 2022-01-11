from bs4 import BeautifulSoup

cve = open('cve.txt', 'a')

with open('vulners.html','r') as html_file:
    content = html_file.read()

    soup = BeautifulSoup(content, 'lxml')
    hosts = soup.find_all('div')
#    print(hosts.get('id'))
    for host in hosts:
        #print(host.get('id'))
        host_name = host.get('id')
        if host_name == 'container' or host_name == 'menubox':
            continue
        else:
            host_name = host_name.split('_')[1]
            #print(host_name)
            cve.write(host_name + '\n')
        
        script = host.find('tr', attrs={'class': 'script'})
        #print(script)
        #toco = script.find('td', colspan='6')
        toco = script.find('pre')
        t1 = toco.text.splitlines()
        for t2 in t1:
            if t2.lstrip().startswith('CVE'):
                if float(t2.lstrip().split()[1]) > 5.0:
                    print(t2.lstrip())
        #print(t1.lstrip())
        break