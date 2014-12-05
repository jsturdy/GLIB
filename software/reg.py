import sys, os, time, signal, random
sys.path.append('/Users/tlenzi/Documents/PhD/Code/GLIB/software/src')

from PyChipsUser import *

# Main code
if __name__ == "__main__":

    ipaddr = '192.168.0.115'
    glibAddrTable = AddressTable("./glibAddrTable.dat")
    glib = ChipsBusUdp(glibAddrTable, ipaddr, 50001)

    if (sys.argv[1] == 'w'):
        print "Write to ", sys.argv[2]
        glib.write(sys.argv[2], int(sys.argv[3]))

    elif (sys.argv[1] == 'r'):
        print "Read from ", sys.argv[2], " : ", hex(glib.read(sys.argv[2]))





