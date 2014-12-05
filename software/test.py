import sys, os, time, signal, random
sys.path.append('/Users/tlenzi/Documents/PhD/Code/GLIB/software/src')

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
def testRead(register):
    global nOK, nBadHeader, nErrorOnRead, nTimedOut, nMismatch, nOthers

    try:
        controlChar = glib.read(register)
        nOK += 1
    except ChipsException, e:
        if ('amount of data' in e.value):
            nBadHeader += 1
        elif ('INFO CODE = 0x4L' in e.value):
            nErrorOnRead += 1
        elif ('INFO CODE = 0x6L' in e.value or 'timed out' in e.value):
            nTimedOut += 1
        else:
            nOthers += 1
        pass

# Send a write transaction
def testWrite(register, value):
    global nOK, nBadHeader, nErrorOnRead, nTimedOut, nMismatch, nOthers

    try:
        glib.write(register, value)
        nOK += 1
    except ChipsException, e:
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

        testRead("lv1a")


    signal_handler(0, 0)


