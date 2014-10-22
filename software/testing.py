import sys, os, time, signal, random
sys.path.append('/Users/tlenzi/Desktop/GLIB_SW/src')

from PyChipsUser import *

def tryWrite(reg, val):
    for i in range(0, 5):
        try:
            glib.write(reg, val & 0xff)
            return True
        except:
            pass
    sys.exit(0)

def tryRead(reg):
    for i in range(0, 5):
        try:
            res = glib.read(reg) & 0xff
            return res
        except:
            pass
    sys.exit(0)

# Main code
if __name__ == "__main__":

    ipaddr = '192.168.0.115'
    glibAddrTable = AddressTable("./glibAddrTable.dat")
    glib = ChipsBusUdp(glibAddrTable, ipaddr, 50001)

    tryWrite("vfat2_" + str(sys.argv[1]) + "_ctrl0", 0x48)
    tryWrite("vfat2_" + str(sys.argv[1]) + "_vcal", 0xff)

    for i in range(1, 129):
        tryWrite("vfat2_" + str(sys.argv[1]) + "_channel" + str(i), 0x40)

    tryWrite("vfat2_" + str(sys.argv[1]) + "_vthreshold1", 0xff)
    tryWrite("vfat2_" + str(sys.argv[1]) + "_vthreshold2", 0xff)
    tryWrite("vfat2_" + str(sys.argv[1]) + "_ctrl0", 0x49)
    tryRead("resync")

    for i in range(0, 50):
        tryRead("calpulse")
        time.sleep(0.1)


    print "DONE"



