# for v in range(0, 24):

#     print
#     print "************* VFAT2 #" + str(v) + "*************"
#     print

#     print "vfat2_" + str(v) + "_ctrl0           4001" + (hex(v)[2:]).zfill(2) + "00    ffffffff     1     1"
#     print "vfat2_" + str(v) + "_ctrl1           4001" + (hex(v)[2:]).zfill(2) + "01    ffffffff     1     1"
#     print "vfat2_" + str(v) + "_ipreampin       4001" + (hex(v)[2:]).zfill(2) + "02    ffffffff     1     1"
#     print "vfat2_" + str(v) + "_ipreampfeed     4001" + (hex(v)[2:]).zfill(2) + "03    ffffffff     1     1"
#     print "vfat2_" + str(v) + "_ipreampout      4001" + (hex(v)[2:]).zfill(2) + "04    ffffffff     1     1"
#     print "vfat2_" + str(v) + "_ishaper         4001" + (hex(v)[2:]).zfill(2) + "05    ffffffff     1     1"
#     print "vfat2_" + str(v) + "_ishaperfeed     4001" + (hex(v)[2:]).zfill(2) + "06    ffffffff     1     1"
#     print "vfat2_" + str(v) + "_icomp           4001" + (hex(v)[2:]).zfill(2) + "07    ffffffff     1     1"
#     print "vfat2_" + str(v) + "_chipid0         4001" + (hex(v)[2:]).zfill(2) + "08    ffffffff     1     0"
#     print "vfat2_" + str(v) + "_chipid1         4001" + (hex(v)[2:]).zfill(2) + "09    ffffffff     1     0"
#     print "vfat2_" + str(v) + "_upsetreg        4001" + (hex(v)[2:]).zfill(2) + "0A    ffffffff     1     0"
#     print "vfat2_" + str(v) + "_hitcount0       4001" + (hex(v)[2:]).zfill(2) + "0B    ffffffff     1     0"
#     print "vfat2_" + str(v) + "_hitcount1       4001" + (hex(v)[2:]).zfill(2) + "0C    ffffffff     1     0"
#     print "vfat2_" + str(v) + "_hitcount2       4001" + (hex(v)[2:]).zfill(2) + "0D    ffffffff     1     0"
#     print "vfat2_" + str(v) + "_extregpointer   4001" + (hex(v)[2:]).zfill(2) + "0E    ffffffff     1     1"
#     print "vfat2_" + str(v) + "_extregdata      4001" + (hex(v)[2:]).zfill(2) + "0F    ffffffff     1     1"
#     print "vfat2_" + str(v) + "_latency         4001" + (hex(v)[2:]).zfill(2) + "10    ffffffff     1     1"

#     for i in range(1, 129):

#         print "vfat2_" + str(v) + "_channel" + str(i) + "       4001" + (hex(v)[2:]).zfill(2) + "" + (hex(16 + i)[2:]).zfill(2) + "    ffffffff     1     1"


#     print "vfat2_" + str(v) + "_vcal            4001" + (hex(v)[2:]).zfill(2) + "91    ffffffff     1     1"
#     print "vfat2_" + str(v) + "_vthreshold1     4001" + (hex(v)[2:]).zfill(2) + "92    ffffffff     1     1"
#     print "vfat2_" + str(v) + "_vthreshold2     4001" + (hex(v)[2:]).zfill(2) + "93    ffffffff     1     1"
#     print "vfat2_" + str(v) + "_calphase        4001" + (hex(v)[2:]).zfill(2) + "94    ffffffff     1     1"
#     print "vfat2_" + str(v) + "_ctrl2           4001" + (hex(v)[2:]).zfill(2) + "95    ffffffff     1     1"
#     print "vfat2_" + str(v) + "_ctrl3           4001" + (hex(v)[2:]).zfill(2) + "96    ffffffff     1     1"

# for v in range(0, 128):

#     print "opto_1_" + str(v) + "           400301" + (hex(v)[2:]).zfill(2) + "    ffffffff     1     1"

for v in range(0, 128):

    print "info_1_" + str(v) + "           400401" + (hex(v)[2:]).zfill(2) + "    ffffffff     1     1"
