from PyChipsUser import *
from time import sleep
glibAddrTable = AddressTable("./glibAddrTable.dat")

########################################
# IP address
########################################
f = open('./ipaddr.dat', 'r')
ipaddr = f.readline()
f.close()
glib = ChipsBusUdp(glibAddrTable, ipaddr, 50001)
print
print "--=======================================--"
print "  Opening GLIB with IP", ipaddr
print "--=======================================--"
########################################

offset = 0
readBuffer1 = []
readBuffer2 = []
readBuffer3 = []

glib.write("cdce_forbid_retry", 1)

# glib.write("cdce_exp_signature_0",  0xfff80000)
# glib.write("cdce_exp_signature_1",  0xffffffff)
# glib.write("cdce_exp_signature_2",  0x07ffffff)
# glib.write("cdce_exp_signature_3",  0x00000000)
# glib.write("cdce_exp_signature_4",      0x0000)

# glib.write("cdce_signature_mask_0", 0x000c0000)
# glib.write("cdce_signature_mask_1", 0x00000000)
# glib.write("cdce_signature_mask_2", 0x0c000000)
# glib.write("cdce_signature_mask_3", 0x00000000)
# glib.write("cdce_signature_mask_4",     0x0000)

# glib.write("cdce_exp_signature_0",  0xfff00000)
# glib.write("cdce_exp_signature_1",  0xffffffff)
# glib.write("cdce_exp_signature_2",  0x000fffff)
# glib.write("cdce_exp_signature_3",  0x00000000)
# glib.write("cdce_exp_signature_4",      0x0000)

# glib.write("cdce_signature_mask_0", 0x003c0000)
# glib.write("cdce_signature_mask_1", 0x00000000)
# glib.write("cdce_signature_mask_2", 0x003c0000)
# glib.write("cdce_signature_mask_3", 0x00000000)
# glib.write("cdce_signature_mask_4",     0x0000)

print
glib.write("cdce_sync", 0)
glib.read ("ctrl") # dummy read
glib.read ("ctrl") # dummy read
print "-> deasserting sync", uInt32HexStr(glib.read ("ctrl")) 
glib.write("cdce_sync", 1)
glib.read ("ctrl") # dummy read
glib.read ("ctrl") # dummy read
print "-> asserting sync  ", uInt32HexStr(glib.read ("ctrl")) 
sleep(0.5)

print
print
print "     ###############################"
print "     #### CDCE Phase Monitoring ####"
print "     ###############################"
print
print
print "-> CDCE PLL status"
print "-> "
print "-> cdce locked     :", glib.read("cdce_lock")
print
print "-> Reading Signature"
print "-> "
readBuffer1.append(uInt32HexStr(glib.read("cdce_acq_signature_0", offset)))	
readBuffer1.append(uInt32HexStr(glib.read("cdce_acq_signature_1", offset)))	
readBuffer1.append(uInt32HexStr(glib.read("cdce_acq_signature_2", offset)))	
readBuffer1.append(uInt32HexStr(glib.read("cdce_acq_signature_3", offset)))	
readBuffer1.append(uInt32HexStr(glib.read("cdce_acq_signature_4", offset)))
acq_signature = readBuffer1[4] + readBuffer1[3] + readBuffer1[2] + readBuffer1[1] +	readBuffer1[0]		

readBuffer2.append(uInt32HexStr(glib.read("cdce_exp_signature_0", offset)))	
readBuffer2.append(uInt32HexStr(glib.read("cdce_exp_signature_1", offset)))	
readBuffer2.append(uInt32HexStr(glib.read("cdce_exp_signature_2", offset)))	
readBuffer2.append(uInt32HexStr(glib.read("cdce_exp_signature_3", offset)))	
readBuffer2.append(uInt32HexStr(glib.read("cdce_exp_signature_4", offset)))
exp_signature = readBuffer2[4] + readBuffer2[3] + readBuffer2[2] + readBuffer2[1] +	readBuffer2[0]		

readBuffer3.append(uInt32HexStr(glib.read("cdce_signature_mask_0", offset)))	
readBuffer3.append(uInt32HexStr(glib.read("cdce_signature_mask_1", offset)))	
readBuffer3.append(uInt32HexStr(glib.read("cdce_signature_mask_2", offset)))	
readBuffer3.append(uInt32HexStr(glib.read("cdce_signature_mask_3", offset)))	
readBuffer3.append(uInt32HexStr(glib.read("cdce_signature_mask_4", offset)))
signature_mask = readBuffer3[4] + readBuffer3[3] + readBuffer3[2] + readBuffer3[1] + readBuffer3[0]		



print "-> Signature:" 
print "-> "
print "-> Expected signature :", exp_signature [4:]
print "-> Signature mask     :", signature_mask[4:]
print "-> Acquired signature :", acq_signature [4:],"(after mask)"
print

print "-> signature match    : %d" % glib.read("cdce_phase_status")
print "-> signature match dv : %d" % glib.read("signature_valid")
print
print "-> Errors within 5us  : %d" % glib.read("pha_mon_error_cnt")
print "-> Retries            : %d" % glib.read("pha_mon_retry_cnt")
print
print "-> done"
print
print "--=======================================--"
print 
print










