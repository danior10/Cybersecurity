
import sys
import socket
import re
from datetime import datetime

ip_pattern = re.compile("^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$")
port_range_pattern = re.compile("([0-9]+)-([0-9]+)")

port_min = 0
port_max = 65535

print(r"""    ____                  ___ 
   / __ \____ _____  ____/ (_)
  / / / / __ `/ __ \/ __  / / 
 / /_/ / /_/ / / / / /_/ / /  
/_____/\__,_/_/ /_/\__,_/_/   """)
print("\n****************************************************************")


if len(sys.argv) == 2:
    target = socket.gethostbyname(sys.argv[1]) #translate into IPv4
else:
    while True:
        target = input("\nPlease enter the ip address that you want to scan: ")
        if ip_pattern.search(target):
            print(f'{target} is valid address')
            break

    while True:
        print("Please enter the range of ports you want to scan in format: <int>-<int>")
        port_range = input("Enter port range: ")
        port_range_valid = port_range_pattern.search(port_range.replace(" ",""))
        if port_range_valid:
            port_min = int(port_range_valid.group(1))
            port_max = int(port_range_valid.group(2))
            break

#Add a pretty banner

print("****************************************************************")
print('Scanning target ' + target)

try:
    for port in range(port_min,port_max+1):
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        socket.setdefaulttimeout(0.5)
        result = s.connect_ex((target,port)) #returns an error indicator
        if result == 0:
            print('Port {} is open'.format(port))
        s.close()
except KeyboardInterrupt:
    print('\nExiting program.')
    sys.exit()

except socket.gaierror:
    print('Hostname could not be resolved.')
    sys.exit()

except socket.error:
    print("Couldn't connect to server.")
    sys.exit()