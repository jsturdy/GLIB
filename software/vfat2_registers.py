import sys, os, time, signal, random
sys.path.append('/Users/tlenzi/Desktop/GLIB_SW/src')

from PyChipsUser import *

nOK = 0.
nBadHeader = 0.
nErrorOnRead = 0.
nTimedOut = 0.
nMismatch = 0.
nOthers = 0.

class colors:
    BLUE = '\033[94m'
    GREEN = '\033[92m'
    ORANGE = '\033[93m'
    RED = '\033[91m'
    ENDC = '\033[0m'

def emptyBuffer():
    for i in range(0, 16):
        try:
            glib.read("vfat2_response")
        except ChipsException, e:
            pass

def testRead(register, exp):
    global nOK, nBadHeader, nErrorOnRead, nTimedOut, nMismatch, nOthers

    #print "Reading VFAT2 register : ", register

    try:

        glib.read(register)
        time.sleep(0.01)
        controlChar = glib.read("vfat2_response")
        time.sleep(0.01)

        if (controlChar == exp):

            print colors.GREEN, "-> Match : ", hex(controlChar), colors.ENDC

            nOK += 1

        else:

            print colors.RED, "-> Error, result does not match expectation : ", hex(controlChar), " != ", hex(exp), colors.ENDC

            nMismatch += 1

    except ChipsException, e:

        print colors.BLUE, "-> Error : ", e, colors.ENDC

        if ('amount of data' in e.value):
            nBadHeader += 1

        elif ('INFO CODE = 0x4L' in e.value):
            nErrorOnRead += 1

        elif ('INFO CODE = 0x6L' in e.value or 'timed out' in e.value):
            nTimedOut += 1

        else:
            nOthers += 1

        pass

def testWrite(register, value):
    global nOK, nBadHeader, nErrorOnRead, nTimedOut, nMismatch, nOthers

    #print "Writting VFAT2 register : ", register

    try:

        glib.write(register, value)
        time.sleep(0.01)
        controlChar = glib.read("vfat2_response")
        time.sleep(0.01)

        print colors.GREEN, "-> OK : ", hex(controlChar), colors.ENDC

        nOK += 1

    except ChipsException, e:

        print colors.BLUE, "-> Error : ", e, colors.ENDC

        if ('amount of data' in e.value):
            nBadHeader += 1

        elif ('INFO CODE = 0x4L' in e.value):
            nErrorOnRead += 1

        elif ('INFO CODE = 0x6L' in e.value or 'timed out' in e.value):
            nTimedOut += 1

        else:
            nOthers += 1

        pass

def signal_handler(signal, frame):
    global nOK, nBadHeader, nErrorOnRead, nTimedOut, nMismatch, nOthers

    nTotal = nOK + nBadHeader + nErrorOnRead + nTimedOut + nMismatch + nOthers
    nError = nBadHeader + nErrorOnRead + nTimedOut + nMismatch + nOthers

    if nTotal == 0:
        nTotal = 1

    print
    print "Results on ", int(nTotal), " events"
    print "> ", colors.GREEN, "OK : ", nOK / nTotal * 100., "%", colors.ENDC
    print "> ", colors.RED, "Error : ", nError / nTotal * 100., "%", colors.ENDC
    print ">> ", colors.BLUE, "Bad data : ", nBadHeader / nTotal * 100., "%", colors.ENDC
    print ">> ", colors.BLUE, "Error on read : ", nErrorOnRead / nTotal * 100., "%", colors.ENDC
    print ">> ", colors.BLUE, "Timed out : ", nTimedOut / nTotal * 100., "%", colors.ENDC
    print ">> ", colors.BLUE, "Mismatch : ", nMismatch / nTotal * 100., "%", colors.ENDC
    print ">> ", colors.BLUE, "Others : ", nOthers / nTotal * 100., "%", colors.ENDC
    sys.exit(0)

if __name__ == "__main__":

    ipaddr = '192.168.0.115'

    glibAddrTable = AddressTable("./glibAddrTable.dat")
    glib = ChipsBusUdp(glibAddrTable, ipaddr, 50001)

    signal.signal(signal.SIGINT, signal_handler)

    print
    print "Opening GLIB with IP", ipaddr
    print "Processing... press Ctrl+C to terminate and get statistics"

    # Empty buffer
    emptyBuffer()

    while True:
        # res = testRead("opto_reg1", 0x100)
        # res = testWrite("opto_reg1", 0xa)
        # res = testRead("vfat2_impreampin", 0x30402ef)
        # res = testRead("vfat2_channel10", 0x30420cd)
        # res = testRead("vfat2_ctrl0", 0x5040000)

        val = random.randint(0, 255)
        res = 0x3059500 + val

        testWrite("vfat2_ctrl2", val);
        testRead("vfat2_ctrl2", res);

        # testRead("vfat2_chipid0", 0x30408cf)
        # testRead("vfat2_chipid1", 0x30409f0)
        # testRead("vfat2_ctrl0", 0x304005c)




