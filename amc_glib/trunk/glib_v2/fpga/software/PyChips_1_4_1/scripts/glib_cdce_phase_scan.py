from PyChipsUser import *
import sys
import os
from time import sleep

from PyChipsUser import *
from time import sleep

print
print
print "--=======================================--"
print "  phase shift scan                         "
print "--=======================================--"
print
glibAddrTable = AddressTable("./glibAddrTable.dat")

########################################
# IP address
########################################
f = open('./ipaddr.dat', 'r')
ipaddr = f.readline()
f.close()
glib = ChipsBusUdp(glibAddrTable, ipaddr, 50001)
#print
#print "--=======================================--"
#print "  Opening GLIB with IP", ipaddr
#print "--=======================================--"
########################################
offset = 0
acq_signature  = [0,0,0,0,0]

exp_signature  = [0xfff00000, 0xffffffff, 0x000fffff, 0x00000000, 0x0000]
exp_carry      = [0,0,0,0,0]        

msk_signature  = [0x003c0000, 0x00000000, 0x003c0000, 0x00000000, 0x0000]
msk_carry      = [0,0,0,0,0]        

glib.write("cdce_forbid_retry", 1)

#os.system('del log.txt')

print
print "--+------------------------------------+------------------------------------+--"
print "# |  acquired signature (after mask)   |       expected signature           |st"
print "--+------------------------------------+------------------------------------+--"

for phase_shifts in range(0,25):
	##########
	glib.write("cdce_exp_signature_0",  exp_signature[0])
	glib.write("cdce_exp_signature_1",  exp_signature[1])
	glib.write("cdce_exp_signature_2",  exp_signature[2])
	glib.write("cdce_exp_signature_3",  exp_signature[3])
	glib.write("cdce_exp_signature_4",  exp_signature[4])
	##########
	glib.write("cdce_signature_mask_0", msk_signature[0])
	glib.write("cdce_signature_mask_1", msk_signature[1])
	glib.write("cdce_signature_mask_2", msk_signature[2])
	glib.write("cdce_signature_mask_3", msk_signature[3])
	glib.write("cdce_signature_mask_4", msk_signature[4])
	
	##########
	cmd_str = ''.join(['c:\python27\python glib_cdce_write.py ', str(phase_shifts%24),' >> foo.txt'])
	os.system(cmd_str)
	os.system('c:\python27\python glib_cdce_copy_to_eeprom.py >> foo.txt')

	##########
	glib.write("cdce_sync", 0)
	glib.read ("ctrl") # dummy read
	glib.read ("ctrl") # dummy read
	glib.write("cdce_sync", 1)
	glib.read ("ctrl") # dummy read
	glib.read ("ctrl") # dummy read
	sleep(0.5)

	##########
	acq_signature[0] = glib.read("cdce_acq_signature_0", offset)
	acq_signature[1] = glib.read("cdce_acq_signature_1", offset)	
	acq_signature[2] = glib.read("cdce_acq_signature_2", offset)	
	acq_signature[3] = glib.read("cdce_acq_signature_3", offset)	
	acq_signature[4] = glib.read("cdce_acq_signature_4", offset)

	status = glib.read("cdce_phase_status")
	valid  = glib.read("signature_valid")
	errors = glib.read("pha_mon_error_cnt")
	retries= glib.read("pha_mon_retry_cnt")
	
	acq_sign =  uInt32HexStr(acq_signature[4]) + uInt32HexStr(acq_signature[3]) + uInt32HexStr(acq_signature[2]) + uInt32HexStr(acq_signature[1]) + uInt32HexStr(acq_signature[0])		
	exp_sign =  uInt32HexStr(exp_signature[4]) + uInt32HexStr(exp_signature[3]) + uInt32HexStr(exp_signature[2]) + uInt32HexStr(exp_signature[1]) +	uInt32HexStr(exp_signature[0])
	msk_sign =  uInt32HexStr(msk_signature[4]) + uInt32HexStr(msk_signature[3]) + uInt32HexStr(msk_signature[2]) + uInt32HexStr(msk_signature[1]) +	uInt32HexStr(msk_signature[0])	

	
	print "%2d" % phase_shifts, acq_sign[4:], exp_sign[4:], status #, retries, errors
	
	##########
	rem = phase_shifts%2
	even_shifts = 6#4
	odd_shifts  = 6#8
	if rem==0:
		shifts = even_shifts
	else:
		shifts = odd_shifts
	##########
	exp_carry[4] = exp_signature[4]/(2**(16-shifts))
	exp_carry[3] = exp_signature[3]/(2**(32-shifts))
	exp_carry[2] = exp_signature[2]/(2**(32-shifts))
	exp_carry[1] = exp_signature[1]/(2**(32-shifts))
	exp_carry[0] = exp_signature[0]/(2**(32-shifts))

	exp_signature[4] = ((exp_signature[4] << shifts) & 0xffff)     + exp_carry[3]
	exp_signature[3] = ((exp_signature[3] << shifts) & 0xffffffff) + exp_carry[2]
	exp_signature[2] = ((exp_signature[2] << shifts) & 0xffffffff) + exp_carry[1]
	exp_signature[1] = ((exp_signature[1] << shifts) & 0xffffffff) + exp_carry[0]
	exp_signature[0] = ((exp_signature[0] << shifts) & 0xffffffff) + exp_carry[4]

	msk_carry[4] = msk_signature[4]/(2**(16-shifts))
	msk_carry[3] = msk_signature[3]/(2**(32-shifts))
	msk_carry[2] = msk_signature[2]/(2**(32-shifts))
	msk_carry[1] = msk_signature[1]/(2**(32-shifts))
	msk_carry[0] = msk_signature[0]/(2**(32-shifts))

	msk_signature[4] = ((msk_signature[4] << shifts) & 0xffff)     + msk_carry[3]
	msk_signature[3] = ((msk_signature[3] << shifts) & 0xffffffff) + msk_carry[2]
	msk_signature[2] = ((msk_signature[2] << shifts) & 0xffffffff) + msk_carry[1]
	msk_signature[1] = ((msk_signature[1] << shifts) & 0xffffffff) + msk_carry[0]
	msk_signature[0] = ((msk_signature[0] << shifts) & 0xffffffff) + msk_carry[4]

	
print "--+------------------------------------+------------------------------------+--"
print 