import sys, os, time, signal, random
sys.path.append('/Users/tlenzi/Desktop/GLIB_SW/src')

from PyChipsUser import *

timeStart = 0.
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


# Send a read transaction
def testRead(vfat2, register, exp):
    global nOK, nBadHeader, nErrorOnRead, nTimedOut, nMismatch, nOthers

    try:
        controlChar = glib.read("vfat2_" + str(vfat2) + "_" + register)
        # time.sleep(0.01)

    # Next is for debugging (error tracking, data matching, ...)

        if (controlChar == exp):
            print colors.GREEN, "-> Match : ", hex(controlChar), colors.ENDC
            nOK += 1
            return True
        else:
            print colors.RED, "-> Error, result does not match expectation : ", hex(controlChar), " != ", hex(exp), colors.ENDC
            nMismatch += 1
            return False
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
        return False
        pass

# Send a write transaction
def testWrite(vfat2, register, value):
    global nOK, nBadHeader, nErrorOnRead, nTimedOut, nMismatch, nOthers

    try:
        glib.write("vfat2_" + str(vfat2) + "_" + register, value)
        # time.sleep(0.01)

    # Next is for debugging (error tracking, data matching, ...)

        print colors.GREEN, "-> OK", colors.ENDC
        nOK += 1
        return True
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
        return False
        pass

def randomRW():
    val8 = random.randint(0, 255)
    val9 = random.randint(0, 255)
    val10 = random.randint(0, 255)
    val11 = random.randint(0, 255)
    val12 = random.randint(0, 255)
    val13 = random.randint(0, 255)

    res8 = 0x3080000 + val8
    res9 = 0x3090100 + val9
    res10 = 0x30a9500 + val10
    res11 = 0x30b0000 + val11
    res12 = 0x30c0100 + val12
    res13 = 0x30d9500 + val13

    print "Random: ", hex(val8), hex(val9), hex(val10), hex(val11), hex(val12), hex(val13)
    wr8 = testWrite(8, "ctrl0", val8)
    wr9 = testWrite(9, "ctrl1", val9)
    wr10 = testWrite(10, "ctrl2", val10)
    if wr9:
        testRead(9, "ctrl1", res9)
    if wr8:
        testRead(8, "ctrl0", res8)
    wr11 = testWrite(11, "ctrl0", val11)
    if wr10:
        testRead(10, "ctrl2", res10)
    wr12 = testWrite(12, "ctrl1", val12)
    wr13 = testWrite(13, "ctrl2", val13)
    if wr13:
        testRead(13, "ctrl2", res13)
    if wr12:
        testRead(12, "ctrl1", res12)

def signal_handler(signal, frame):
    global nOK, nBadHeader, nErrorOnRead, nTimedOut, nMismatch, nOthers, timeStart

    nTotal = nOK + nBadHeader + nErrorOnRead + nTimedOut + nMismatch + nOthers
    nError = nBadHeader + nErrorOnRead + nTimedOut + nMismatch + nOthers
    timing = time.time() - timeStart

    if nTotal == 0:
        nTotal = 1

    print
    print "Results ", int(nTotal), " events - ", int(nError), " errors - ", int(nTotal - nError), " good - in ", timing, "s"
    print "> ", colors.GREEN, "OK : ", nOK / nTotal * 100., "%", colors.ENDC
    print "> ", colors.RED, "Error : ", nError / nTotal * 100., "%", colors.ENDC
    print ">> ", colors.BLUE, "Bad data : ", nBadHeader / nTotal * 100., "%", colors.ENDC
    print ">> ", colors.BLUE, "Error on read : ", nErrorOnRead / nTotal * 100., "%", colors.ENDC
    print ">> ", colors.BLUE, "Timed out : ", nTimedOut / nTotal * 100., "%", colors.ENDC
    print ">> ", colors.BLUE, "Mismatch : ", nMismatch / nTotal * 100., "%", colors.ENDC
    print ">> ", colors.BLUE, "Others : ", nOthers / nTotal * 100., "%", colors.ENDC
    sys.exit(0)


# Main code
if __name__ == "__main__":

    ipaddr = '192.168.0.115'

    glibAddrTable = AddressTable("./glibAddrTable.dat")
    glib = ChipsBusUdp(glibAddrTable, ipaddr, 50001)

    signal.signal(signal.SIGINT, signal_handler)

    timeStart = time.time()

    print
    print "Opening GLIB with IP", ipaddr
    print "Processing... press Ctrl+C to terminate and get statistics"

    while True:

        if (time.time() - timeStart > 60):
            break

        # testRead(8, "chipid0", 0x30808cf)
        # testRead(9, "chipid0", 0x3090854)
        # testRead(10, "chipid0", 0x30a08e4)
        # testRead(11, "chipid0", 0x30b086c)
        # testRead(12, "chipid0", 0x30c0868)
        # testRead(13, "chipid0", 0x30d0868)

        randomRW()

        # testRead(8,  "chipid0", 0x30808e4)
        # testRead(8,  "chipid1", 0x30809f0)
        # testRead(9,  "chipid0", 0x30908cf)
        # testRead(9,  "chipid1", 0x30909fe)
        # testRead(10, "chipid0", 0x30a0854)
        # testRead(10, "chipid1", 0x30a09f0)

        # print "----------------"
        # raw_input()

    signal_handler(0, 0)


