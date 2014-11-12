import sys, os, time, signal, random
sys.path.append('/Users/tlenzi/Documents/PhD/Code/GLIB/software/src')

from PyChipsUser import *

# Send a read transaction
def read(register):
    for i in range(0, 5):
        try:
            c = glib.read(register)
            return c
        except ChipsException, e:
            pass

# Send a write transaction
def write(register, val):
    for i in range(0, 5):
        try:
            glib.write(register, val)
            return True
        except ChipsException, e:
            pass

# Main code
if __name__ == "__main__":

    ipaddr = '192.168.0.115'
    glibAddrTable = AddressTable("./glibAddrTable.dat")
    glib = ChipsBusUdp(glibAddrTable, ipaddr, 50001)

    if (sys.argv[1] == 'tkstart'):
        print "Tracker start"

        write('vfat2_8_ctrl3', 16)
        write('vfat2_9_ctrl3', 16)
        write('vfat2_10_ctrl3', 16)
        write('vfat2_11_ctrl3', 16)
        write('vfat2_12_ctrl3', 16)
        write('vfat2_13_ctrl3', 16)

        write('vfat2_8_ctrl0', 1)
        write('vfat2_9_ctrl0', 1)
        write('vfat2_10_ctrl0', 1)
        write('vfat2_11_ctrl0', 1)
        write('vfat2_12_ctrl0', 1)
        write('vfat2_13_ctrl0', 1)

        read('resync')

    elif (sys.argv[1] == 'tkstop'):
        print "Tracker stop"

        write('vfat2_8_ctrl3', 0)
        write('vfat2_9_ctrl3', 0)
        write('vfat2_10_ctrl3', 0)
        write('vfat2_11_ctrl3', 0)
        write('vfat2_12_ctrl3', 0)
        write('vfat2_13_ctrl3', 0)

        write('vfat2_8_ctrl0', 0)
        write('vfat2_9_ctrl0', 0)
        write('vfat2_10_ctrl0', 0)
        write('vfat2_11_ctrl0', 0)
        write('vfat2_12_ctrl0', 0)
        write('vfat2_13_ctrl0', 0)

        read('resync')

    elif (sys.argv[1] == 'tkget'):
        print "Tracker get"

        print "Ask for updated data : ", hex(glib.read("tracking10"))
        print "Data 1", hex(glib.read("tracking11"))
        print "Data 2", hex(glib.read("tracking12"))
        print "Data 3", hex(glib.read("tracking13"))
        print "Data 4", hex(glib.read("tracking14"))
        print "Data 5", hex(glib.read("tracking15"))
        print "Data 6", hex(glib.read("tracking16"))


    elif (sys.argv[1] == 'start'):
        print "Start"

        write('vfat2_8_ctrl0', 1)
        write('vfat2_9_ctrl0', 1)
        write('vfat2_10_ctrl0', 1)
        write('vfat2_11_ctrl0', 1)
        write('vfat2_12_ctrl0', 1)
        write('vfat2_13_ctrl0', 1)

        read('resync')

    elif (sys.argv[1] == 'stop'):
        print "Stop"

        write('vfat2_8_ctrl0', 0)
        write('vfat2_9_ctrl0', 0)
        write('vfat2_10_ctrl0', 0)
        write('vfat2_11_ctrl0', 0)
        write('vfat2_12_ctrl0', 0)
        write('vfat2_13_ctrl0', 0)

        read('resync')

    elif (sys.argv[1] == 'trigger'):
        print "Start trigger"

        write('vfat2_8_ctrl0', 1)
        write('vfat2_9_ctrl0', 1)
        write('vfat2_10_ctrl0', 1)
        write('vfat2_11_ctrl0', 1)
        write('vfat2_12_ctrl0', 1)
        write('vfat2_13_ctrl0', 1)

        read('resync')

        for i in range(0, 10):
            read('lv1a')
            print "Sent trigger", i
            time.sleep(1)

        write('vfat2_8_ctrl0', 0)
        write('vfat2_9_ctrl0', 0)
        write('vfat2_10_ctrl0', 0)
        write('vfat2_11_ctrl0', 0)
        write('vfat2_12_ctrl0', 0)
        write('vfat2_13_ctrl0', 0)

        read('resync')

    else:
        print "Unknown"




