import sys, os, time, signal, random
sys.path.append('/Users/tlenzi/Documents/PhD/Code/GLIB/software/src')

from PyChipsUser import *

# Main code
if __name__ == "__main__":

    ipaddr = '192.168.0.115'

    glibAddrTable = AddressTable("./glibAddrTable.dat")
    glib = ChipsBusUdp(glibAddrTable, ipaddr, 50001)

    print
    print "Opening GLIB with IP", ipaddr
    print "Processing... press Ctrl+C to terminate and get statistics"


    print "Ask for updated data : ", hex(glib.read("tracking00"))
    print "Data 1", hex(glib.read("tracking01"))
    print "Data 2", hex(glib.read("tracking02"))
    print "Data 3", hex(glib.read("tracking03"))
    print "Data 4", hex(glib.read("tracking04"))
    print "Data 5", hex(glib.read("tracking05"))
    print "Data 6", hex(glib.read("tracking06"))

